CREATE DATABASE ImobiliariaDB;
GO

USE ImobiliariaDB;
GO

-- ========================================= --
--      1. TABELAS DE TIPOS E ESTADOS        --
-- ========================================= --

CREATE TABLE Distrito (
    ID_Distrito INT IDENTITY(1,1) PRIMARY KEY,
    NomeDistrito VARCHAR(50) NOT NULL
);

CREATE TABLE Localidade (
    ID_Localidade INT IDENTITY(1,1) PRIMARY KEY,
    NomeLocalidade VARCHAR(100) NOT NULL,
    ID_Distrito INT FOREIGN KEY REFERENCES Distrito(ID_Distrito)
);

CREATE TABLE CodigoPostal (
    ID_CodigoPostal INT IDENTITY(1,1) PRIMARY KEY,
    CodigoPostal VARCHAR(50) NOT NULL,
    ID_Localidade INT NOT NULL
    FOREIGN KEY REFERENCES Localidade(ID_Localidade)
);

-- Tabela para armazenar Tipos de Cliente
-- Ex: Proprietário, Comprador, Arrendatário
CREATE TABLE TipoCliente (
    ID_TipoCliente INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(30) NOT NULL 
);

-- Tabela para armazenar tipos de Imvóvel
-- Ex: Apartamento, Moradia, Terreno
CREATE TABLE TipoImovel (
    ID_TipoImovel INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(30) NOT NULL 
);

-- Tabela para armazenar o estado do Imóvel
-- Ex: Novo, Usado, Para Recuperar
CREATE TABLE EstadoImovel (
    ID_EstadoImovel INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL 
);

-- Tabela para armazenar o tipo de Transação
-- Ex: Venda, Arrendamento
CREATE TABLE TipoTransacao (
    ID_TipoTransacao INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL 
);

-- Tabela para armazenar estados de Transação
-- Ex: Em Curso, Concluída, Cancelada
CREATE TABLE EstadoTransacao (
    ID_EstadoTransacao INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL 
);

-- Tabela para armazenar tipos de Pagamento
-- Ex: Comissão, Renda, Prestação
CREATE TABLE TipoPagamento (
    ID_TipoPagamento INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL 
);

-- Tabela para armazenar métodos de Pagamento
-- Ex: Transferência, Numerário, Cheque
CREATE TABLE MetodoPagamento (
    ID_MetodoPagamento INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL 
);

CREATE TABLE CaracteristicasImovel (
    ID_CaracteristicasImovel INT IDENTITY(1,1) PRIMARY KEY,
    AreaM2 INT NOT NULL,
    NumeroWC INT,
    Quartos INT,
    Garagem BIT,
    Piscina BIT
);

-- ======================================= --
-- 2. TABELAS DE ENTIDADES PRINCIPAIS      --
-- ======================================= --

CREATE TABLE Agente (
    ID_Agente INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    NIF VARCHAR(9) NOT NULL UNIQUE,
    Telefone VARCHAR(20) NOT NULL,
    PercentagemComissao DECIMAL(5,2),
    DataAdmissao DATETIME NOT NULL,
    ID_CodigoPostal INT FOREIGN KEY REFERENCES CodigoPostal(ID_CodigoPostal)
);

CREATE TABLE Cliente (
    ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    NIF VARCHAR(9) NOT NULL UNIQUE,
    Morada VARCHAR(100),
    Email VARCHAR(100),
    Telefone VARCHAR(20) NOT NULL,
    DataRegisto DATETIME NOT NULL,
    ID_CodPostal INT FOREIGN KEY REFERENCES CodigoPostal(ID_CodigoPostal)
);

CREATE TABLE Imovel (
    ID_Imovel INT IDENTITY(1,1) PRIMARY KEY,
    Morada VARCHAR(100),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    Preco DECIMAL(18,2) NOT NULL,
    DataEntrada DATETIME NOT NULL,
    
    -- Chaves Estrangeiras
    ID_Proprietario INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_CodPostal INT FOREIGN KEY REFERENCES CodigoPostal(ID_CodigoPostal),
    ID_CaracteristicasImovel INT FOREIGN KEY REFERENCES CaracteristicasImovel(ID_CaracteristicasImovel),
    ID_TipoImovel INT FOREIGN KEY REFERENCES TipoImovel(ID_TipoImovel),
    
);

