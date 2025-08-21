--AULA69 - STORE PROCEDURE
--BANCODADOS, PROGRAMAÇÃO, BOTAO DIREITO, STORE PROCEDURE
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

-- NÃO ADIANTA EXECUTAR O CODIGO POIS ELE NÃO RECONHECE AS VARIAVEIS
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
		@DTFINAL = N'31/12/2021' --ESTA CORRETO ASSIM, A OUTRA FORMA É ERRADA

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

--criação
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

--execução
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
--   É frequentemente usado para alterar o tipo de dados de uma coluna para uma consulta específica
--   ou para preparar dados para cálculos ou comparações. 
--   Converter uma sequência de texto em um número ou uma data. 

-- - CONVERT
--   Converte um valor de um tipo de dado para outro. 

-- Use CAST em vez de CONVERT se quiser que o código do programa Transact-SQL esteja de acordo com ISO. 
-- Use CONVERT em vez de CAST para usufruir da funcionalidade de estilo de CONVERT.

-- - LIKE
--   É utilizado para encontrar valores em um campo que correspondam a um determinado padrão,
--   usando caracteres curinga (%, _) para representar grupos de caracteres.
--   Filtrar dados com base em partes de strings. 

-- - FOR XML PATH
--   Serve para trazer os dados todos em uma unica coluna
--   Separa os numeros por traços, ele coloca todos os numeros em uma unica coluna, e o traço da concatenação os separa

-- ENTENDER O CODIGO EM SI
--    a procedure recebe um codigo de um produto do vb
--    ela trata esse codigo o comparando com o codigo da venda
--    se esse codigo for igual, ele traz muitas informações de diferentes tabelas como
--    venda: id, dataped, nome do cliente, numero que recebeu o nome de NrNFe, total de desc,
--        impostos que é a junção de dois impostos ST e Ipi, total frete, total geral com esses descontos e acrescimos,
--        total liquido de tudo, numero do talao que é convertido para uma varchar de 200, e observacao
--        a maioria dos campos acima usam o isnull para testar se algum valor é nulo, recebendo um valor padrão
--    vendaitens: qtde, vslor unitario, total itens
--    pessoa cliente: cpf ou cnpj, endereço (se ele for nulo recebe vazio, acaso não for nulo ele concatena as infos), cod ant (feito um cast para conversão para varchar de 40)
--    pessoa empresa: nome da empresa, nome fantasia, cpf/cnpj, endereco (como no cliente, o endereço se não for vazio ele concatena, e se for vazio continua), o fone
-- A DIFERENCIAÇÃO DA PESSOA SE DA NO JOIN, QUE SÃO FEITOS DOIS, CADA UM PARA CADA TIPO DE PESSOA
--    produto: codigo, descricao
--    usuario: nome o usuario
--    config: puxa o logo da empresa
--    formapag: puxa a descricao que seria o nome da forma de pagamento

--    algumas tabelas não foram inseridsa no inner join, mas foram usadas para subselects
--    para trazer uma nformação ou outra, como
--    pessoa contatos (fone cliente): aonde ela salva o contato das pessoas, convertendo para varchar de 200 e trazendo o valor unico, distinto, sem repetir contatos da mesma pessoa,
--         ele traz os contatos que tem fone ou celular no tipo, aonde o pessoa id é equivalente nas duas tabelas, e o valor seja diferente de nulo.
--    pessoa contatos (fone empresa e email empresa): seleciona o primeiro contato da empresa, aonde esse contato tenha mail ou site no nome,
--	       o id da empresa e do pessoa id sejam iguais, e o valor seja diferente de nulo/vazio
--    venda serviços: aqui ele puxa um count, que conta quantos id tem na tabela venda serviços, dando assim a quantidade de serviços prestados a venda
--    titulo: aqui ele puxa u count, para contar os ids da titulo, dando a quantidade de titulos/condiçoes que existem na venda

-- ESTA PROCEDURE É BEM COMPLEXA POIS RELACIONA MUITAS TABELAS, MAS NÃO É MUITO DIFICIL TIRANDO ALGUMAS CONCATENAÇÕES E CONVERSÕES
-- ELA SERVE PARA FAZER UM RELATORIO GERAL DE CADA VENDA, PARA VER UM PANORAMA GERAL DA CADA VENDA



--AULA70 - CORREÇÃO

-- %algo no meio%
-- %algo no começo
-- algo no final%

-- IDENTAÇÃO = deixa mais legivel