DROP SCHEMA IF EXISTS orologidautore;
CREATE SCHEMA orologidautore;
USE orologidautore;

-- Creazione della tabella Utente
CREATE TABLE Utente
(
    id_utente    INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(50)              NOT NULL,
    cognome      VARCHAR(50)              NOT NULL,
    email        VARCHAR(100)             NOT NULL,
    password     VARCHAR(255)             NOT NULL,
    tipologia    ENUM ('UTENTE', 'ADMIN') NOT NULL,
    data_nascita DATE                     NOT NULL
);

-- Creazione della tabella Indirizzo
CREATE TABLE Indirizzo
(
    id_indirizzo INT AUTO_INCREMENT PRIMARY KEY,
    via          VARCHAR(100)                                    NOT NULL,
    citta        VARCHAR(50)                                     NOT NULL,
    CAP          VARCHAR(5)                                      NOT NULL,
    tipologia    ENUM ('FATTURAZIONE', 'SPEDIZIONE', 'ENTRAMBI') NOT NULL
);

-- Creazione della tabella NumeroTelefono
CREATE TABLE NumeroTelefono
(
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    prefisso    VARCHAR(10) NOT NULL,
    numero      VARCHAR(20) NOT NULL,
    id_utente   INT         NOT NULL,
    CONSTRAINT fk_utente_telefono FOREIGN KEY (id_utente) REFERENCES Utente (id_utente)
);

-- Creazione della tabella MetodoPagamento
CREATE TABLE PagamentoOrdine
(
    id_metodo    INT AUTO_INCREMENT PRIMARY KEY,
    id_ordine    BIGINT         NOT NULL REFERENCES Ordine (id) ON DELETE CASCADE,
    token        VARCHAR(64)    NOT NULL UNIQUE,
    paypal_email VARCHAR(255)   NOT NULL,
    amount       DECIMAL(10, 2) NOT NULL,
    currency     CHAR(3)        NOT NULL,
    created_at   DATETIME       NOT NULL DEFAULT NOW()
);

-- Creazione della tabella Prodotto
CREATE TABLE Prodotto
(
    codice_prodotto INT AUTO_INCREMENT PRIMARY KEY,
    materiale       VARCHAR(50)    NOT NULL,
    categoria       VARCHAR(50)    NOT NULL,
    taglia          VARCHAR(10)    NOT NULL,
    marca           VARCHAR(50)    NOT NULL,
    prezzo          DECIMAL(10, 2) NOT NULL,
    stato           ENUM ('ATTIVATO', 'DISATTIVATO') DEFAULT 'ATTIVATO' NOT NULL,
    modello         VARCHAR(50)    NOT NULL,
    descrizione     TEXT           NOT NULL,
    nome            VARCHAR(100)   NOT NULL,
    image_url       VARCHAR(255),
    created_at      TIMESTAMP      NOT NULL          DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP      NOT NULL          DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Creazione della tabella Immagine
CREATE TABLE Immagine
(
    id_immagine     INT AUTO_INCREMENT PRIMARY KEY,
    immagine_url    VARCHAR(255) NOT NULL,
    codice_prodotto INT          NOT NULL,
    CONSTRAINT fk_immagine_prodotto FOREIGN KEY (codice_prodotto) REFERENCES Prodotto (codice_prodotto)
);

-- Creazione della tabella Fattura
CREATE TABLE Fattura
(
    numero_fattura INT AUTO_INCREMENT PRIMARY KEY,
    data_fattura   DATE           NOT NULL,
    data_scadenza  DATE           NOT NULL,
    importo_totale DECIMAL(10, 2) NOT NULL,
    importo_IVA    DECIMAL(10, 2) NOT NULL,
    aliquota_IVA   DECIMAL(5, 2)  NOT NULL,
    stato_fattura  VARCHAR(20)    NOT NULL
);

-- Creazione della tabella Ordine
CREATE TABLE Ordine
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_ordine VARCHAR(17)    NOT NULL,
    data_ordine   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_arrivo   TIMESTAMP,
    note          TEXT,
    totale_ordine DECIMAL(10, 2) NOT NULL,
    id_utente     INT            NOT NULL,
    id_indirizzo  INT            NOT NULL,
    CONSTRAINT fk_ordine_utente FOREIGN KEY (id_utente) REFERENCES Utente (id_utente),
    CONSTRAINT fk_ordine_indirizzo FOREIGN KEY (id_indirizzo) REFERENCES Indirizzo (id_indirizzo)
);

-- Creazione della tabella Recensione
CREATE TABLE Recensione
(
    id_recensione   INT AUTO_INCREMENT PRIMARY KEY,
    commento        TEXT         NOT NULL,
    autore          VARCHAR(100) NOT NULL,
    valutazione     INT          NOT NULL,
    interazioni     INT          NOT NULL,
    id_utente       INT          NOT NULL,
    codice_prodotto INT          NOT NULL,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recensione_utente FOREIGN KEY (id_utente) REFERENCES Utente (id_utente),
    CONSTRAINT fk_recensione_prodotto FOREIGN KEY (codice_prodotto) REFERENCES Prodotto (codice_prodotto)
);

-- Tabella di associazione Salva
CREATE TABLE Preferiti
(
    id_utente       INT NOT NULL,
    codice_prodotto INT NOT NULL,
    PRIMARY KEY (id_utente, codice_prodotto),
    CONSTRAINT fk_utente FOREIGN KEY (id_utente) REFERENCES Utente (id_utente),
    CONSTRAINT fk_id_prodotto FOREIGN KEY (codice_prodotto) REFERENCES Prodotto (codice_prodotto)
);

-- Tabella di associazione Contiene
CREATE TABLE Prodotti_Ordine
(
    id_ordine       BIGINT         NOT NULL,
    codice_prodotto INT            NOT NULL,
    prezzo_unitario DECIMAL(10, 2) NOT NULL, -- prezzo unitario al momento dell'ordine
    iva_percentuale DECIMAL(4, 2)  NOT NULL DEFAULT 22.00,
    quantita        INT            NOT NULL,
    subtotal        DECIMAL(12, 2) AS (prezzo_unitario * quantita) STORED,
    created_at      DATETIME       NOT NULL DEFAULT NOW(),
    updated_at      DATETIME       NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    PRIMARY KEY (id_ordine, codice_prodotto),
    CONSTRAINT fk_po_ordine FOREIGN KEY (id_ordine)
        REFERENCES Ordine (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_po_prodotto FOREIGN KEY (codice_prodotto)
        REFERENCES Prodotto (codice_prodotto)
);

-- Tabella di associazione Genera
CREATE TABLE Fatture_Generate
(
    id             BIGINT NOT NULL,
    numero_fattura INT    NOT NULL,
    PRIMARY KEY (id, numero_fattura),
    CONSTRAINT fk_genera_ordine FOREIGN KEY (id) REFERENCES Ordine (id),
    CONSTRAINT fk_genera_fattura FOREIGN KEY (numero_fattura) REFERENCES Fattura (numero_fattura)
);

-- Tabella di associazione Locato
CREATE TABLE Indirizzo_Utente
(
    id_indirizzo INT     NOT NULL,
    id_utente    INT     NOT NULL,
    is_default   BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id_indirizzo, id_utente),
    CONSTRAINT fk_locato_indirizzo FOREIGN KEY (id_indirizzo)
        REFERENCES Indirizzo (id_indirizzo),
    CONSTRAINT fk_locato_utente FOREIGN KEY (id_utente)
        REFERENCES Utente (id_utente)
);
