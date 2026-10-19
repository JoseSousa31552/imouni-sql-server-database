USE ImobiliariaDB;
GO


INSERT INTO Distrito (NomeDistrito) VALUES
('Porto'),
('Braga'),
('Viana do Castelo'),
('Vila Real');

INSERT INTO Localidade (NomeLocalidade, ID_Distrito) VALUES
('Porto', 1),
('Matosinhos', 1),
('Braga', 2),
('Guimarães', 2),
('Viana do Castelo', 3),
('Vila Real', 4);

INSERT INTO CodigoPostal (CodigoPostal, ID_Localidade) VALUES
('4000-001', 1),
('4050-123', 1),
('4450-100', 2),
('4710-001', 3),
('4800-010', 4),
('4900-001', 5),
('5000-100', 6),
('4450-200', 2),
('4715-120', 3),
('4050-250', 1);

INSERT INTO TipoCliente (Descricao) VALUES
('Proprietário'),
('Comprador'),
('Arrendatário');

INSERT INTO TipoImovel (Descricao) VALUES
('Apartamento'),
('Moradia'),
('Terreno');

INSERT INTO EstadoImovel (Descricao) VALUES
('Disponivel'),
('Reservado'),
('Vendido'),
('Arrendado'),
('Em Manutenção');

INSERT INTO TipoTransacao (Descricao) VALUES
('Venda'),
('Arrendamento');

INSERT INTO EstadoTransacao (Descricao) VALUES
('Em Curso'),
('Concluída'),
('Cancelada');

-- Variação de tipos de pagamento (inclui Pagamento Final)
-- IDs esperados:
-- 1 Comissão, 2 Renda, 3 Sinal, 4 Pagamento Final, 5 Caução, 6 Reserva
INSERT INTO TipoPagamento (Descricao) VALUES
('Comissão'),
('Renda'),
('Sinal'),
('Pagamento Final'),
('Caução'),
('Reserva');

INSERT INTO MetodoPagamento (Descricao) VALUES
('Transferência'), -- 1
('Numerário'),     -- 2
('Cheque');        -- 3

GO

/* =========================================================
   2) AGENTES
   ========================================================= */

INSERT INTO Agente (Nome, NIF, Telefone, PercentagemComissao, DataAdmissao, ID_CodigoPostal) VALUES
('Rui Martins',   '240000001', '220000001', 3.00, '2024-02-01', 1),
('Sofia Almeida', '240000002', '220000002', 2.50, '2024-06-15', 4),
('Tiago Pinto',   '240000003', '220000003', 2.75, '2025-01-10', 6);

GO

/* =========================================================
   3) CLIENTES + CLIENTETIPO
   ========================================================= */

INSERT INTO Cliente (Nome, NIF, Morada, Email, Telefone, DataRegisto, ID_CodPostal) VALUES
('Ana Silva',      '250000001', 'Rua de Cedofeita, Porto',        'ana.silva@norte.pt',      '910000001', '2024-01-20', 2),
('Bruno Costa',    '250000002', 'Av. da Boavista, Porto',         'bruno.costa@norte.pt',    '910000002', '2024-02-05', 10),
('Carla Mendes',   '250000003', 'Rua Brito Capelo, Matosinhos',   'carla.mendes@norte.pt',   '910000003', '2024-03-12', 3),
('Diogo Rocha',    '250000004', 'Rua do Souto, Braga',            'diogo.rocha@norte.pt',    '910000004', '2024-04-02', 4),
('Eva Santos',     '250000005', 'Largo do Toural, Guimarães',     'eva.santos@norte.pt',     '910000005', '2024-05-18', 5),
('Filipe Gomes',   '250000006', 'Rua da Ribeira, Porto',          'filipe.gomes@norte.pt',   '910000006', '2024-07-08', 1),
('Gisela Pires',   '250000007', 'Rua de Leça, Matosinhos',        'gisela.pires@norte.pt',   '910000007', '2024-09-10', 8),
('Hugo Leite',     '250000008', 'Av. Central, Braga',             'hugo.leite@norte.pt',     '910000008', '2025-02-11', 9),
('Inês Matos',     '250000009', 'Rua da Bandeira, Porto',         'ines.matos@norte.pt',     '910000009', '2025-04-22', 2),
('João Fonseca',   '250000010', 'Av. Carvalho Araújo, Vila Real', 'joao.fonseca@norte.pt',   '910000010', '2025-06-03', 7);

