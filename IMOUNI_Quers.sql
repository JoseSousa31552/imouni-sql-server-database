USE ImobiliariaDB;
GO

-- =========================== --
--      1.GESTÃO DE STOCK      --
-- =========================== --

-- =========================================================================
-- 1.1. Total de imóveis sob gestão por Cidade e Tipo
-- =========================================================================
SELECT 
    L.NomeLocalidade AS Cidade,
    TI.Descricao AS TipoImovel,
    COUNT(I.ID_Imovel) AS TotalImoveis
FROM Imovel I
 JOIN CodigoPostal CP ON I.ID_CodPostal = CP.ID_CodigoPostal
 JOIN Localidade L ON CP.ID_Localidade = L.ID_Localidade
 JOIN TipoImovel TI ON I.ID_TipoImovel = TI.ID_TipoImovel
GROUP BY L.NomeLocalidade, TI.Descricao
ORDER BY L.NomeLocalidade, TotalImoveis DESC;


-- =========================================================================
-- 1.2. Imóveis Disponíveis por Cidade e Faixa de Preço
-- Objetivo: Pesquisa operacional (ex: Porto, entre 150k e 300k).
-- Nota: Excluímos imóveis que tenham transações concluídas (Venda ou Arrendamento).
-- =========================================================================
SELECT 
    I.Morada,
    L.NomeLocalidade,
    TI.Descricao AS Tipo,
    I.Preco
FROM Imovel I
JOIN CodigoPostal CP ON I.ID_CodPostal = CP.ID_CodigoPostal
JOIN Localidade L ON CP.ID_Localidade = L.ID_Localidade
JOIN TipoImovel TI ON I.ID_TipoImovel = TI.ID_TipoImovel
LEFT JOIN Transacao T ON I.ID_Imovel = T.ID_Imovel AND T.ID_EstadoTransacao = 2 -- Concluída
WHERE T.ID_Transacao IS NULL 
  AND L.NomeLocalidade = 'Matosinhos '
  AND I.Preco BETWEEN 150000 AND 300000;

-- ===================================================================================
-- 1.3. Análise de Características: Procurar imóveis que tenham atributos específicos, 
-- como número mínimo de quartos e presença de piscina ou garagem.                     
-- ===================================================================================

SELECT
i.ID_Imovel,
i.Preco,
ti.Descricao AS Tipo_de_Imovel,
ci.Quartos AS Numero_Quartos,
ci.NumeroWC AS Numero_WC,
ci.Garagem,
ci.Piscina
FROM Imovel i
 JOIN CaracteristicasImovel ci ON i.ID_CaracteristicasImovel = ci.ID_CaracteristicasImovel
 JOIN TipoImovel ti ON i.ID_TipoImovel = ti.ID_TipoImovel
WHERE
ci.Quartos >= 4
AND ci.NumeroWC >= 4
AND ci.Garagem = 1
AND ci.Piscina = 1;

-- ========================= --
--  2.Performance de Vendas  --
-- ========================= --

-- =========================================================================
-- 2.1. Clientes com maior número de transações (Top 10)
-- Nota: Conta envolvimento tanto como Comprador ou Proprietário.
-- =========================================================================
SELECT TOP 10
    C.Nome,
    COUNT(T.ID_Transacao) AS TotalTransacoesEnvolvido
FROM Cliente C
 JOIN Transacao T 
    ON C.ID_Cliente = T.ID_ClienteComprador 
    OR C.ID_Cliente = T.ID_ClienteProprietario
GROUP BY C.Nome
ORDER BY TotalTransacoesEnvolvido DESC;

-- =========================================================================
--  2.2. Valor Médio de Venda por Agente
--  Objetivo: Perceber quem vende os imóveis de gama mais alta.
--  Nota: Filtramos apenas 'Venda' para não misturar rendas (valores baixos).
--  =========================================================================
SELECT 
    A.Nome AS Agente,
    COUNT(T.ID_Transacao) AS TotalVendasRealizadas,
    CAST(AVG(T.ValorFinal) AS DECIMAL(18,2)) AS ValorMedioPorVenda
