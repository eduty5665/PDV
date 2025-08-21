--AULA71 - FUN��O SCALAR

USE TREINAMENTO


--DADOS PADROES
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<FUN��O DE TOTAL DO ITEM>
-- =============================================

--CRIA��O
CREATE FUNCTION FUN_TOTAL_ITEM 
(
	@ID INT
)
RETURNS NUMERIC(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @VR NUMERIC(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @VR = ROUND((ISNULL(VI.QTDE, 0) * ISNULL(VI.VRUNITARIO, 0)),2) FROM VENDAITENS AS VI WHERE VI.ID = @ID

	-- Return the result of the function
	RETURN ROUND(@VR, 2)

END
GO

--EXECU��O
--CHAMADA DA FUNC NO CAMPO TOTALITEM DA TABELA VENDAITENS

--TESTE
SELECT * FROM VENDAITENS


------------------------------------------------------------------------------------------------------------------
----------------------------------------------------EXERCICIO-----------------------------------------------------
------------------------------------------------------------------------------------------------------------------


--EXERCICIO
--FAZER UMA FUNCAO, NA TABELA VENDA, CAMPO TOTAL VENDA == SOMATORIO DOS ITENS


--DADOS PADROES
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<FUN��O DE TOTAL DA VENDA>
-- =============================================

--CRIA��O
CREATE FUNCTION FUN_TOTAL_VENDA 
(
	@ID INT
)
RETURNS NUMERIC(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @VR NUMERIC(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @VR = (SELECT ROUND(SUM(ISNULL(VI.TOTALITEM, 0)),2) FROM VENDAITENS AS VI WHERE VI.VENDAID = V.ID) FROM VENDA AS V WHERE V.ID = @ID
	--SELECT @VR = ROUND(SUM(vi.TOTALITEM),2) FROM VENDAITENS AS VI WHERE VI.VENDAID = @ID

	-- Return the result of the function
	RETURN ROUND(@VR, 2)

END
GO

--EXECU��O
--CHAMADA DA FUNC NO CAMPO TOTALVENDA DA TABELA VENDA

--TESTE
SELECT * FROM VENDA
SELECT * FROM VENDAITENS