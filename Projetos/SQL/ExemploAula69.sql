--AULA69 - STORE PROCEDURE
--BANCODADOS, PROGRAMA��O, BOTAO DIREITO, STORE PROCEDURE
--CRIA ESTE DOC, CONFIGURAR AS INFOS ABAIXO

USE TREINAMENTO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <10/06/25>
-- Description:	<TAREFA: -- - RETORNA DADOS DA VENDA>
-- =============================================

--PARA RELATORIOS -> CREATE PROCEDURE PRO_REL_NOMERELATORIO

CREATE PROCEDURE PRO_DADOS_VENDAS 
	-- Add the parameters for the stored procedure here
	@DTINICIAL DATETIME,
	@DTFINAL DATETIME
AS
BEGIN
	SELECT     V.ID,
			   V.DATAPEDIDO,
			   C.NOME,
			   SUM(VI.QTDE * VI.VRUNITARIO) AS TOTALVENDA,
			   COUNT(VI.ID) AS TOTALITENS,
			   ISNULL(SUM(T.VALOR),0) AS FINANCEIRO
		  FROM VENDA AS V INNER JOIN CLIENTE AS C ON V.CLIENTEID = C.ID
	INNER JOIN VENDAITENS AS VI ON V.ID = VI.VENDAID
	 LEFT JOIN TITULO AS T ON V.ID = T.VENDAID
		 WHERE V.DATAPEDIDO >= @DTINICIAL
		   AND V.DATAPEDIDO <= @DTFINAL
	  GROUP BY V.ID, V.DATAPEDIDO, C.NOME
END

-- N�O ADIANTA EXECUTAR O CODIGO POIS ELE N�O RECONHECE AS VARIAVEIS
-- MAS COM O CODIGO VB ELE MANDA AS VARIAVEIS E AI FUNCIONARIA

	 
/****** Object:  StoredProcedure [dbo].[PRO_DADOS_VENDAS]    Script Date: 10/06/2025 16:03:40 ******/
--ALTERAR PROCEDURE
--BOTAO DIREITO
--CODIGO
ALTER PROCEDURE [dbo].[PRO_DADOS_VENDAS] 
	-- Add the parameters for the stored procedure here
	@DTINICIAL DATETIME,
	@DTFINAL DATETIME
AS
BEGIN
	SELECT     V.ID,
			   V.DATAPEDIDO,
			   C.NOME,
			   SUM(VI.QTDE * VI.VRUNITARIO) AS TOTALVENDA,
			   COUNT(VI.ID) AS TOTALITENS,
			   ISNULL(SUM(T.VALOR),0) AS FINANCEIRO
		  FROM VENDA AS V INNER JOIN CLIENTE AS C ON V.CLIENTEID = C.ID
	INNER JOIN VENDAITENS AS VI ON V.ID = VI.VENDAID
	 LEFT JOIN TITULO AS T ON V.ID = T.VENDAID
		 WHERE V.DATAPEDIDO >= @DTINICIAL
		   AND V.DATAPEDIDO <= @DTFINAL
	  GROUP BY V.ID, V.DATAPEDIDO, C.NOME
END

--EXECUTAR PROCEDURE
--BOTAO DIREITO, EXECUTE
-- OU CODIGO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[PRO_DADOS_VENDAS]
		@DTINICIAL = N'01/01/2021', --01/01/2021 FORMA ERRADA
		@DTFINAL = N'31/12/2021' --ESTA CORRETO ASSIM, A OUTRA FORMA � ERRADA

SELECT	'Return Value' = @return_value

GO

--EXERCICIO - AULA69

--CRIAR STORE PROCEDURE QUE TRAGA NUMERO DA VENDA, VENDAS DE UM DETERMINADO PERIODO
--NOME DO CLIENTE
--COD PROD, DESC, QTDE, VR UNIT, TOTAL

-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <10/06/25>
-- Description:	<TAREFA: 01 - AULA69 - RETORNA DADOS DA VENDA>
-- =============================================

--cria��o
CREATE PROCEDURE PRO_VENDAS_AULA69 
	-- Add the parameters for the stored procedure here
	@DTINICIAL DATETIME,
	@DTFINAL DATETIME
AS
BEGIN
	SELECT     V.ID,
			   C.NOME,
			   P.CODIGO AS 'COD-PROD',
			   P.DESCRICAO AS 'PRODUTO',
			   VI.QTDE,
			   VI.VRUNITARIO,
			   ROUND((SELECT SUM(ISNULL(QTDE, 0) * VRUNITARIO) FROM VENDAITENS AS VI WHERE VI.VENDAID = V.ID),2) AS TOTALVENDA
		  FROM VENDA AS V INNER JOIN CLIENTE AS C ON V.CLIENTEID = C.ID
	INNER JOIN VENDAITENS AS VI ON V.ID = VI.VENDAID
	INNER JOIN PRODUTO AS P ON VI.PRODUTOID = P.ID
	 LEFT JOIN TITULO AS T ON V.ID = T.VENDAID
		 WHERE V.DATAPEDIDO >= @DTINICIAL
		   AND V.DATAPEDIDO <= @DTFINAL

