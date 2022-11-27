CREATE DATABASE ex11rev

USE ex11rev

CREATE TABLE planos_de_saude(
codigo			INT					NOT NULL,
nome			VARCHAR(20)			NOT NULL,
telefone		CHAR(08)			NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE paciente(
cpf				VARCHAR(11)			NOT NULL,
nome			VARCHAR(15)			NOT NULL,
rua				VARCHAR(50)			NOT NULL,
numero			INT					NOT NULL,
bairro			VARCHAR(15)			NOT NULL,
telefone		CHAR(08)			NOT NULL,
plano_saude			INT					NOT NULL
PRIMARY KEY (cpf)
FOREIGN KEY (plano_saude) REFERENCES planos_de_saude (codigo)
)

CREATE TABLE medico(
codigo				INT				NOT NULL,
nome				VARCHAR(15)		NOT NULL,
especialidade		VARCHAR(35)		NOT NULL,
plano_saude				INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (plano_saude) REFERENCES planos_de_saude (codigo)
)

CREATE TABLE consultas(
medico				INT					NOT NULL,
paciente			VARCHAR(11)			NOT NULL,
data_hora			DATETIME			NOT NULL,
diagnostico			VARCHAR(15)			NOT NULL
PRIMARY KEY (medico, paciente, data_hora)
FOREIGN KEY (medico) REFERENCES medico (codigo),
FOREIGN KEY (paciente) REFERENCES paciente (cpf)
)

INSERT INTO planos_de_saude VALUES
(1234,'Amil','41599856'),
(2345,'Sul América','45698745'),
(3456,'Unimed','48759836'),
(4567,'Bradesco Saúde','47265897'),
(5678,'Intermédica','41415269')

INSERT INTO paciente VALUES
('85987458920','Maria Paula','R. Voluntários da Pátria',589,'Santana','98458741',2345),
('87452136900','Ana Julia','R. XV de Novembro',657,'Centro','69857412',5678),
('23659874100','João Carlos','R. Sete de Setembro',12,'República','74859632',1234),
('63259874100','José Lima','R. Anhaia',768,'Barra Funda','96524156',2345)

INSERT INTO medico VALUES
(1,'Claudio','Clínico Geral',1234),
(2,'Larissa','Ortopedista',2345),
(3,'Juliana','Otorrinolaringologista',4567),
(4,'Sérgio','Pediatra',1234),
(5,'Julio','Clínico Geral',4567),
(6,'Samara','Cirurgião',1234)

INSERT INTO consultas VALUES
(1,'85987458920','2021-02-10 10:30:00','Gripe'),
(2,'23659874100','2021-02-10 11:00:00','Pé Fraturado'),
(4,'85987458920','2021-02-11 14:00:00','Pneumonia'),
(1,'23659874100','2021-02-11 15:00:00','Asma'),
(3,'87452136900','2021-02-11 16:00:00','Sinusite'),
(5,'63259874100','2021-02-11 17:00:00','Rinite'),
(4,'23659874100','2021-02-11 18:00:00','Asma'),
(5,'63259874100','2021-02-12 10:00:00','Rinoplastia')

SELECT m.nome, m.especialidade
FROM medico m
INNER JOIN planos_de_saude ps
ON m.plano_saude = ps.codigo
WHERE ps.nome = 'Amil'

SELECT p.nome, p.rua + ', ' + CONVERT(VARCHAR(05), p.numero) + ', ' + p.bairro AS endereco,
p.telefone, ps.nome
FROM paciente p
INNER JOIN planos_de_saude ps
ON p.plano_saude = ps.codigo

SELECT ps.telefone
FROM planos_de_saude ps
INNER JOIN paciente p
ON ps.codigo = p.plano_saude
WHERE p.nome = 'Ana Julia'

SELECT ps.nome
FROM planos_de_saude ps
LEFT OUTER JOIN paciente p
ON ps.codigo = p.plano_saude
WHERE p.plano_saude IS NULL

SELECT ps.nome
FROM planos_de_saude ps
LEFT OUTER JOIN medico m
ON m.plano_saude = ps.codigo
where m.plano_saude IS NULL

SELECT CONVERT(CHAR(10), c.data_hora, 103) AS data_consulta, CONVERT(CHAR(5), c.data_hora, 108) AS hora_consulta,
m.nome AS nome_medico, p.nome AS paciente_nome, c.diagnostico
FROM consultas c
INNER JOIN medico m
ON c.medico = m.codigo
INNER JOIN paciente p
ON c.paciente = p.cpf

SELECT m.nome AS nome_medico, CONVERT(CHAR(10), c.data_hora, 103) AS data_consulta, 
CONVERT(CHAR(5), c.data_hora, 108) AS hora_consulta,
c.diagnostico
FROM consultas c
INNER JOIN medico m
ON c.medico = m.codigo
INNER JOIN paciente p
ON c.paciente = p.cpf
WHERE p.nome = 'José Lima'

SELECT c.diagnostico, COUNT(c.diagnostico) AS qtd
FROM consultas c
GROUP BY c.diagnostico

SELECT ps.nome, COUNT(ps.codigo) AS qtd_nao_medicos
FROM planos_de_saude ps
LEFT OUTER JOIN medico m
ON ps.codigo = m.plano_saude
WHERE m.plano_saude IS NULL
GROUP BY ps.nome

UPDATE paciente
SET nome = 'João Carlos da Silva'
WHERE nome = 'João Carlos'

DELETE planos_de_saude
WHERE nome = 'Unimed'

EXEC sp_rename 'paciente.rua', 'logradouro', 'column'

ALTER TABLE paciente
ADD data_nasc  DATE    NULL

UPDATE paciente
SET data_nasc = '1990-04-18'
WHERE cpf = '85987458920'

UPDATE paciente
SET data_nasc = '1981-03-25'
WHERE cpf = '87452136900'

UPDATE paciente
SET data_nasc = '2004-09-04'
WHERE cpf = '23659874100'

UPDATE paciente
SET data_nasc = '1986-06-18'
WHERE cpf = '63259874100'