INSERT INTO ClienteTipo (ID_Cliente, ID_TipoCliente) VALUES
(1, 2), (1, 3),
(2, 2),
(3, 1), (3, 2),
(4, 1),
(5, 1),
(6, 2),
(7, 3),
(8, 2),
(9, 2),
(10,1), (10,2);

GO

/* =========================================================
   4) IMÓVEIS + AGENTEIMOVEL
   ========================================================= */

INSERT INTO CaracteristicasImovel 
(AreaM2, NumeroWC, Quartos, Garagem, Piscina) VALUES
(78,  1, 2, 0, 0),
(105, 2, 3, 1, 0),
(210, 3, 4, 1, 1),
(55,  1, 1, 0, 0),
(140, 2, 3, 1, 0),
(95,  2, 2, 1, 0),
(180, 3, 4, 1, 1),
(65,  1, 1, 0, 0),
(125, 2, 3, 1, 0),
(300, 4, 5, 1, 1);

INSERT INTO Imovel (Morada, Latitude, Longitude, Preco, DataEntrada,
                    ID_Proprietario, ID_CodPostal, ID_CaracteristicasImovel, ID_TipoImovel)
VALUES
('Rua de Santa Catarina, Porto',          41.149610, -8.610990, 245000.00, '2024-02-10', 3,  2,  1, 1),
('Av. da Boavista, Porto',                41.160200, -8.642900, 420000.00, '2024-03-05', 4, 10,  2, 1),
('Rua Brito Capelo, Matosinhos',          41.182500, -8.689200, 195000.00, '2024-04-08', 5,  3,  4, 1),
('Av. Central, Braga',                    41.551800, -8.425400, 310000.00, '2024-06-20',10,  4,  5, 2),
('Largo do Toural, Guimarães',            41.444200, -8.296300, 285000.00, '2024-08-01', 5,  5,  6, 2),
('Rua da Bandeira, Porto',                41.147900, -8.614000, 160000.00, '2024-09-18', 4,  1,  8, 1),
('Av. Dr. António Macedo, Viana Castelo', 41.693200, -8.834900, 365000.00, '2025-01-12',10,  6,  7, 2),
('Av. Carvalho Araújo, Vila Real',        41.300600, -7.744100, 220000.00, '2025-02-25',10,  7,  9, 1),
('Rua de Leça, Matosinhos',               41.200100, -8.699300, 155000.00, '2025-04-10', 3,  8,  3, 3),
('Rua do Souto, Braga',                   41.552200, -8.422900, 590000.00, '2025-07-05', 4,  9, 10, 2);

INSERT INTO AgenteImovel (ID_Agente, ID_Imovel) VALUES
(1,1),(1,2),(1,6),
(2,3),(2,4),(2,5),(2,10),
(3,7),(3,8),(3,9);

GO

/* =========================================================
   5) PREFERÊNCIAS CLIENTE (Localidade)
   ========================================================= */

INSERT INTO PreferenciasCliente (PrecoMin, PrecoMax, ID_Cliente, ID_TipoImovel, ID_Localidade) VALUES
(140000, 260000, 1, 1, 1),
(180000, 320000, 2, 1, 2),
(250000, 450000, 3, 2, 1),
(200000, 350000, 4, 2, 3),
(160000, 300000, 5, 1, 4),
(120000, 200000, 6, 1, 1),
(130000, 210000, 7, 1, 2),
(240000, 420000, 8, 2, 3),
(200000, 380000, 9, 2, 5),
(150000, 260000,10, 1, 6);

GO

/* =========================================================
   6) TRANSAÇÕES - 10 (SEM CANCELADAS)
   ========================================================= */

-- EstadoTransacao: 1 Em Curso, 2 Concluída
INSERT INTO Transacao (DataInicio, DataFim, Duracao, ValorFinal,
                       ID_Imovel, ID_ClienteProprietario, ID_ClienteComprador,
                       ID_Agente, ID_TipoTransacao, ID_EstadoTransacao)