FROM Agente A
 JOIN Transacao T ON A.ID_Agente = T.ID_Agente
 JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
WHERE TT.Descricao = 'Venda'
GROUP BY A.Nome
ORDER BY ValorMedioPorVenda DESC;

-- =========================================================================
-- 2.3. Velocidade de Venda por Agente
-- Objetivo: Qual agente vende mais rápido?
-- =========================================================================
SELECT 
    A.Nome AS Agente,
    AVG(DATEDIFF(DAY, I.DataEntrada, T.DataInicio)) AS MediaDiasParaVender
FROM Transacao T
 JOIN Imovel I 
    ON T.ID_Imovel = I.ID_Imovel
 JOIN TipoTransacao TT 
    ON T.ID_TipoTransacao = TT.ID_TipoTransacao
 JOIN Agente A 
    ON T.ID_Agente = A.ID_Agente
WHERE TT.Descricao = 'Venda'
GROUP BY A.Nome
ORDER BY MediaDiasParaVender ASC;

-- ====================================================================================== --
-- 2.4. Diferença de Preço: Uma consulta que compare o Preco original					  --
-- na tabela Imovel com o ValorFinal na tabela Transacao para ver a margem de negociação  --
-- ====================================================================================== --

SELECT 
	I.Preco,
	T.ValorFinal,
	(I.Preco - T.ValorFinal) AS Desconto,
	CAST(((I.Preco - T.ValorFinal) / I.Preco) * 100 AS DECIMAL(10,2)) AS Percentagem_Desconto
FROM Imovel I
 JOIN Transacao T ON I.ID_Imovel = T.ID_Imovel
 JOIN EstadoTransacao ET ON T.ID_EstadoTransacao = ET.ID_EstadoTransacao
 JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
WHERE ET.ID_EstadoTransacao = 2
AND TT.ID_TipoTransacao = 1
ORDER BY Percentagem_Desconto DESC;

-- ===================================================
-- 2.5. Conversão de Propostas: Uma taxa de conversão
-- (Número de Propostas vs. Transações Concluídas). 
-- ===================================================

SELECT 
    COUNT(P.ID_Proposta) AS TotalPropostas,
    COUNT(T.ID_Transacao) AS VendasConcluidas,
    CAST(COUNT(T.ID_Transacao) * 100.0 / COUNT(P.ID_Proposta) AS DECIMAL(10,2)) AS TaxaConversao_Percent
FROM Proposta P
    LEFT JOIN Transacao T ON P.ID_Imovel = T.ID_Imovel AND T.ID_EstadoTransacao = 2
HAVING COUNT(P.ID_Proposta) > 0;

-- ======================== --
--   3.Análise de Agentes   --
-- ======================== --

-- ==========================================================================
-- 3.1. Número de imóveis vendidos/arrendados por Agente e Comissões
-- Nota: Usa LEFT JOIN para incluir transações mesmo sem pagamento registado.
-- ==========================================================================
SELECT 
    A.Nome AS Agente,
    TT.Descricao AS TipoTransacao,
    COUNT(T.ID_Transacao) AS QtdTransacoes,
    ISNULL(SUM(P.ValorPagamento), 0) AS TotalComissoesRecebidas
FROM Agente A
 JOIN Transacao T ON A.ID_Agente = T.ID_Agente
 JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
LEFT JOIN Pagamento P ON T.ID_Transacao = P.ID_Transacao 
    AND P.ID_TipoPagamento = (SELECT ID_TipoPagamento FROM TipoPagamento WHERE Descricao = 'Comissão')
GROUP BY A.Nome, TT.Descricao
ORDER BY A.Nome;

-- ========================================================================================================
--	3.2. Cálculo de Comissões: Listar as comissões geradas por agente, aplicando a percentagem individual  
--	sobre o valor dos contratos celebrados.															       
-- ========================================================================================================

