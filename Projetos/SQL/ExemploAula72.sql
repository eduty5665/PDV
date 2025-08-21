--AULA 72 - TRIGGER

USE TREINAMENTO

--TRIGGER É UM GATILHO
--FUNCÃO CHAMADA APOS ALGUM EVENTO

--EXEMPLO TRIGGERS SOLUTEC


-- =============================================
-- Author:		<AUTHOR>
-- Create date: <DATE>
-- Description:	<DESC>
-- =============================================

/****** Object:  Trigger [dbo].[TG_STATUS_TITULO]    Script Date: 11/06/2025 16:56:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER TRIGGER [dbo].[TG_STATUS_TITULO] --NOME TRIGGERS
ON [dbo].[LancamentoBancario] --REFERENCIANDO A TABELA
AFTER INSERT --EVENTO, GATILHO É CHAMADO APOS ISSO
AS
BEGIN
	DECLARE --DECLARA AS VARIAVEIS
		@VALOR  DECIMAL(18,2), 
		@TID    INT
		
		SELECT @TID = ISNULL(TITULOID,0) FROM INSERTED	
		
		--CRIA OS SELECTS PARA AFUNILAR OS DADOS/COMPARAR
		SELECT @VALOR = round( ISNULL(SUM(VALOR),0) ,2)
		  FROM LANCAMENTOBANCARIO LB
		 WHERE LB.TITULOID = @TID
		
		 --DA O UPDATE... REALMENTE ATUALIZA, FUNCIONAMENTO DA TRIGGER EM SI
		 UPDATE TITULO SET TITULO.STATUS = (CASE WHEN round(TITULO.VALOR ,2) <= @VALOR THEN
												'LIQUIDADO'
											ELSE 
												
													'ABERTO'
												
												
											END ) WHERE TITULO.ID = @TID

END


--ESSA FUNÇÃO FOI IMITADA TRES VEZES, A MESMA FUNÇÃO
--SO MUDOU O EVENTO, AFTER UPDATE / AFTER DELETE



--================================================================================================================
----------------------------------------------------EXERCICIO-----------------------------------------------------
--================================================================================================================

--CRIAR TRIGGERS PARA OS DOIS CAMPOS CALCULADOS
--REMOVER AS FUNÇÕES DOS CAMPOS E NÃO DO BANCO


--================================================================================================================
-----------------------------------------<TRIGGER PARA TOTAL DO ITEM>---------------------------------------------
--================================================================================================================

--INSERT
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DO ITEM INS>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_ITEM_INS] 
   ON  [dbo].[VENDAITENS]
   AFTER INSERT
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM INSERTED

	SELECT @TOTAL = ROUND((ISNULL(VI.QTDE, 0) * ISNULL(VI.VRUNITARIO, 0)),2) FROM VENDAITENS AS VI WHERE VI.ID = @ID

	UPDATE VENDAITENS SET VENDAITENS.TOTITEM = @TOTAL WHERE VENDAITENS.ID = @ID

END
GO

--UPDATE
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DO ITEM UPD>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_ITEM_UPD] 
   ON  [dbo].[VENDAITENS]
   AFTER UPDATE
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM INSERTED

	SELECT @TOTAL = ROUND((ISNULL(VI.QTDE, 0) * ISNULL(VI.VRUNITARIO, 0)),2) FROM VENDAITENS AS VI WHERE VI.ID = @ID

	UPDATE VENDAITENS SET VENDAITENS.TOTITEM = @TOTAL WHERE VENDAITENS.ID = @ID

END
GO

--DELETE
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DO ITEM DEL>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_ITEM_DEL] 
   ON  [dbo].[VENDAITENS]
   AFTER DELETE
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM DELETED

	SELECT @TOTAL = ROUND((ISNULL(VI.QTDE, 0) * ISNULL(VI.VRUNITARIO, 0)),2) FROM VENDAITENS AS VI WHERE VI.ID = @ID

	UPDATE VENDAITENS SET VENDAITENS.TOTITEM = @TOTAL WHERE VENDAITENS.ID = @ID

END
GO


--================================================================================================================
-----------------------------------------<TRIGGER PARA TOTAL DA VENDA>--------------------------------------------
--================================================================================================================

--INSERT
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DA VENDA INS>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_VENDA_INS] 
   ON  [dbo].[VENDA]
   AFTER INSERT
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM INSERTED

	SELECT @TOTAL = ROUND(SUM(VI.TOTALITEM),2) FROM VENDAITENS AS VI WHERE VI.VENDAID = @ID

	UPDATE VENDA SET VENDA.TOTVENDA = @TOTAL WHERE VENDA.ID = @ID

END
GO

--UPDATE
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DA VENDA UPD>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_VENDA_UPD] 
   ON  [dbo].[VENDA]
   AFTER UPDATE
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM INSERTED

	SELECT @TOTAL = ROUND(SUM(VI.TOTALITEM),2) FROM VENDAITENS AS VI WHERE VI.VENDAID = @ID

	UPDATE VENDA SET VENDA.TOTVENDA = @TOTAL WHERE VENDA.ID = @ID
END
GO

--DELETE
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LEMES>
-- Create date: <11/06/2025>
-- Description:	<TRIGGER PARA TOTAL DA VENDA DEL>
-- =============================================
CREATE TRIGGER [dbo].[TG_TOTAL_VENDA_DEL] 
   ON  [dbo].[VENDA]
   AFTER DELETE
AS 
BEGIN
	DECLARE
	@ID INT,
	@TOTAL NUMERIC(18,2)

	SELECT @ID = ISNULL(ID,0) FROM DELETED

	SELECT @TOTAL = ROUND(SUM(VI.TOTALITEM),2) FROM VENDAITENS AS VI WHERE VI.VENDAID = @ID

	UPDATE VENDA SET VENDA.TOTVENDA = @TOTAL WHERE VENDA.ID = @ID

END
GO
