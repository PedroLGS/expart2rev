CREATE DATABASE ex6rev

USE ex6rev

CREATE TABLE motorista(
codigo				INT					NOT NULL,
nome				VARCHAR(40)			NOT NULL,
datanasc			DATE				NOT NULL,
naturalidade		VARCHAR(40)			NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE onibus(
placa			CHAR(07)		NOT NULL,
marca			VARCHAR(30)		NOT NULL,
ano				INT				NOT NULL,
descricao		VARCHAR(20)		NOT NULL
PRIMARY KEY (placa)
)

CREATE TABLE viagem(
codigo				INT				NOT NULL,
onibus				CHAR(07)		NOT NULL,
motorista			INT				NOT NULL,
horassaida			VARCHAR(05)		NOT NULL,
horachegada			VARCHAR(05)		NOT NULL,
destino				VARCHAR(30)		NOT NULL
FOREIGN KEY (onibus) REFERENCES onibus(placa),
FOREIGN KEY (motorista) REFERENCES motorista(codigo)
)

INSERT INTO motorista VALUES
(12341,'Julio Cesar','1978-04-18','São Paulo'),
(12342,'Mario Carmo','2002-07-29','Americana'),
(12343,'Lucio Castro','1969-12-01','Campinas'),
(12344,'André Figueiredo','1999-05-14','São Paulo'),
(12345,'Luiz Carlos','2001-01-09','São Paulo')

INSERT INTO onibus VALUES
('adf0965','Mercedes',1999,'Leito'),               
('bhg7654','Mercedes',2002,'Sem Banheiro'),       
('dtr2093','Mercedes',2001,'Ar Condicionado'),     
('gui7625','Volvo',2001,'Ar Condicionado')    

INSERT INTO viagem VALUES
(101,'adf0965',12343,'10h','12h','Campinas'),
(102,'gui7625',12341,'07h','12h','Araraquara'),
(103,'bhg7654',12345,'14h','22h','Rio de Janeiro'),
(104,'dtr2093',12344,'18h','21h','Sorocaba')

SELECT 
CASE 
WHEN (horassaida LIKE '%h')
THEN
LEFT (CONVERT(TIME, SUBSTRING(horassaida,1,2)+ ':00:00',108),5)
END AS chegada,
CASE 
WHEN (horachegada LIKE '%h')
THEN
LEFT (CONVERT(TIME, SUBSTRING(horachegada,1,2)+ ':00:00',108),5)
END AS saida,
destino
FROM viagem 

SELECT nome
FROM motorista
WHERE codigo IN (
SELECT motorista
FROM viagem
WHERE destino = 'Sorocaba'
)

SELECT descricao
FROM onibus
WHERE placa IN (
SELECT onibus
FROM viagem
WHERE destino = 'Rio de Janeiro'
)

SELECT descricao, marca, ano
FROM onibus
WHERE placa IN (
SELECT onibus
FROM viagem
WHERE motorista IN (
SELECT codigo
FROM motorista
WHERE nome = 'Luiz Carlos'
))

SELECT nome, DATEDIFF(YEAR, datanasc, GETDATE()) AS idade, naturalidade
FROM motorista
WHERE DATEDIFF(YEAR, datanasc, GETDATE()) > 30