-- ================================================ --
-- 3. TABELAS DE PROCESSOS (TRANSAÇÕES E PROPOSTAS) --
-- ================================================ --

CREATE TABLE Transacao (
    ID_Transacao INT IDENTITY(1,1) PRIMARY KEY,
    DataInicio DATETIME NOT NULL,
    DataFim DATETIME NULL,
    Duracao INT NULL,
    ValorFinal DECIMAL(18,2),
    
    -- Relacionamentos
    ID_Imovel INT FOREIGN KEY REFERENCES Imovel(ID_Imovel),
    ID_ClienteProprietario INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_ClienteComprador INT FOREIGN KEY REFERENCES Cliente(ID_Cliente), 
    ID_Agente INT FOREIGN KEY REFERENCES Agente(ID_Agente),
    ID_TipoTransacao INT FOREIGN KEY REFERENCES TipoTransacao(ID_TipoTransacao),
    ID_EstadoTransacao INT FOREIGN KEY REFERENCES EstadoTransacao(ID_EstadoTransacao)
    
);

CREATE TABLE Pagamento (
    ID_Pagamento INT IDENTITY(1,1) PRIMARY KEY,
    DataPagamento DATETIME NOT NULL,
    ValorPagamento DECIMAL(18,2) NOT NULL,
    
    ID_Transacao INT FOREIGN KEY REFERENCES Transacao(ID_Transacao),
    ID_MetodoPagamento INT FOREIGN KEY REFERENCES MetodoPagamento(ID_MetodoPagamento),
    ID_TipoPagamento INT FOREIGN KEY REFERENCES TipoPagamento(ID_TipoPagamento)
);

CREATE TABLE Proposta (
    ID_Proposta INT IDENTITY(1,1) PRIMARY KEY,
    ValorProposto DECIMAL(18,2) NOT NULL,
    DataProposta DATETIME NOT NULL,
    Decisao BIT, -- Aceite (1) - Recusada (0) - Pendente (NULL)
    
    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Agente INT FOREIGN KEY REFERENCES Agente(ID_Agente),
    ID_Imovel INT FOREIGN KEY REFERENCES Imovel(ID_Imovel),
    ID_Transacao INT FOREIGN KEY REFERENCES Transacao(ID_Transacao) -- Pode ser NULL se ainda não é transação
);

-- ============================================= --
--      4. TABELAS ASSOCIATIVAS E EXTRAS         --
-- ============================================= --

CREATE TABLE ClienteAgente (
    ID_ClienteAgente INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Agente INT FOREIGN KEY REFERENCES Agente(ID_Agente)
);

-- Tabela para permitir que um Cliente seja Proprietário, Comprador e Arrendatário
CREATE TABLE ClienteTipo (
    ID_ClienteTipo INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_TipoCliente INT FOREIGN KEY REFERENCES TipoCliente(ID_TipoCliente)
);

CREATE TABLE AgenteImovel (
    ID_AgenteImovel INT IDENTITY(1,1) PRIMARY KEY,
    ID_Agente INT FOREIGN KEY REFERENCES Agente(ID_Agente),
    ID_Imovel INT FOREIGN KEY REFERENCES Imovel(ID_Imovel)
);

CREATE TABLE PreferenciasCliente (
    ID_Preferencias INT IDENTITY(1,1) PRIMARY KEY,
    PrecoMin DECIMAL(18,2),
    PrecoMax DECIMAL(18,2),

    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_TipoImovel INT FOREIGN KEY REFERENCES TipoImovel(ID_TipoImovel),
    ID_Localidade INT FOREIGN KEY REFERENCES Localidade(ID_Localidade)
);

CREATE TABLE Historico_Estado_Imovel (
    ID_Historico INT IDENTITY(1,1) PRIMARY KEY,
    ID_Imovel INT NOT NULL,
    DataInicio DATETIME NOT NULL,
    DataFim DATETIME NULL,
    ID_EstadoImovel INT NOT NULL,
    CONSTRAINT FK_Historico_Imovel
    FOREIGN KEY (ID_Imovel) REFERENCES Imovel(ID_Imovel),
    CONSTRAINT FK_Historico_Estado_Imovel
    FOREIGN KEY (ID_EstadoImovel) REFERENCES EstadoImovel(ID_EstadoImovel),
);

GO