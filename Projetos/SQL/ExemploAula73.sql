--================================================================================================================
-----------------------------------------AULA 73 - TRIGGER FINAL---------------------------------------------
--================================================================================================================


--CORREÇÃO DAS TTRIGGERS DA AULA 72




--ANALISANDO STORE PROCEDURE DE UM EXTRATO BANCARIO

USE SOLUTEC

/****** Object:  StoredProcedure [dbo].[REL_EXTRATO]    Script Date: 12/06/2025 14:31:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 06/05/2019
-- Description:	TAREFA 18987
-- =============================================
ALTER PROCEDURE [dbo].[REL_EXTRATO]
	@Inicial datetime,
	@Final datetime,
	@Conciliado as bit,
	@Emp Int,
	@Conta Int
AS
BEGIN
--SALDO ANTERIOR
DECLARE @SaldoAnt numeric(18,2)
select @saldoAnt = ISNULL((SELECT SUM(VALORLIQUIDO) FROM LANCAMENTOBANCARIO L WHERE L.DATACONCILIACAO <= DATEADD(DAY,-1,@INICIAL) AND L.EMPRESAID = @Emp and L.ContaId = @Conta AND L.tIPO = 'C' and conciliado = 1),0) -
				   ISNULL((SELECT SUM(VALORLIQUIDO) FROM LANCAMENTOBANCARIO L WHERE L.DATACONCILIACAO <= DATEADD(DAY,-1,@INICIAL) AND L.EMPRESAID = @Emp and L.ContaId = @Conta AND L.tIPO = 'D'and conciliado = 1),0)  
--DATEADD ACRESCENTA OU DECREMENTA ALGUMA DATA, INFORMAR QUE É DIA/MES/ANO, VALOR A SER + OU -, DATA QUE DESEJA + OU -
--ACIMA ELE ENCONTRA O SALDO ANTERIOR
--VALOR DE CREDITO LIQUIDO SOMADO - VALOR DE DEBITO LIQUIDO SOMADO = SALDO ANTERIOR
SELECT DATEADD(DAY,-1,@INICIAL) as Data,
	   'SALDO ANTERIOR' AS Descricao,
	   CASE WHEN @SaldoAnt >0 THEN 'C' ELSE 'D' end AS Tipo,
	   @SaldoAnt AS ValorConciliado,
	   1 as conciliado,
	   (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO
UNION ALL --UNE AS DUAS CONSULTAS, A CONSULTA ACIMA E DE BAIXO, EM UMA UNICA LINHA
	SELECT LB.DataConciliacao AS DATA,
	   CASE WHEN ISNULL(LB.TITULOID,0) =0 THEN '' ELSE 'Título Nr: '  + CONVERT(VARCHAR(15),ISNULL(TITULOID,0)) END +  ' ' + ISNULL(LB.NRDOC,'') + CASE WHEN ISNULL(NRDOC,'') = '' THEN ISNULL(LB.TipoPagamento,'') ELSE ' - ' + ISNULL(LB.TipoPagamento,'')   END + ' - ' + 
	   ISNULL((SELECT NOME FROM CentroResultado CR INNER JOIN TITULO T ON T.CENTRORESULTADOID = CR.ID WHERE T.ID = ISNULL(LB.TituloId ,0)),'')  + CHAR(13) +
	   ISNULL((SELECT NOME FROM PESSOA P INNER JOIN TITULO T ON T.PESSOAID = P.ID WHERE T.ID = ISNULL(LB.TituloId ,0)),'')  + CHAR(13) +
	   CONVERT(VARCHAR(5000),ISNULL(LB.OBS,'')) AS DESCRICAO,
	   LB.TIPO,
	   CASE WHEN LB.TIPO = 'D' THEN LB.ValorLiquido * -1 ELSE LB.ValorLiquido END AS ValorConciliado,
	   LB.Conciliado ,
	   (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO
	FROM LANCAMENTOBANCARIO LB
	WHERE LB.DATACONCILIACAO >= @Inicial
	AND   LB.DATACONCILIACAO < @Final
	AND   LB.EMPRESAID = @EMP
	AND   LB.CONTAID = @CONTA
	AND   LB.CONCILIADO = CASE WHEN @Conciliado =1 THEN 1 ELSE LB.Conciliado END
	ORDER BY 1
END


