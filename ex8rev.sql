CREATE DATABASE ex8rev

USE ex8rev

CREATE TABLE cliente(
codigo				INT				NOT NULL,
nome				VARCHAR(40)		NOT NULL,
endereco			VARCHAR(50)		NOT NULL,
telefone			CHAR(08)		NOT NULL,
telefone_comercial	CHAR(08)		NULL
PRIMARY KEY (codigo)
)

CREATE TABLE mercadoria(
codigo			INT				NOT NULL,
nome       		VARCHAR(25)		NOT NULL,
corredor    	INT				NOT NULL,
tipo			INT				NOT NULL,
valor			NUMERIC(4,2)	NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (corredor) REFERENCES corredores (codigo),
FOREIGN KEY (tipo) REFERENCES tipo_mercadoria (codigo)
)

CREATE TABLE corredores(
codigo			INT				NOT NULL,
tipo			INT				NULL,
nome			VARCHAR(25)		NULL
PRIMARY KEY (codigo)
FOREIGN KEY (tipo)	REFERENCES tipo_mercadoria (codigo)
)	

CREATE TABLE tipo_mercadoria(
codigo			INT					NOT NULL,
nome			VARCHAR(12)			NOT NULL
PRIMARY KEY (codigo) 
)

CREATE TABLE compra(
nota_fiscal	    INT			NOT NULL,
codigo_cliente	INT			NOT NULL,
valor			INT			NOT NULL
PRIMARY KEY (nota_fiscal)
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo)
)

INSERT INTO cliente VALUES
(1,'Luis Paulo','R. Xv de Novembro, 100','45657878',NULL),	
(2,'Maria Fernanda','R. Anhaia, 1098','27289098','40040090'),
(3,'Ana Claudia','Av. Voluntários da Pátria, 876','21346548',NULL),	
(4,'Marcos Henrique','R. Pantojo, 76','51425890','30394540'),
(5,'Emerson Souza','R. Pedro Álvares Cabral, 97','44236545','39389900'),
(6,'Ricardo Santos','Trav. Hum, 10','98789878',NULL)

INSERT INTO mercadoria VALUES
(1001,'Pão de Forma',101,10001,3.5),
(1002,'Presunto',101,10002,2.0),
(1003,'Cream Cracker',103,10003,4.5),
(1004,'Água Sanitária',104,10004,6.5),
(1005,'Maçã',105,10005,0.9),
(1006,'Palha de Aço',106,10006,1.3),
(1007,'Lasanha',107,10007,9.7)

INSERT INTO corredores VALUES
(101,10001,'Padaria'),
(102,10002,'Calçados'),
(103,10003,'Biscoitos'),
(104,10004,'Limpeza'),
(105,NULL,NULL),		
(106,NULL,NULL),	
(107,10007,'Congelados')

INSERT INTO tipo_mercadoria VALUES
(10001,'Pães'),
(10002,'Frios'),
(10003,'Bolacha'),
(10004,'Clorados'),
(10005,'Frutas'),
(10006,'Esponjas'),
(10007,'Massas'),
(10008,'Molhos')

INSERT INTO compra VALUES
(1234,2,200),
(2345,4,156),
(3456,6,354),
(4567,3,19)

SELECT c.valor
FROM compra c 
INNER JOIN cliente cl
ON c.codigo_cliente = cl.codigo
WHERE cl.nome = 'Luis Paulo'

SELECT c.valor
FROM compra c 
INNER JOIN cliente cl
ON c.codigo_cliente = cl.codigo
WHERE cl.nome = 'Marcos Henrique'

SELECT cl.endereco, cl.telefone
FROM cliente cl
INNER JOIN compra c
ON cl.codigo = c.codigo_cliente
WHERE c.nota_fiscal = '4567'

SELECT m.valor
FROM mercadoria m
INNER JOIN tipo_mercadoria tp
ON tp.codigo = m.tipo
WHERE tp.nome = 'Pães'

SELECT co.nome
FROM corredores co
INNER JOIN mercadoria m
ON co.codigo = m.corredor
WHERE m.nome = 'Lasanha'

SELECT co.nome
FROM corredores co
INNER JOIN mercadoria m
ON co.codigo = m.corredor
INNER JOIN tipo_mercadoria tp
ON tp.codigo = m.tipo
WHERE tp.nome = 'Clorados'