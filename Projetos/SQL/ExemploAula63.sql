--AULA 63 - SELECT

USE Treinamento 

--SELECT * FROM Produto

SELECT CPF, NOME FROM CLIENTE WHERE INATIVO = 0

SELECT CPF, NOME, ENDEREÇO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, ESTADO FROM CLIENTE WHERE INATIVO = 0

--ESTILO SIZEX DE SELECT

SELECT ID,
CPF, 
NOME, 
ENDEREÇO, 
NUMERO, 
COMPLEMENTO, 
BAIRRO, 
CIDADE, 
ESTADO 
FROM CLIENTE 
WHERE INATIVO = 0
AND CIDADE = 'CATANDUVA'
AND COMPLEMENTO <> ''
ORDER BY NOME, NUMERO

USE Treinamento

--exercicio aula 63

--1) Selecionar codigo, nome, cpf, cidade e estado da tabela cliente
--quando o cliente for ativo, de São Paulo e seu RG seja nulo.
SELECT ID AS CODIGO, 
NOME, 
CPF, 
CIDADE, 
ESTADO 
FROM CLIENTE 
WHERE INATIVO = 0 
AND ESTADO = 'SP' 
AND RG = ''

--2) Selecionar todos os produtos que estão ativos e movimentam estoque
SELECT * FROM PRODUTO  WHERE STATUS = 0  AND MOVIMENTACAO = 1

--3) Selecionar codigo, descrição, custo, margem e preco dos produtos
--quando o preco dos produtos estiver entre 1 e 100
SELECT CODIGO, 
DESCRICAO, 
CUSTO, 
MARGEM, 
PRECO 
FROM PRODUTO 
WHERE PRECO > 1 
AND PRECO < 100

--4) Selecionar todas as formas de pagamento que estiverem em boleto
SELECT * 
FROM FORMAPAGAMENTO 
WHERE BOLETO = 1