VALUES                                -- ID Imo,Pro,Com,Ag,Tip,Estad
('2024-03-01','2024-04-15', NULL, 235000.00,  1,  3,  2, 1, 1, 2),
('2024-04-20','2024-06-10', NULL, 410000.00,  2,  4,  9, 1, 1, 2),
('2024-05-10','2025-05-10',  12 , 700.00,     3,  5,  1, 2, 2, 1),
('2024-10-01','2026-10-01',  24 , 500.00,     6,  4,  7, 1, 2, 2),
('2024-09-05','2024-10-25', NULL, 295000.00,  4, 10,  6, 2, 1, 2),
('2025-01-20', '2026-01-20', 12 , 950.00,     5,  5,  8, 2, 2, 1),
('2025-02-05','2025-03-01', NULL, 360000.00,  7, 10,  9, 3, 1, 2),
('2025-03-15', '2026-03-15', 12,  800.00,     8, 10,  1, 3, 2, 1),
('2025-05-02', '2025-08-10', NULL, 140000.00,  9, 5,  2, 2, 1, 1),
('2025-09-01','2025-12-10', NULL, 575000.00, 10,  4,  2, 2, 1, 2);

GO

-- =========================================================
--   7) PROPOSTAS - 10
-- =========================================================

INSERT INTO Proposta (ValorProposto, DataProposta, Decisao, ID_Cliente, ID_Agente, ID_Imovel, ID_Transacao) VALUES
                         --   Cli,Ag,Imo,Trans
(235000.00, '2024-03-05', 1,    2, 1,  1,  1),
(405000.00, '2024-05-05', 1,    9, 1,  2,  2),
(  700.00,  '2024-05-12', 1,    1, 2,  3,  3),
(  500.00,  '2024-06-25', 0,    7, 2,  3, NULL),
(290000.00, '2024-09-10', 1,    6, 2,  4,  5),
(280000.00, '2025-02-01', NULL, 8, 2,  5,  6),
(355000.00, '2025-02-10', 1,    9, 3,  7,  7),
(  750.00,  '2025-01-25', NULL, 1, 3,  8,  8),
(  780.00,  '2025-01-29', 0,    2, 2,  8,  NULL),
(570000.00, '2025-09-05', 1,    2, 2, 10, 10);

GO

-- =========================================================
--   8) PAGAMENTOS - VARIADOS (TIPO + MÉTODO)
-- =========================================================

-- Tipos: 1 - Comissão, 2 - Renda, 3 - Sinal, 4 - Pagamento Final, 5 - Caução, 6 - Reserva
-- Métodos: 1 - Transferência, 2 - Numerário, 3 - Cheque

/* Venda T1 (235000): Reserva + Sinal + Final + Comissão */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2024-02-25',  1500.00,  1, 2, 6), -- Reserva (Numerário)
('2024-03-10',  7000.00,  1, 1, 3), -- Sinal (Transferência)
('2024-04-15',226500.00,  1, 1, 4), -- Pagamento Final (Transferência)
('2024-04-16',  7050.00,  1, 3, 1); -- Comissão (Cheque)

/* Venda T2 (410000): Reserva + Sinal + Final + Comissão */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2024-04-25',  2000.00,  2, 1, 6), -- Reserva (Transferência)
('2024-05-10', 12000.00,  2, 3, 3), -- Sinal (Cheque)
('2024-06-10',396000.00,  2, 1, 4), -- Pagamento Final (Transferência)
('2024-06-11', 10250.00,  2, 2, 1); -- Comissão (Numerário)

/* Arrendamento T3: Caução + rendas */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2024-05-12',   950.00,  3, 1, 5), -- Caução (Transferência)
('2024-06-01',   950.00,  3, 2, 2), -- Renda (Numerário)
('2024-07-05',   950.00,  3, 1, 2), -- Renda (Transferência)
('2024-08-05',   950.00,  3, 3, 2); -- Renda (Cheque)

/* Arrendamento T4: Caução + 1 renda (exemplo de curta duração) */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2024-07-01',   900.00,  4, 2, 5), -- Caução (Numerário)
('2024-07-02',   900.00,  4, 2, 2); -- Renda (Numerário)

/* Venda T5 (295000): Reserva + Sinal + Final + Comissão */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2024-09-07',  1000.00,  5, 2, 6), -- Reserva (Numerário)
('2024-09-15',  9000.00,  5, 1, 3), -- Sinal (Transferência)
('2024-10-25',284000.00,  5, 1, 4), -- Pagamento Final (Transferência)
('2024-10-26',  7375.00,  5, 3, 1); -- Comissão (Cheque)

