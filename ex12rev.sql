CREATE DATABASE ex12rev

USE ex12rev

CREATE TABLE planos(
cod_plano		INT				NOT NULL,
nome_plano		VARCHAR(45)		NOT NULL,
valor_plano		INT				NOT NULL
PRIMARY KEY (cod_plano)
)

CREATE TABLE servicos(
cod_servico		INT				NOT NULL,		
nome_servico	VARCHAR(20)		NOT NULL,
valor_servico	INT				NOT NULL
PRIMARY KEY (cod_servico)
)

CREATE TABLE cliente(
cod_cliente		INT				NOT NULL,
nome_cliente	VARCHAR(20)		NOT NULL,
data_inicio		DATE			NOT NULL
PRIMARY KEY (cod_cliente)
)

CREATE TABLE contrato(
cod_cliente		INT				NOT NULL,
cod_plano		INT				NOT NULL,
cod_servico		INT				NOT NULL,
status			CHAR(01)		NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (cod_cliente, cod_plano, cod_servico, data)
FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente),
FOREIGN KEY (cod_plano) REFERENCES planos (cod_plano),
FOREIGN KEY (cod_servico) REFERENCES servicos (cod_servico)
)

INSERT INTO planos VALUES
(1,'100 Minutos',80),
(2,'150 Minutos',130),
(3,'200 Minutos',160),
(4,'250 Minutos',220),
(5,'300 Minutos',260),
(6,'600 Minutos',350)

INSERT INTO servicos VALUES
(1,'100 SMS',10),
(2,'SMS Ilimitado',30),
(3,'Internet 500 MB',40),
(4,'Internet 1 GB',60),
(5,'Internet 2 GB',70)

INSERT INTO cliente VALUES
(1234,'Cliente A','2012-10-15'),
(2468,'Cliente B','2012-11-20'),
(3702,'Cliente C','2012-11-25'),
(4936,'Cliente D','2012-12-01'),
(6170,'Cliente E','2012-12-18'),
(7404,'Cliente F','2013-01-20'),
(8638,'Cliente G','2013-01-25')

INSERT INTO contrato VALUES
(1234,	3,	1,	'E',	'2012-10-15'),
(1234,	3,	3,	'E',	'2012-10-15'),
(1234,	3,	3,	'A',	'2012-10-16'),
(1234,	3,	1,	'A',	'2012-10-16'),
(2468,	4,	4,	'E',	'2012-11-20'),
(2468,	4,	4,	'A',	'2012-11-21'),
(6170,	6,	2,	'E',	'2012-12-18'),
(6170,	6,	5,	'E',	'2012-12-19'),
(6170,	6,	2,	'A',	'2012-12-20'),
(6170,	6,	5,	'A',	'2012-12-21'),
(1234,	3,	1,	'D',	'2013-01-10'),
(1234,	3,	3,	'D',	'2013-01-10'),
(1234,	2,	1,	'E',	'2013-01-10'),
(1234,	2,	1,	'A',	'2013-01-11'),
(2468,	4,	4,	'D',	'2013-01-25'),
(7404,	2,	1,	'E',	'2013-01-20'),
(7404,	2,	5,	'E',	'2013-01-20'),
(7404,	2,	5,	'A',	'2013-01-21'),
(7404,	2,	1,	'A',	'2013-01-22'),
(8638,	6,	5,	'E',	'2013-01-25'),
(8638,	6,	5,	'A',	'2013-01-26'),
(7404,	2,	5,	'D',	'2013-02-03')

SELECT cl.nome_cliente, p.nome_plano, co.status, COUNT(co.status) AS qtd_contratos
FROM contrato co
INNER JOIN cliente cl
ON co.cod_cliente = cl.cod_cliente
INNER JOIN planos p
ON p.cod_plano = co.cod_plano
WHERE co.status = 'D'
GROUP BY cl.nome_cliente, p.nome_plano, co.status
ORDER BY cl.nome_cliente ASC

SELECT cl.nome_cliente, p.nome_plano, co.status, COUNT(co.status) AS qtd_contratos
FROM contrato co
INNER JOIN cliente cl
ON co.cod_cliente = cl.cod_cliente
INNER JOIN planos p
ON p.cod_plano = co.cod_plano
WHERE co.status = 'A'
GROUP BY cl.nome_cliente, p.nome_plano, co.status
ORDER BY cl.nome_cliente ASC

SELECT cl.nome_cliente, p.nome_plano,
CASE 
	WHEN ((p.valor_plano+SUM(s.valor_servico)) > 400)
	THEN (p.valor_plano+SUM(s.valor_servico)) - ((p.valor_plano+SUM(s.valor_servico)) * 0.08)
	WHEN ((p.valor_plano+SUM(s.valor_servico)) > 300 AND (p.valor_plano+SUM(s.valor_servico)) < 400)
	THEN (p.valor_plano+SUM(s.valor_servico)) - ((p.valor_plano+SUM(s.valor_servico)) * 0.05)
	WHEN ((p.valor_plano+SUM(s.valor_servico)) > 200 AND (p.valor_plano+SUM(s.valor_servico)) < 300)
	THEN (p.valor_plano+SUM(s.valor_servico)) - ((p.valor_plano+SUM(s.valor_servico)) * 0.03)
	ELSE
	(p.valor_plano+SUM(s.valor_servico))
	END AS valor_total_com_desconto
FROM planos p
INNER JOIN contrato c
ON p.cod_plano = c.cod_plano
INNER JOIN cliente cl
ON cl.cod_cliente = c.cod_cliente
INNER JOIN servicos s
ON s.cod_servico = c.cod_servico
WHERE c.status = 'A'
GROUP BY cl.nome_cliente, p.nome_plano, p.valor_plano, s.valor_servico

SELECT cl.nome_cliente, s.nome_servico, DATEDIFF(MONTH, cl.data_inicio, GETDATE()) AS duracao_meses
FROM cliente cl
INNER JOIN contrato c
ON cl.cod_cliente = c.cod_cliente
INNER JOIN servicos s
ON s.cod_servico = c.cod_servico
WHERE c.status = 'A' OR c.status = 'E'
GROUP BY c.cod_cliente, c.cod_plano, cl.nome_cliente, s.nome_servico, cl.data_inicio