SELECT
a.ID_Agente,
a.Nome,
CAST(SUM(t.ValorFinal * (a.PercentagemComissao / 100)) AS DECIMAL (18,2)) AS TotalComissões
FROM Agente a
 JOIN Transacao t ON a.ID_Agente = t.ID_Agente
 JOIN EstadoTransacao et ON t.ID_EstadoTransacao = et.ID_EstadoTransacao
WHERE et.ID_EstadoTransacao = 2
GROUP BY a.ID_Agente, a.Nome
ORDER BY TotalComissões DESC


-- ======================== --
--   4.Análise de Mercado   --
-- ======================== --

-- =========================================================================
-- 4.1. Tempo médio que um imóvel permanece disponível antes de ser vendido
-- Nota: Diferença em DIAS entre a entrada do imóvel e o início da venda.
-- =========================================================================
SELECT 
    AVG(DATEDIFF(DAY, I.DataEntrada, T.DataInicio)) AS MediaDiasAteVenda
FROM Transacao T
 JOIN Imovel I ON T.ID_Imovel = I.ID_Imovel
 JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
 JOIN EstadoTransacao ET ON T.ID_EstadoTransacao = ET.ID_EstadoTransacao
WHERE TT.Descricao = 'Venda'
AND ET.Descricao != 'Cancelada';

-- =========================================================================
-- 4.2. Velocidade de Venda por Tipo de Imóvel
-- Objetivo: Qual o tipo de produto com maior liquidez?
-- =========================================================================
SELECT 
    TI.Descricao,
    AVG(DATEDIFF(DAY, I.DataEntrada, T.DataInicio)) AS MediaDiasParaVender
FROM Transacao T
 JOIN Imovel I ON T.ID_Imovel = I.ID_Imovel
 JOIN TipoImovel TI ON I.ID_TipoImovel = TI.ID_TipoImovel
 JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
WHERE TT.Descricao = 'Venda'
GROUP BY TI.Descricao
ORDER BY MediaDiasParaVender ASC; 

-- =========================================================================
--  4.3. Imóveis com preço acima da média geral
--  Objetivo: Identificar ativos valorizados face à média do portfólio. 
-- =========================================================================
SELECT 
    L.NomeLocalidade AS Cidade,
    TI.Descricao AS TipoImovel,
    I.Morada,
    I.Preco
FROM Imovel I
 JOIN CodigoPostal CP ON I.ID_CodPostal = CP.ID_CodigoPostal
 JOIN Localidade L ON CP.ID_Localidade = L.ID_Localidade
 JOIN TipoImovel TI ON I.ID_TipoImovel = TI.ID_TipoImovel
WHERE I.Preco > (
    SELECT AVG(Preco) 
    FROM Imovel
)
ORDER BY I.Preco DESC;

-- =========================================================================
-- 4.4. Imóveis com maior número de Propostas recebidas
-- Objetivo: Medir a procura/pressão do mercado sobre ativos específicos.
-- =========================================================================
SELECT TOP 5
    I.Morada,
    COUNT(P.ID_Proposta) AS TotalPropostasRecebidas,
    MAX(P.ValorProposto) AS MelhorOfertaAteHoje
FROM Imovel I
 JOIN Proposta P ON I.ID_Imovel = P.ID_Imovel
GROUP BY I.ID_Imovel, I.Morada
ORDER BY TotalPropostasRecebidas DESC;

-- ======================== --
--   5.Análise Financeira   --
-- ======================== --

-- =========================================================================
-- 5.1. Valor total de Vendas e Rendas num período (Ex: Ano 2024)
-- =========================================================================
SELECT 
    TT.Descricao AS TipoTransacao,
    SUM(T.ValorFinal) AS ValorTotalMovimentado
FROM Transacao T
JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
WHERE T.DataInicio BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY TT.Descricao;

