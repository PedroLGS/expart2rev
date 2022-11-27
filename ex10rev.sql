CREATE DATABASE ex10rev

USE ex10rev

CREATE TABLE medicamentos(
codigo					INT					NOT NULL,
nome					VARCHAR(100)		NOT NULL,
apresentacao  			VARCHAR(35)			NOT NULL,
uni_cad  				VARCHAR(12)			NOT NULL,
preco_propo				NUMERIC(5,3)		NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE cliente(
cpf				CHAR(11)		NOT NULL,
nome			VARCHAR(40)		NOT NULL,
rua				VARCHAR(25)		NOT NULL,
num				INT				NOT NULL,
bairro			VARCHAR(15)		NOT NULL,
telefone		CHAR(08)		NOT NULL
PRIMARY KEY (cpf)
)

CREATE TABLE venda(
nota_fiscal			INT					NOT NULL,
cpf_cliente			CHAR(11)			NOT NULL,
cod_med				INT					NOT NULL,
quantidade			INT					NOT NULL,
valor_total			NUMERIC(6,2)		NOT NULL,
data				DATE				NOT NULL
PRIMARY KEY (nota_fiscal, cpf_cliente, cod_med)
FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
FOREIGN KEY (cod_med) REFERENCES medicamentos (codigo)
)

INSERT INTO medicamentos VALUES
(1,'Acetato de medroxiprogesterona','150 mg/ml','Ampola',6.700),
(2,'Aciclovir','200mg/comp.','Comprimido',0.280),
(3,'Ácido Acetilsalicílico','500mg/comp.','Comprimido',0.035),
(4,'Ácido Acetilsalicílico','100mg/comp.','Comprimido',0.030),
(5,'Ácido Fólico','5mg/comp.','Comprimido',0.054),
(6,'Albendazol','400mg/comp. mastigável','Comprimido',0.560),
(7,'Alopurinol','100mg/comp.','Comprimido',0.080),
(8,'Amiodarona','200mg/comp.','Comprimido',0.200),
(9,'Amitriptilina(Cloridrato)','25mg/comp.','Comprimido',0.220),
(10,'Amoxicilina','500mg/cáps.','Cápsula',0.190)

INSERT INTO cliente VALUES
('34390898700','Maria Zélia','Anhaia',65,'Barra Funda','92103762'),
('21345986290','Roseli Silva','Xv. De Novembro',987,'Centro','82198763'),
('86927981825','Carlos Campos','Voluntários da Pátria',1276,'Santana','98172361'),
('31098120900','João Perdizes','Carlos de Campos',90,'Pari','61982371')

INSERT INTO venda VALUES
(31501,'86927981825',10,3,0.57,'2020-11-01'),
(31501,'86927981825',2,10,2.8,'2020-11-01'),
(31501,'86927981825',5,30,1.05,'2020-11-01'),
(31501,'86927981825',8,30,6.6,'2020-11-01'),
(31502,'34390898700',8,15,3,'2020-11-01'),
(31502,'34390898700',2,10,2.8,'2020-11-01'),
(31502,'34390898700',9,10,2.2,'2020-11-01'),
(31503,'31098120900',1,20,134,'2020-11-02')

SELECT m.nome, m.apresentacao, m.preco_propo,
CASE 
	WHEN uni_cad = 'Comprimido'
	THEN SUBSTRING(uni_cad,1,4) + '.' 
	ELSE
	uni_cad
	END AS unidade_cadastro
FROM medicamentos m
LEFT OUTER JOIN venda v
ON m.codigo = v.cod_med
WHERE v.cod_med IS NULL

SELECT c.nome
FROM cliente c
INNER JOIN venda v
ON c.cpf = v.cpf_cliente
INNER JOIN medicamentos m
ON v.cod_med = m.codigo
WHERE m.nome = 'Amiodarona'

SELECT c.cpf, c.rua + ', ' + CONVERT(VARCHAR(05), c.num) + ', ' + c.bairro AS endereco,
m.nome, m.apresentacao, m.uni_cad, m.preco_propo, v.quantidade, v.valor_total
FROM cliente c
INNER JOIN venda v
ON c.cpf = v.cpf_cliente
INNER JOIN medicamentos m
ON v.cod_med = m.codigo
WHERE c.nome = 'Maria Zélia'

SELECT CONVERT(CHAR(10), v.data, 103) AS data_compra
FROM venda v
INNER JOIN cliente c
ON v.cpf_cliente = c.cpf
WHERE c.nome = 'Carlos Campos'

UPDATE medicamentos
SET nome = 'Cloridrato de Amitriptilina'
WHERE nome = 'Amitriptilina(Cloridrato)'