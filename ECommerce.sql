CREATE DATABASE ECommerce;

CREATE TABLE Cliente(
	CodiceCliente INT,
	Nome NVARCHAR(50) NOT NULL,
	Cognome NVARCHAR(50) NOT NULL,
	DataNascita DATE NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY (CodiceCliente),
	CONSTRAINT CHK1_Cliente CHECK (DataNascita<'2006-10-07'), --Impedisco l'iscrizione al sito ai minori di 15 anni
	CONSTRAINT CHK2_Cliente CHECK (CodiceCliente>0),
);

CREATE TABLE Carta(
	CodiceCarta NCHAR(16),
	Tipo NVARCHAR(30) NOT NULL,
	Scadenza DATE NOT NULL,
	Saldo DECIMAL NOT NULL,
	CodiceCliente INT NOT NULL,
	CONSTRAINT PK_Carta PRIMARY KEY (CodiceCarta),
    CONSTRAINT FK_Carta FOREIGN KEY (CodiceCliente) REFERENCES Cliente(CodiceCliente),
	CONSTRAINT CHK1_Carta CHECK (Scadenza>CONVERT(DATE,GETDATE())), --Impedisco l'aggiunta di una carta già scaduta
    CONSTRAINT CHK2_Carta CHECK (Tipo = 'Credito' OR Tipo = 'Debito' ),
);

CREATE TABLE Indirizzo(
	IdIndirizzo INT IDENTITY(1,1),
	Tipo NVARCHAR(30) NOT NULL,
	Città NVARCHAR(30) NOT NULL,
	Via NVARCHAR(30) NOT NULL,
	NumCivico INT NOT NULL,
	CAP INT NOT NULL,
	Provincia NCHAR(2) NOT NULL,
	Nazione NVARCHAR(10) NOT NULL,
	CodiceCliente INT NOT NULL,
	CONSTRAINT PK_Indirizzo PRIMARY KEY (IdIndirizzo),
    CONSTRAINT FK_Indirizzo FOREIGN KEY (CodiceCliente) REFERENCES Cliente(CodiceCliente),
	CONSTRAINT CHK1_Indirizzo CHECK (NumCivico > 0), 
	CONSTRAINT CHK2_Indirizzo CHECK (CAP > 0), 
	CONSTRAINT CHK3_Indirizzo CHECK (Tipo = 'Residenza' OR Tipo = 'Domicilio' ),
);


CREATE TABLE Prodotto(
	CodiceProdotto INT IDENTITY(1,1),
	Nome NVARCHAR(30) NOT NULL,
	Descrizione NVARCHAR(50) NOT NULL,
	QuantitàDisponibile INT NOT NULL,
	Prezzo DECIMAL NOT NULL,
	CONSTRAINT PK_Prodotto PRIMARY KEY (CodiceProdotto),
	CONSTRAINT CHK1_Prodotto CHECK (QuantitàDisponibile >= 0), 
	CONSTRAINT CHK2_Prodotto CHECK (Prezzo > 0), 
);

CREATE TABLE Ordine(
	CodiceOrdine INT IDENTITY(1,1),
	Stato NVARCHAR(20) NOT NULL DEFAULT 'Provvisorio',
	DataOrdine DATE,
	Totale DECIMAL,
	CodiceCliente INT NOT NULL,
	CodiceCarta NCHAR(16),
	IdIndirizzo INT,
	CONSTRAINT PK_Ordine PRIMARY KEY (CodiceOrdine),
    CONSTRAINT FK_OrdineClie FOREIGN KEY (CodiceCliente) REFERENCES Cliente(CodiceCliente),
	CONSTRAINT FK_OrdineCart FOREIGN KEY (CodiceCarta) REFERENCES Carta(CodiceCarta),
	CONSTRAINT FK_OrdineIndiriz FOREIGN KEY (IdIndirizzo) REFERENCES Indirizzo(IdIndirizzo),
	CONSTRAINT CHK1_Ordine CHECK (Totale >0), 
	CONSTRAINT CHK2_Ordine CHECK (DataOrdine <= CONVERT(DATE,GETDATE())), --la data dell'ordine non può essere successiva a quella di oggi
    CONSTRAINT CHK3_Ordine CHECK (Stato = 'Provvisorio' OR Stato = 'Confermato' ),
);
 