END

--execu��o
DECLARE	@return_value int

EXEC	@return_value = [dbo].[PRO_VENDAS_AULA69]
		@DTINICIAL = N'01/01/2025',
		@DTFINAL = N'31/12/2025'

SELECT	'Return Value' = @return_value


--SOLUTEC
--PROCEDURE REL_IMP_VENDA
--EXPLICAR O QUE ELA FAZ, CADA COMANDO
--PESQUISAR E REALEMENTE EXPLICAR TUDO

--PRIMEIRAMENTE BUSCAR E ENTENDER OS CODIGOS DESCONHECIDOS
-- - CAST
--   Converte um valor de um tipo de dado para outro. 
--   � frequentemente usado para alterar o tipo de dados de uma coluna para uma consulta espec�fica
--   ou para preparar dados para c�lculos ou compara��es. 
--   Converter uma sequ�ncia de texto em um n�mero ou uma data. 

-- - CONVERT
--   Converte um valor de um tipo de dado para outro. 

-- Use CAST em vez de CONVERT se quiser que o c�digo do programa Transact-SQL esteja de acordo com ISO. 
-- Use CONVERT em vez de CAST para usufruir da funcionalidade de estilo de CONVERT.

-- - LIKE
--   � utilizado para encontrar valores em um campo que correspondam a um determinado padr�o,
--   usando caracteres curinga (%, _) para representar grupos de caracteres.
--   Filtrar dados com base em partes de strings. 

-- - FOR XML PATH
--   Serve para trazer os dados todos em uma unica coluna
--   Separa os numeros por tra�os, ele coloca todos os numeros em uma unica coluna, e o tra�o da concatena��o os separa

-- ENTENDER O CODIGO EM SI
--    a procedure recebe um codigo de um produto do vb
--    ela trata esse codigo o comparando com o codigo da venda
--    se esse codigo for igual, ele traz muitas informa��es de diferentes tabelas como
--    venda: id, dataped, nome do cliente, numero que recebeu o nome de NrNFe, total de desc,
--        impostos que � a jun��o de dois impostos ST e Ipi, total frete, total geral com esses descontos e acrescimos,
--        total liquido de tudo, numero do talao que � convertido para uma varchar de 200, e observacao
--        a maioria dos campos acima usam o isnull para testar se algum valor � nulo, recebendo um valor padr�o
--    vendaitens: qtde, vslor unitario, total itens
--    pessoa cliente: cpf ou cnpj, endere�o (se ele for nulo recebe vazio, acaso n�o for nulo ele concatena as infos), cod ant (feito um cast para convers�o para varchar de 40)
--    pessoa empresa: nome da empresa, nome fantasia, cpf/cnpj, endereco (como no cliente, o endere�o se n�o for vazio ele concatena, e se for vazio continua), o fone
-- A DIFERENCIA��O DA PESSOA SE DA NO JOIN, QUE S�O FEITOS DOIS, CADA UM PARA CADA TIPO DE PESSOA
--    produto: codigo, descricao
--    usuario: nome o usuario
--    config: puxa o logo da empresa
--    formapag: puxa a descricao que seria o nome da forma de pagamento

--    algumas tabelas n�o foram inseridsa no inner join, mas foram usadas para subselects
--    para trazer uma nforma��o ou outra, como
--    pessoa contatos (fone cliente): aonde ela salva o contato das pessoas, convertendo para varchar de 200 e trazendo o valor unico, distinto, sem repetir contatos da mesma pessoa,
--         ele traz os contatos que tem fone ou celular no tipo, aonde o pessoa id � equivalente nas duas tabelas, e o valor seja diferente de nulo.
--    pessoa contatos (fone empresa e email empresa): seleciona o primeiro contato da empresa, aonde esse contato tenha mail ou site no nome,
--	       o id da empresa e do pessoa id sejam iguais, e o valor seja diferente de nulo/vazio
--    venda servi�os: aqui ele puxa um count, que conta quantos id tem na tabela venda servi�os, dando assim a quantidade de servi�os prestados a venda
--    titulo: aqui ele puxa u count, para contar os ids da titulo, dando a quantidade de titulos/condi�oes que existem na venda

-- ESTA PROCEDURE � BEM COMPLEXA POIS RELACIONA MUITAS TABELAS, MAS N�O � MUITO DIFICIL TIRANDO ALGUMAS CONCATENA��ES E CONVERS�ES
-- ELA SERVE PARA FAZER UM RELATORIO GERAL DE CADA VENDA, PARA VER UM PANORAMA GERAL DA CADA VENDA



--AULA70 - CORRE��O

-- %algo no meio%
-- %algo no come�o
-- algo no final%

-- IDENTA��O = deixa mais legivel