/* Venda T7 (360000): Reserva + Sinal + Final + Comissão */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2025-02-08',  1500.00,  7, 1, 6), -- Reserva (Transferência)
('2025-02-20', 10000.00,  7, 2, 3), -- Sinal (Numerário)
('2025-03-01',348500.00,  7, 1, 4), -- Pagamento Final (Transferência)
('2025-03-02',  9900.00,  7, 3, 1); -- Comissão (Cheque)

/* Arrendamento T8: caução + 1 renda */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2025-03-16',   780.00,  8, 3, 5), -- Caução (Cheque)
('2025-04-01',   780.00,  8, 1, 2); -- Renda (Transferência)

/* Venda T10 (575000): Reserva + Sinal + Final + Comissão */
INSERT INTO Pagamento (DataPagamento, ValorPagamento, ID_Transacao, ID_MetodoPagamento, ID_TipoPagamento)
VALUES 
('2025-09-10',  2500.00, 10, 1, 6), -- Reserva (Transferência)
('2025-09-20', 15000.00, 10, 3, 3), -- Sinal (Cheque)
('2025-10-10',557500.00, 10, 1, 4), -- Pagamento Final (Transferência)
('2025-10-11', 14375.00, 10, 2, 1); -- Comissão (Numerário)

GO

/* =========================================================
   9) HISTÓRICO DE ESTADO DO IMÓVEL
   ========================================================= */


INSERT INTO Historico_Estado_Imovel (ID_Imovel, ID_EstadoImovel, DataInicio, DataFim)
VALUES
/* Imovel 1: Disponível (Entrada) -> Reservado (Data Reserva) -> Vendido (Fim Transação) */
(1, 1, '2024-02-10', '2024-02-25'),
(1, 2, '2024-02-25', '2024-04-15'),
(1, 3, '2024-04-15', NULL),

/* Imovel 2: Disponível -> Reservado -> Vendido */
(2, 1, '2024-03-05', '2024-04-25'),
(2, 2, '2024-04-25', '2024-06-10'),
(2, 3, '2024-06-10', NULL),

/* Imovel 3: Disponível -> Arrendado */
(3, 1, '2024-04-08', '2024-05-10'),
(3, 4, '2024-05-10', NULL),

/* Imovel 4: Disponível -> Reservado -> Vendido */
(4, 1, '2024-06-20', '2024-09-07'),
(4, 2, '2024-09-07', '2024-10-25'),
(4, 3, '2024-10-25', NULL),

/* Imovel 5: Disponível -> Arrendado */
(5, 1, '2024-08-01', '2025-01-20'),
(5, 4, '2025-01-20', NULL),

/* Imovel 6: Disponível -> Arrendado */
(6, 1, '2024-09-18', '2024-10-01'),
(6, 4, '2024-10-01', NULL),

/* Imovel 7: Disponível -> Reservado -> Vendido */
(7, 1, '2025-01-12', '2025-02-08'),
(7, 2, '2025-02-08', '2025-03-01'),
(7, 3, '2025-03-01', NULL),

/* Imovel 8: Disponível -> Arrendado */
(8, 1, '2025-02-25', '2025-03-15'),
(8, 4, '2025-03-15', NULL),

/* Imovel 9: Disponível -> Vendido (Sem reserva registada nos pagamentos, transação direta) */
(9, 1, '2025-04-10', '2025-08-10'),
(9, 3, '2025-08-10', NULL),

/* Imovel 10: Disponível -> Reservado -> Vendido */
(10, 1, '2025-07-05', '2025-09-10'),
(10, 2, '2025-09-10', '2025-10-10'),
(10, 3, '2025-10-10', NULL);


/* =========================================================
    10)   CLIENTE–AGENTE

   ========================================================= */

INSERT INTO ClienteAgente (ID_Cliente, ID_Agente)
VALUES

/* Agente 1 – Rui Martins (Porto) */
(1, 1),   -- Ana Silva
(2, 1),   -- Bruno Costa
(6, 1),   -- Filipe Gomes
(9, 1),   -- Inês Matos

/* Agente 2 – Sofia Almeida (Braga / Guimarães) */
(3, 2),   -- Carla Mendes
(4, 2),   -- Diogo Rocha
(5, 2),   -- Eva Santos
(7, 2),   -- Gisela Pires

/* Agente 3 – Tiago Pinto (Viana / Vila Real) */
(8, 3),   -- Hugo Leite
(10, 3);  -- João Fonseca