CREATE TABLE OrdineProdotto(
	CodiceOrdine INT NOT NULL,
	CodiceProdotto INT NOT NULL,
	Quantità INT NOT NULL,
	SubTotale DECIMAL NOT NULL,
	CONSTRAINT PK_OrdineProdotto PRIMARY KEY (CodiceOrdine, CodiceProdotto),
    CONSTRAINT FK_OrdineProdotto1 FOREIGN KEY (CodiceOrdine) REFERENCES Ordine(CodiceOrdine),
	CONSTRAINT FK_OrdineProdotto2 FOREIGN KEY (CodiceProdotto) REFERENCES Prodotto(CodiceProdotto),
	CONSTRAINT CHK1_OrdineProdotto CHECK (Quantità > 0), 
	CONSTRAINT CHK2_OrdineProdotto CHECK (Subtotale > 0), 
);

INSERT INTO Cliente VALUES(1, 'Mario', 'Rossi', '1969-01-10');
INSERT INTO Cliente VALUES(2, 'Franca', 'Bianchi', '1972-04-06');
INSERT INTO Cliente VALUES(3, 'Gino', 'Verdi', '1980-09-03');
INSERT INTO Cliente VALUES(4, 'Laura', 'Neri', '1996-07-15');
INSERT INTO Cliente VALUES(5, 'Marco', 'Esposito', '2000-09-11');


INSERT INTO Carta VALUES('1568934019673509', 'Credito', '2025-01-01', 350, 1);
INSERT INTO Carta VALUES('0987654321123456', 'Debito', '2022-11-09', 580, 2);
INSERT INTO Carta VALUES('1256890462940184', 'Debito', '2024-02-11', 120, 1);
INSERT INTO Carta VALUES('9087654016582950', 'Credito', '2023-01-01', 150, 3);
INSERT INTO Carta VALUES('0562840392183759', 'Credito', '2022-10-12', 400, 4);
INSERT INTO Carta VALUES('1278940247591001', 'Credito', '2022-01-01', 850, 5);
INSERT INTO Carta VALUES('9028416153221112', 'Debito', '2022-11-09', 450, 5);
INSERT INTO Carta VALUES('1294500012001102', 'Credito', '2024-01-01', 1000, 2);


INSERT INTO Indirizzo VALUES('Domicilio', 'Roma', 'Vigne Nuove', 12, 00139, 'RM', 'Italia', 1);
INSERT INTO Indirizzo VALUES('Domicilio', 'Bologna', 'Giosuè Carducci', 1, 00891, 'BO', 'Italia', 2);
INSERT INTO Indirizzo VALUES('Residenza', 'Caserta', 'Gaicomo Leopardi', 24, 81090, 'CE', 'Italia', 1);
INSERT INTO Indirizzo VALUES('Residenza', 'Roma', 'San Giovanni', 50, 01938, 'RM', 'Italia', 3);
INSERT INTO Indirizzo VALUES('Domicilio', 'Napoli', 'San Michele', 22, 80900, 'NA', 'Italia', 3);
INSERT INTO Indirizzo VALUES('Residenza', 'Roma', 'Giuseppe Verdi', 25, 00133, 'RM', 'Italia', 4);
INSERT INTO Indirizzo VALUES('Residenza', 'Milano', 'Nuova Strada', 12, 12345, 'MI', 'Italia', 5);
INSERT INTO Indirizzo VALUES('Residenza', 'Firenze', 'Dante Alighieri', 31, 12400, 'FI', 'Italia', 2);
INSERT INTO Indirizzo VALUES('Domicilio', 'Palermo', 'Luigi Pirandello', 20, 11139, 'PA', 'Italia', 5);


INSERT INTO Prodotto VALUES('Tavolino', 'Da esterno, per 4 persone', 50, 120);
INSERT INTO Prodotto VALUES('Lampada', 'Bianca, da comodino', 28, 45);
INSERT INTO Prodotto VALUES('Tappeto', 'Multicolore, 2m*2m', 49, 90);
INSERT INTO Prodotto VALUES('Borraccia', 'Termica, 1 Litro', 100, 15);
INSERT INTO Prodotto VALUES('Padella', 'Antiaderente, 20cm raggio', 75, 25);
INSERT INTO Prodotto VALUES('Set Bicchieri', 'Da vino, set da 6', 60, 80);
INSERT INTO Prodotto VALUES('Biscottiera', 'Ceramica', 26, 15);
INSERT INTO Prodotto VALUES('Comodino', 'Bianco', 87, 70);
INSERT INTO Prodotto VALUES('Tostapane', 'Per 6 fette', 43, 140);
INSERT INTO Prodotto VALUES('Frullatore', 'Capacità 4 Litri', 62, 120);


