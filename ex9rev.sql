CREATE DATABASE ex9rev

USE ex9rev

CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

SELECT * FROM editora
SELECT * FROM autor
SELECT * FROM compra
SELECT * FROM estoque

-- 1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT es.nome, es.valor, ed.nome, au.nome
FROM estoque es
INNER JOIN editora ed
ON es.codEditora = ed.codigo
INNER JOIN autor au
ON au.codigo = es.codAutor

-- 2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT es.nome, co.qtdComprada, co.valor
FROM compra co
INNER JOIN estoque es
ON es.codigo = co.codEstoque
WHERE co.codigo = '15051'

-- 3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT es.nome,
CASE
	WHEN (LEN(ed.site) > 10)
THEN 
	SUBSTRING(ed.site, 5,LEN(ed.site) - 3)
ELSE
ed.site
END AS site
FROM estoque es
INNER JOIN editora ed
ON ed.codigo = es.codEditora
WHERE ed.nome = 'Makron books'

-- 4) Consultar nome do livro e Breve Biografia do David Halliday	
SELECT es.nome, au.biografia
FROM estoque es
INNER JOIN autor au
ON au.codigo = es.codAutor
WHERE au.nome = 'David Halliday'

-- 5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos	
SELECT co.codigo, co.qtdcomprada, es.nome
FROM compra co
INNER JOIN estoque es
ON es.codigo = co.codEstoque
WHERE es.nome = 'Sistemas Operacionais Modernos'

-- 6) Consultar quais livros não foram vendidos	
SELECT es.nome
FROM estoque es LEFT OUTER JOIN compra co
ON es.codigo = co.codEstoque
WHERE co.codigo IS NULL

-- 7) Consultar quais livros foram vendidos e não estão cadastrados
SELECT es.nome
FROM estoque es RIGHT OUTER JOIN compra co
ON es.codigo = co.codEstoque
WHERE es.codigo IS NULL

-- 8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT ed.nome AS nome_editora,
CASE
	WHEN (LEN(ed.site) > 10)
THEN 
	SUBSTRING(ed.site, 5,LEN(ed.site) - 3)
ELSE
ed.site
END AS site
FROM editora ed 
LEFT OUTER JOIN estoque es
ON es.codEditora = ed.codigo
WHERE es.codigo IS NULL

-- 9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT au.nome, au.biografia,
CASE
	WHEN (au.biografia LIKE 'Doutorado%')
THEN
	REPLACE(au.biografia, 'Doutorado', 'Ph.D.')
ELSE
	au.biografia
END AS biografia

FROM estoque es
RIGHT OUTER JOIN autor au 
ON au.codigo = es.codAutor
WHERE es.codAutor IS NULL

-- 10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT TOP 1 au.nome, es.valor
FROM autor au
INNER JOIN estoque es
ON es.codAutor = au.codigo
ORDER BY es.valor DESC

-- 11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.	
SELECT co.codigo, SUM(co.qtdComprada) AS livros_comprados, SUM(co.valor) AS valores_gastos
FROM compra co
GROUP BY co.codigo
ORDER BY co.codigo ASC

-- 12) Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.
SELECT ed.nome, AVG(es.valor) AS media_valor_livro
FROM editora ed
INNER JOIN estoque es
ON es.codEditora = ed.codigo
GROUP BY ed.nome, es.valor
ORDER BY ed.nome, es.valor ASC

-- 13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:	
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	--A Ordenação deve ser por Quantidade ascendente

SELECT es.nome, es.quantidade, ed.nome, 
CASE
	WHEN (LEN(ed.site) > 10)
THEN 
	SUBSTRING(ed.site, 5,LEN(ed.site) - 3)
ELSE
ed.site
END AS site,

CASE 
	WHEN (es.quantidade < 5)
THEN
	'Produto em Ponto de Pedido'
    WHEN (es.quantidade > 5 AND es.quantidade <= 10)
THEN
	'Produto Acabando'
	WHEN (es.quantidade) > 10
THEN
	'Estoque Suficiente'
END AS status

FROM estoque es
INNER JOIN editora ed
ON es.codEditora = ed.codigo
ORDER BY es.quantidade ASC

-- 14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
	-- Só pode concatenar sites que não são nulos
SELECT es.codigo, es.nome, au.nome, ed.nome  + ', ' + ed.site AS nome_editora_site
FROM estoque es
INNER JOIN autor au
ON es.codAutor = au.codigo
INNER JOIN editora ed
ON es.codEditora = ed.codigo
WHERE ed.site IS NOT NULL

-- 15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje	
SELECT co.codigo, DATEDIFF(DAY, co.datacompra, GETDATE()) AS qntd_dias, DATEDIFF(MONTH, co.datacompra, GETDATE()) AS qntd_meses
FROM compra co

-- 16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00	
SELECT co.codigo, SUM(co.valor) AS total_gasto
FROM compra co
GROUP BY co.codigo
HAVING SUM(co.valor) > 200.00