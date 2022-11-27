CREATE DATABASE ex7rev

USE ex7rev

CREATE TABLE clientes(
rg					VARCHAR(11)			NOT NULL,
cpf 				CHAR(11)			NOT NULL,
nome				VARCHAR(25)			NOT NULL,
logradouro			VARCHAR(30)			NOT NULL,
numero				INT					NOT NULL
PRIMARY KEY (rg)
)

CREATE TABLE pedido(
nota_fiscal			INT					NOT NULL,
valor				INT					NOT NULL,
data				DATE				NOT NULL,
rg_cliente			VARCHAR(11)			NOT NULL
PRIMARY KEY (nota_fiscal)
FOREIGN KEY (rg_cliente) REFERENCES clientes(rg)
)

CREATE TABLE mercadoria(
codigo				INT					NOT NULL,
descricao			VARCHAR(40)			NOT NULL,
preco				INT					NOT NULL,
qtd					INT					NOT NULL,
cod_fornecedor		INT					NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (cod_fornecedor) REFERENCES fornecedores (codigo)
)

CREATE TABLE fornecedores(
codigo				INT					NOT NULL,
nome				VARCHAR(20)			NOT NULL,
logradouro			VARCHAR(45)			NOT NULL,
numero				INT					NULL,
pais				VARCHAR(05)			NOT NULL,
area				INT					NOT NULL,
telefone			VARCHAR(10)			NULL,
cnpj				CHAR(13)			NULL,
cidade				VARCHAR(25)			NULL,
transporte			VARCHAR(15)			NULL,
moeda				VARCHAR(04)			NOT NULL
PRIMARY KEY (codigo)
)

INSERT INTO clientes VALUES
('29531844','34519878040','Luiz André','R. Astorga',500),
('13514996x','84984285630','Maria Luiza','R. Piauí',174),
('121985541','23354997310','Ana Barbara','Av. Jaceguai',1141),
('23987746x','43587669920','Marcos Alberto','R. Quinze',22)

INSERT INTO pedido VALUES
(1001,754,'2018-04-01','121985541'),
(1002,350,'2018-04-02','121985541'),
(1003,30,'2018-04-02','29531844'),
(1004,1500,'2018-04-03','13514996x')

INSERT INTO mercadoria VALUES
(10,'Mouse,',24,30,1),
(11,'Teclado',50,20,1),
(12,'Cx. De Som',30,8,2),
(13,'Monitor 17',350,4,3),
(14,'Notebook',1500,7,4)

INSERT INTO fornecedores VALUES
(1,'Clone','Av. Nações Unidas, 12000',12000,'BR',55,'1141487000',NULL,'São Paulo',NULL,'R$'),
(2,'Logitech','28th Street, 100',100,'USA',1,'2127695100',NULL,NULL,'Avião','US$'),
(3,'LG','Rod. Castello Branco',NULL,'BR',55,'800664400','4159978100001','Sorocaba',NULL,'R$'),
(4,'PcChips','Ponte da Amizade',NULL,'PY',595,NULL,NULL,NULL,'Navio','US$')

SELECT valor, valor - (valor * 0.10) AS valor_desconto
FROM pedido
WHERE nota_fiscal = '1003'

SELECT valor, valor - (valor * 0.05) AS valor_desconto
FROM pedido
WHERE valor > 700.00

SELECT preco, preco + (preco * 0.20) AS preco_aumento
FROM mercadoria
WHERE qtd < 10

SELECT pe.data, pe.valor
FROM pedido pe
INNER JOIN clientes cl
ON pe.rg_cliente = cl.rg
WHERE nome LIKE 'Luiz%'

SELECT SUBSTRING(cl.cpf,1,3)+'.'+SUBSTRING(cl.cpf,4,3)+'.'+SUBSTRING(cl.cpf,7,3)+'-'+SUBSTRING(cl.cpf,10,2) AS cpf,
cl.logradouro + ', ' + CONVERT(VARCHAR(05), cl.numero) AS endereco
FROM clientes cl
INNER JOIN pedido pe
ON pe.rg_cliente = cl.rg
WHERE pe.nota_fiscal = 1004

SELECT f.pais, f.transporte
FROM fornecedores f
INNER JOIN mercadoria m
ON f.codigo = m.cod_fornecedor
WHERE m.descricao = 'Cx. De som'

SELECT m.descricao, m.qtd
FROM mercadoria m
INNER JOIN fornecedores f
ON m.cod_fornecedor = f.codigo
WHERE f.nome = 'Clone'

SELECT
CASE
WHEN (f.numero IS NULL)
THEN f.logradouro
ELSE
f.logradouro
END AS endereco,
CASE 
WHEN (F.TELEFONE LIKE '0800%')
THEN
	'('+SUBSTRING(f.telefone,1,3)+')'+SUBSTRING(f.telefone,4,4)+'-'+SUBSTRING(f.telefone,7,4)
ELSE
	'('+SUBSTRING(f.telefone,1,3)+')'+SUBSTRING(f.telefone,4,3)+'-'+SUBSTRING(f.telefone,7,4)
END AS telefone
FROM fornecedores f
INNER JOIN mercadoria m
ON m.cod_fornecedor = f.codigo
WHERE m.descricao LIKE 'Monitor%'

SELECT f.moeda
FROM fornecedores f
INNER JOIN mercadoria m
ON f.codigo = m.cod_fornecedor
WHERE m.descricao = 'Notebook'

SELECT p.nota_fiscal, DATEDIFF(DAY, p.data, '2019-02-03') AS dias_pedido,
CASE 
	WHEN DATEDIFF(MONTH, p.data, '2019-02-03') > 6
	THEN 
	'Pedido Antigo'
	ELSE
	'Pedido Recente'
	END AS status
FROM pedido p

SELECT cl.nome, COUNT(p.rg_cliente) AS qtd_pedidos
FROM clientes cl
INNER JOIN pedido p
ON cl.rg = p.rg_cliente
GROUP BY cl.nome, p.rg_cliente

SELECT cl.nome, COUNT(p.rg_cliente) as qtd_pedidos
FROM clientes cl
INNER JOIN pedido p
ON cl.rg = p.rg_cliente
GROUP BY cl.nome, p.rg_cliente

SELECT cl.rg, SUBSTRING(cl.cpf,1,3)+'.'+SUBSTRING(cl.cpf,4,3)+'.'+SUBSTRING(cl.cpf,7,3)+'-'+SUBSTRING(cl.cpf,10,2) AS cpf, 
cl.nome, cl.logradouro + ', ' + CONVERT(VARCHAR(08), numero) AS endereco
FROM clientes cl
LEFT OUTER JOIN pedido p
ON cl.rg = p.rg_cliente
WHERE p.rg_cliente IS NULL