-- =========================================================================
-- 5.2. Sazonalidade: Volume de Vendas por Mês
-- Objetivo: Perceber em que meses se fecha mais negócios.
-- =========================================================================
SELECT 
    MONTH(T.DataInicio) AS Mes,
    COUNT(T.ID_Transacao) AS TotalTransacoes,
    SUM(T.ValorFinal) AS VolumeFaturado
FROM Transacao T
WHERE YEAR(T.DataInicio) = 2024 
GROUP BY MONTH(T.DataInicio)
ORDER BY Mes;

-- =========================================================================
-- 5.3. Contratos de Arrendamento Ativos e Rendas
-- Objetivo: Saber quanto dinheiro entra fixo por mês (Cashflow recorrente).
-- =========================================================================
SELECT 
    T.ID_Transacao AS Contrato,
    I.Morada,
    C_Inq.Nome AS Inquilino,
    T.ValorFinal AS RendaMensal,
    T.DataInicio,
    T.DataFim
FROM Transacao T
JOIN Imovel I ON T.ID_Imovel = I.ID_Imovel
JOIN Cliente C_Inq ON T.ID_ClienteComprador = C_Inq.ID_Cliente
JOIN TipoTransacao TT ON T.ID_TipoTransacao = TT.ID_TipoTransacao
JOIN EstadoTransacao ET ON T.ID_EstadoTransacao = ET.ID_EstadoTransacao
WHERE TT.Descricao = 'Arrendamento'
  AND ET.Descricao = 'Em Curso' 
  AND (T.DataFim IS NULL OR T.DataFim > GETDATE()); 

  -- =========================================================================
-- 5.4. Valor Total do Portfólio Ativo (Não Vendido)
-- Objetivo: Saber quanto capital "potencial" a imobiliária tem em mãos.
-- Nota: Consideramos "Não Vendido" se não estiver numa transação concluída.
-- =========================================================================
SELECT 
    TI.Descricao AS TipoImovel,
    COUNT(I.ID_Imovel) AS QtdStock,
    SUM(I.Preco) AS ValorTotalEmCarteira
FROM Imovel I
 JOIN TipoImovel TI ON I.ID_TipoImovel = TI.ID_TipoImovel
LEFT JOIN Transacao T ON I.ID_Imovel = T.ID_Imovel AND T.ID_EstadoTransacao = 2 -- 2 = Concluída
WHERE T.ID_Transacao IS NULL 
GROUP BY TI.Descricao;

-- =========================== --
--   6.Histórico e Auditoria   --
-- =========================== --

-- =========================================================================
-- 6.1. Histórico de Estados de um Imóvel (Timeline)
-- Objetivo: Ver alterações de estado (ex: De 'Em Construção' para 'Novo')
-- =========================================================================
SELECT 
    I.Morada,
    EI.Descricao AS Estado,
    H.DataInicio,
    -- Tratamento estético: Se for NULL, mostra 'Atualmente'
    ISNULL(CONVERT(VARCHAR, H.DataFim, 23), 'Atualmente') AS DataFim,
    DATEDIFF(DAY, H.DataInicio, ISNULL(H.DataFim, GETDATE())) AS DiasNesteEstado
FROM Historico_Estado_Imovel H
 JOIN Imovel I ON H.ID_Imovel = I.ID_Imovel
 JOIN EstadoImovel EI ON H.ID_EstadoImovel = EI.ID_EstadoImovel
WHERE I.ID_Imovel = 2 
ORDER BY H.DataInicio DESC;

-- =============================================================================
-- 6.2. Tempo de Carteira: Calcular há quantos dias cada imóvel está no sistema
-- desde a sua data de entrada até existir alguma transação				      
-- =============================================================================

SELECT
i.ID_Imovel,
i.Morada,
i.DataEntrada,
MIN(t.DataInicio) AS DataPrimeiraTransacao,
DATEDIFF(DAY, i.DataEntrada, MIN(t.DataInicio)) AS DiasEmCarteira
FROM Imovel i
 JOIN Transacao t ON i.ID_Imovel = t.ID_Imovel
GROUP BY i.ID_Imovel, i.Morada, i.DataEntrada;

