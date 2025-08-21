-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<EDUARDO LUCAS LEMES JANUARIO>
-- Create date: <07/08/25>
-- Description:	<Procedure de relatorio para clientes ativos>
-- =============================================
CREATE PROCEDURE REL_CLIENTES 
	@INATIVO BIT

AS
BEGIN
		SELECT NOME,
		   ENDEREÇO + ', ' + ISNULL(NUMERO, '') + ' - ' + ISNULL(COMPLEMENTO, '') AS ENDERECO,
		   (SELECT TOP 1 DADOSCONTATO FROM CLIENTECONTATOS AS CT WHERE C.ID = CT.CLIENTEID AND TIPOCONTATO LIKE '%FONE%') AS CONTATO,
		   CIDADE
	  FROM CLIENTE AS C
	  WHERE C.INATIVO = ISNULL(@INATIVO, C.INATIVO)
END

GO