INSERT INTO Ordine VALUES('Provvisorio', '2021-10-07', 120, 4, '0562840392183759', 5);


SELECT * FROM Cliente;
SELECT * FROM Carta;
SELECT * FROM Indirizzo;
SELECT * FROM Prodotto;
SELECT * FROM Ordine;


--Con questa procedura popolo 3 tabelle contemporanemente (Cliente, Carta, Indirizzo)
CREATE PROCEDURE IscrizioneCliente 
@CodiceCliente INT,
@Nome NVARCHAR(50),
@Cognome NVARCHAR(50),
@DataNascita DATE, 
@CodiceCarta NCHAR(16),
@TipoCarta NVARCHAR(30),
@ScadenzaCarta DATE,
@SaldoCarta DECIMAL,
@TipoIndirizzo NVARCHAR(30),
@Città NVARCHAR(30),
@Via NVARCHAR(30),
@NumCivico INT,
@CAP INT,
@Provincia NCHAR(2),
@Nazione NVARCHAR(10)

AS
INSERT INTO Cliente VALUES (@CodiceCliente, @Nome, @Cognome, @DataNascita)
INSERT INTO Carta VALUES (@CodiceCarta, @TipoCarta, @ScadenzaCarta, @SaldoCarta, @CodiceCliente)
INSERT INTO Indirizzo VALUES (@TipoIndirizzo, @Città, @Via, @NumCivico, @CAP, @Provincia, @Nazione, @CodiceCliente)

EXECUTE IscrizioneCliente  10, 'Michela', 'De Angelis', '1980-10-10', '0912567389120950', 'Debito', '2025-12-10', 950, 'Residenza', 'Roma', 'Trilussa', 15, 00138, 'RM', 'Italia'; ;


----PROCEDURA PER ASSOCIARE CARTA A CLIENTE GIA' ESISTENTE
CREATE PROCEDURE AggiungiCarta
@CodiceCliente INT,
@CodiceCarta NCHAR(16),
@TipoCarta NVARCHAR(30),
@ScadenzaCarta DATE,
@SaldoCarta DECIMAL

AS
INSERT INTO Carta VALUES (@CodiceCarta, @TipoCarta, @ScadenzaCarta, @SaldoCarta, @CodiceCliente)

EXECUTE AggiungiCarta 10, '1904519502385012', 'Credito', '2023-08-09', 600


----PROCEDURA PER ASSOCIARE INDIRIZZO A CLIENTE GIA' ESISTENTE
CREATE PROCEDURE AggiungiIndirizzo
@CodiceCliente INT,
@TipoIndirizzo NVARCHAR(30),
@Città NVARCHAR(30),
@Via NVARCHAR(30),
@NumCivico INT,
@CAP INT,
@Provincia NCHAR(2),
@Nazione NVARCHAR(10)

AS
INSERT INTO Indirizzo VALUES (@TipoIndirizzo, @Città, @Via, @NumCivico, @CAP, @Provincia, @Nazione, @CodiceCliente)

EXECUTE AggiungiIndirizzo 10, 'Domicilio', 'Caserta', 'San Giuseppe', 7, 88090, 'CE', 'Italia'




CREATE PROCEDURE CreazioneOrdineProvvisorio
@CodiceCliente INT
AS
INSERT INTO Ordine(CodiceCliente) VALUES (@CodiceCliente);

EXECUTE CreazioneOrdineProvvisorio 10



CREATE PROCEDURE AggiungiProdottoOrdine
@CodiceOrdine INT,
@NomeProdotto NVARCHAR(30),
@Quantità INT
AS

 DECLARE @IdProdottoScelto INT

 SELECT @IdProdottoScelto = p.CodiceProdotto
 FROM Prodotto AS p
 WHERE p.Nome = @NomeProdotto

 DECLARE @SubtotaleCalcolato DECIMAL

 SELECT @SubtotaleCalcolato = p.Prezzo*@Quantità
 FROM Prodotto as p
 WHERE p.CodiceProdotto = @IdProdottoScelto

BEGIN
   IF(@Quantità>=3)
   SET @SubtotaleCalcolato = @SubtotaleCalcolato - (@SubtotaleCalcolato*0.1)
END
 
 INSERT INTO OrdineProdotto VALUES (@CodiceOrdine, @IdProdottoScelto, @Quantità, @SubtotaleCalcolato)



 
 EXECUTE AggiungiProdottoOrdine 2, 'Tavolino', 4
 EXECUTE AggiungiProdottoOrdine 2, 'Lampada', 1

 SELECT *
 FROM OrdineProdotto