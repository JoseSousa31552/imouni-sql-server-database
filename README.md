# ImoUni — Base de Dados para Gestão Imobiliária

Base de dados relacional em **Microsoft SQL Server** para uma mediadora imobiliária, com modelação de dados, implementação da estrutura (DDL) e um conjunto de consultas SQL operacionais e analíticas.

> Projeto da unidade curricular **Armazenamento e Acesso a Dados** (2025/2026) — Licenciatura em Engenharia de Sistemas Informáticos, Instituto Politécnico do Cávado e do Ave (IPCA).

---

## Sobre o projeto

O objetivo é conceber e implementar uma base de dados relacional que responda aos requisitos de gestão de uma mediadora imobiliária, resolvendo o problema da **dispersão de informação** através de uma única estrutura relacional.

As entidades fundamentais do negócio são:

- **Imóveis** (com características, tipo, estado e histórico de estados)
- **Clientes** (proprietários e compradores/arrendatários, com preferências de pesquisa)
- **Agentes** (com percentagem de comissão)
- **Propostas, transações e pagamentos** (vendas e arrendamentos)

O desenvolvimento segue três etapas:

1. **Modelação de dados:** definição do modelo conceptual e conversão para um modelo relacional normalizado, garantindo integridade e evitando redundâncias.
2. **Implementação (DDL):** criação da estrutura física, com tipos de dados, chaves primárias e estrangeiras (PK/FK) e restrições de domínio (*constraints*).
3. **Exploração de dados (DML):** desenvolvimento de queries SQL para questões operacionais (ex.: listagem de imóveis disponíveis) e analíticas (ex.: comissões e desempenho de vendas).

---

## Modelação

### Modelo conceptual (MER)

O Modelo Entidade-Relacionamento representa a estrutura de dados da ImoUni e as regras de negócio identificadas.

(encontram-se no relatorio)

### Modelo relacional

O modelo relacional é composto por **22 tabelas**. Para garantir a normalização, as relações muitos-para-muitos (N:N) foram decompostas em relações um-para-muitos (1:N) através de **tabelas associativas** (`AgenteImovel`, `ClienteAgente` e `ClienteTipo`).

(encontram-se no relatorio)

Principais grupos de tabelas:

| Grupo | Tabelas |
| --- | --- |
| Imóveis | `Imovel`, `CaracteristicasImovel`, `TipoImovel`, `EstadoImovel`, `Historico_Estado_Imovel` |
| Clientes | `Cliente`, `TipoCliente`, `ClienteTipo`, `PreferenciasCliente`, `ClienteAgente` |
| Agentes | `Agente`, `AgenteImovel` |
| Negócio | `Proposta`, `Transacao`, `TipoTransacao`, `EstadoTransacao` |
| Pagamentos | `Pagamento`, `TipoPagamento`, `MetodoPagamento` |
| Localização | `Distritos`, `Localidade`, `CodigoPostal` |

---

## Como executar

**Requisitos:** Microsoft SQL Server e SQL Server Management Studio (SSMS).

1. Abrir o **SSMS** e ligar ao servidor SQL Server.
2. Executar, **por esta ordem**, os scripts da pasta `sql/`:
   1. `01_schema.sql` — cria a base de dados e as tabelas, com chaves e restrições.
   2. `02_inserts.sql` — povoa a base de dados com dados de teste.
   3. `03_queries.sql` — contém as consultas; podem ser executadas individualmente.

> A ordem é importante: os dados dependem das tabelas e as consultas dependem dos dados.

---

## Consultas

O ficheiro `03_queries.sql` reúne **20 consultas** organizadas em seis áreas.

### 1. Gestão de stock

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 1.1 | Total de imóveis sob gestão por cidade e tipo | `COUNT`, `JOIN`, `GROUP BY` |
| 1.2 | Imóveis disponíveis por cidade e faixa de preço | Classificação por intervalos, `COUNT` |
| 1.3 | Análise de características (mínimo de quartos, piscina, garagem) | Filtros por atributos |

### 2. Performance de vendas

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 2.1 | Clientes com maior número de transações (Top 10) | `COUNT`, `ORDER BY` |
| 2.2 | Valor médio de venda por agente | `AVG` |
| 2.3 | Velocidade de venda por agente | `AVG(DATEDIFF)` |
| 2.4 | Diferença entre preço base e valor final da transação | Cálculo de desconto e percentagem |
| 2.5 | Taxa de conversão de propostas em transações concluídas | `COUNT`, percentagem |

### 3. Análise de agentes

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 3.1 | Imóveis vendidos/arrendados por agente e comissões | `COUNT`, `SUM`, `LEFT JOIN` |
| 3.2 | Total de comissões geradas por agente | `SUM`, ordenação descendente |

### 4. Análise de mercado

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 4.1 | Tempo médio que um imóvel permanece disponível antes de ser vendido | `DATEDIFF`, `AVG` |
| 4.2 | Velocidade de venda por tipo de imóvel | `AVG(DATEDIFF)` |
| 4.3 | Imóveis com preço acima da média geral | Subquery com `AVG` |
| 4.4 | Top 5 imóveis com mais propostas recebidas | `COUNT`, `ORDER BY` |

### 5. Análise financeira

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 5.1 | Valor total de vendas e rendas num período | `SUM`, filtro por data e tipo |
| 5.2 | Sazonalidade: volume de vendas por mês | Agrupamento por ano/mês, `COUNT` |
| 5.3 | Contratos de arrendamento ativos e respetivas rendas | Filtro por contratos ativos |
| 5.4 | Valor total do portfólio ativo (imóveis não vendidos) | `SUM` |

### 6. Histórico e auditoria

| ID | Descrição | Técnicas |
| --- | --- | --- |
| 6.1 | Histórico de estados de um imóvel (timeline) | Ordenação temporal |
| 6.2 | Dias que cada imóvel demora a ter a primeira transação | `DATEDIFF` |

### Exemplo de resultado

**Consulta 2.5 — Conversão de propostas**

| TotalPropostas | VendasConcluidas | TaxaConversao_Percent |
| --- | --- | --- |
| 10 | 5 | 50.00 |

**Consulta 3.2 — Comissões por agente**

| ID_Agente | Nome | TotalComissões |
| --- | --- | --- |
| 2 | Sofia Almeida | 21750.00 |
| 1 | Rui Martins | 19365.00 |
| 3 | Tiago Pinto | 9900.00 |

O relatório em [`docs/relatorio.pdf`](relatorio.pdf) inclui os resultados de todas as consultas.

---

## Dados de teste

Os dados presentes em `02_inserts.sql` são **sintéticos**. Foi utilizada Inteligência Artificial Generativa (ChatGPT / LLMs) como apoio à geração dos dados (*data seeding*), de forma a povoar a base de dados com um volume significativo de registos consistentes (clientes, moradas, históricos) e a diversificar os cenários de teste. Nenhum dos nomes ou valores corresponde a pessoas ou transações reais.

---

## Tecnologias

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- Git e GitHub

---

## Aprendizagens

- Importância de uma **definição rigorosa dos diagramas e do modelo de dados numa fase inicial**, que facilita a escrita das queries, melhora a legibilidade do código e contribui para a consistência dos resultados.
- Utilização de **joins** e **subqueries**, bem como de instruções **DML** e **DDL**.
- Decomposição de relações N:N em tabelas associativas para garantir a normalização.
