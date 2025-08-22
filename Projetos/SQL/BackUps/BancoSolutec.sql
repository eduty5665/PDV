USE [master]
GO
/****** Object:  Database [Solutec]    Script Date: 22/08/2025 10:23:30 ******/
CREATE DATABASE [Solutec]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Yama', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Solutec.mdf' , SIZE = 1326080KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Yama_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Solutec_log.ldf' , SIZE = 164672KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Solutec] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Solutec].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Solutec] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Solutec] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Solutec] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Solutec] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Solutec] SET ARITHABORT OFF 
GO
ALTER DATABASE [Solutec] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Solutec] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Solutec] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Solutec] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Solutec] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Solutec] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Solutec] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Solutec] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Solutec] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Solutec] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Solutec] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Solutec] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Solutec] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Solutec] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Solutec] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Solutec] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Solutec] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Solutec] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Solutec] SET  MULTI_USER 
GO
ALTER DATABASE [Solutec] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Solutec] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Solutec] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Solutec] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Solutec] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Solutec] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Solutec] SET QUERY_STORE = OFF
GO
USE [Solutec]
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_CUSTO_TOTAL_COMPOSICAO_ITEM]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 20/12/2018
-- Description:	RETORNA CUSTO TOTAL DO ITEM DE COMPOSIÇÃO - 17150
-- =============================================
CREATE FUNCTION [dbo].[FUN_CUSTO_TOTAL_COMPOSICAO_ITEM](
	@IdItem int,
	@OrigemId int
)
RETURNS numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @result = ROUND((isnull(PC.Qtde,0) * P.Custo ),2)  FROM PRODUTOCOMPOSICAO PC INNER JOIN PRODUTO P ON PC.ITEMID = P.ID WHERE ITEMID = @IdItem and Origemid = @OrigemId

	-- Return the result of the function
	RETURN @result

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_PRAZO_TITULO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 23/04/2018
-- Description:	CALCULA O PRAZO DE PAGAMENTO
-- =============================================
CREATE FUNCTION [dbo].[FUN_PRAZO_TITULO]
(
	@Id int
)
RETURNS int
AS
BEGIN
	
	DECLARE @prazo int

	-- Add the T-SQL statements to compute the return value here
	SELECT @prazo = datediff(DAY,Abertura,Vencimento) from Titulo where id = @Id

	-- Return the result of the function
	RETURN @prazo

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_SALDO_COM_PROVISAO_POR_PRODUTO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FUN_SALDO_COM_PROVISAO_POR_PRODUTO]
(
	-- Add the parameters for the function here
	-- Add the parameters for the function here
	@produtoId INT,
	@empresaId INT
)
RETURNS NUMERIC(18,4)
AS
BEGIN
	DECLARE @saldo NUMERIC(18,4)
	DECLARE @provisionado NUMERIC(18,4)

	set @saldo = dbo.FUN_SALDO_ESTOQUE_POR_PRODUTO(@produtoId, @empresaId)
	set @provisionado = dbo.FUN_SALDO_PROVISIONADO_POR_PRODUTO(@produtoId, @empresaId)

	return @saldo + @provisionado
END



GO
/****** Object:  UserDefinedFunction [dbo].[FUN_SALDO_ESTOQUE_POR_PRODUTO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FUN_SALDO_ESTOQUE_POR_PRODUTO]
(
	-- Add the parameters for the function here
	-- Add the parameters for the function here
	@produtoId INT,
	@empresaId INT
)
RETURNS NUMERIC(18,4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @qtdeEntrada NUMERIC(18,4)
	DECLARE @qtdeSaida NUMERIC(18,4)

	-- Add the T-SQL statements to compute the return value here
	SELECT @qtdeEntrada = isnull(Round(SUM(Estoque.Qtde), 4),0) FROM Estoque WHERE Estoque.EmpresaId = @empresaId and Estoque.Tipo = 'E' and estoque.ProdutoId = @produtoId
	SELECT @qtdeSaida = isnull(Round(SUM(Estoque.Qtde), 4),0) FROM Estoque WHERE Estoque.EmpresaId = @empresaId and Estoque.Tipo = 'S' and estoque.ProdutoId = @produtoId

	-- Return the result of the function
	RETURN @qtdeEntrada - @qtdeSaida

END


GO
/****** Object:  UserDefinedFunction [dbo].[FUN_SALDO_PROVISIONADO_POR_PRODUTO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FUN_SALDO_PROVISIONADO_POR_PRODUTO]
(
	-- Add the parameters for the function here
	-- Add the parameters for the function here
	@produtoId INT,
	@empresaId INT
)
RETURNS NUMERIC(18,4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @qtde NUMERIC(18,4)
	
	-- Add the T-SQL statements to compute the return value here
	SELECT @qtde = isnull(Round(SUM(VendaItens.Qtde), 4),0) 
	FROM Venda 
	     inner join VendaItens on VendaItens.VendaId = Venda.Id 
	WHERE Venda.EmpresaId = @empresaId and VendaItens.ProdutoId = @produtoId
	and   ((Venda.Tipo = 'PEDIDO' and Venda.Status = 'ABERTA') OR (Venda.Tipo = 'NOTA FISCAL' and Venda.Status IN ('NFe-REJEITADA','ABERTA')))

	-- Return the result of the function
	RETURN @qtde

END


GO
/****** Object:  UserDefinedFunction [dbo].[FUN_SALDO_SEPARAR_ITEM]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR 
-- Create date: 23/12/2018
-- Description:	Saldo a separar
-- =============================================
CREATE FUNCTION [dbo].[FUN_SALDO_SEPARAR_ITEM]
(
	@id int
)
RETURNS numeric(18,4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @vr numeric(18,4)

	-- Add the T-SQL statements to compute the return value here
	SELECT @VR = (ISNULL(VI.Qtde,0) - ISNULL(VI.QTDESEPARADA,0 ))  FROM VendaSeparacao VI WHERE VI.ID = @ID

	-- Return the result of the function
	RETURN ROUND(@VR,2)

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_SALDO_SEPARAR_ITEM_TROCA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR 
-- Create date: 23/12/2018
-- Description:	Saldo a separar
-- =============================================
CREATE FUNCTION [dbo].[FUN_SALDO_SEPARAR_ITEM_TROCA]
(
	@id int
)
RETURNS numeric(18,4)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @vr numeric(18,4)

	-- Add the T-SQL statements to compute the return value here
	SELECT @VR = (ISNULL(VI.Qtde,0) - ISNULL(VI.QTDESEPARADA,0 ))  FROM TrocaSeparacao VI WHERE VI.ID = @ID

	-- Return the result of the function
	RETURN ROUND(@VR,2)

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_TOTAIS_NF]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 01/05/2018
-- Description:	RETORNA TOTAL CONFORME PARAMETRO - TAREFA: 11945
-- =============================================
CREATE FUNCTION [dbo].[FUN_TOTAIS_NF]
(
	@Id Int,
	@Tp char(2)
)
RETURNS Numeric(18,2)
AS
BEGIN
	
	DECLARE @vr Numeric(18,2)

	IF @Tp = 'BI'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(BaseIcms,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
     ELSE IF @Tp = 'VI'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorIcms,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'BS'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(BaseST,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'VS'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorST,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'FR'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorFrete,0) ),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'DS'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorDesconto,0)),0) FROM VendaItens WHERE VendaId = @Id
           SELECT @vr= @vr + isnull(SUM(ISNULL(ValorDesconto,0)),0) FROM VendaServicos WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'IP'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorIpi,0) ),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'PI'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorPis,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'CO'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorCofins,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'OT'
        BEGIN
           SELECT @vr= isnull(SUM(ISNULL(ValorOutros,0)),0) FROM VendaItens WHERE VendaId = @Id
        END
	 ELSE IF @Tp = 'NF'
        BEGIN
           SELECT @vr= ( SUM(ISNULL(TotalItem,0)) + SUM(ISNULL(ValorIpi,0)) + SUM(ISNULL(ValorST,0)) + SUM(ISNULL(ValorFrete,0)) + SUM(ISNULL(ValorOutros,0))) - SUM(ISNULL(ValorDesconto ,0)) FROM VendaItens WHERE VendaId = @Id
		   if @vr is null
		   begin
			set @vr = 0
		   end
        END


	RETURN ROUND(@vr,2)

END



GO
/****** Object:  UserDefinedFunction [dbo].[FUN_TOTAL_PEDIDOS_ROMANEIO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 30/08/2018
-- Description:	RETORNA TOTAL DE PEDIDOS DO ROMANEIO - TAREFA 14928
-- =============================================
CREATE FUNCTION [dbo].[FUN_TOTAL_PEDIDOS_ROMANEIO] 
(
	@Id Int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @tot int

	-- Add the T-SQL statements to compute the return value here
	SELECT @tot = Count(id) FROM VENDA WHERE ROMANEIOID = @ID

	-- Return the result of the function
	RETURN @tot

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_TOTAL_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 31/12/2018
-- Description:	RETORNA TOTAL DA VENDA + O SERVICO
-- =============================================
CREATE FUNCTION [dbo].[FUN_TOTAL_VENDA]
(
	@Id Int
)
RETURNS Numeric(18,2)
AS
BEGIN
	
	DECLARE @vr Numeric(18,2)

	
        BEGIN
           SELECT @vr= isnull( ( SUM(ISNULL(TotalItem,0)) + SUM(ISNULL(ValorIpi,0)) + SUM(ISNULL(ValorST,0)) + SUM(ISNULL(ValorFrete,0)) + SUM(ISNULL(ValorOutros,0))) - SUM(ISNULL(ValorDesconto ,0)),0) FROM VendaItens WHERE VendaId = @Id
		   if @vr is null 
		   begin
		     set @vr = 0
		   end
		   set @vr = @vr + isnull((SELECT isnull(SUM(isnull(VALOR,0) - isnull(ValorDesconto,0)),0) FROM VendaServicos WHERE VENDAID = @Id),0)
        END


	RETURN ROUND(@vr,2)

END




GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_BAIXADO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		LAURO
-- Create date: 18/04/2018
-- Description:	RETORNA O VALOR BAIXADO DO TITULO
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_BAIXADO]
(
	-- Add the parameters for the function here
	@titId INT
)
RETURNS NUMERIC(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @vr NUMERIC(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @vr = SUM(VALOR)  FROM LANCAMENTOBANCARIO WHERE TITULOID = @titId

	-- Return the result of the function
	RETURN @vr

END



GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_LIQ_LANCTO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 06/05/2019
-- Description:	TAREFA 17250
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_LIQ_LANCTO]
(
	@Id Int
)
RETURNS Numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Vr Numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Vr = ROUND((ISNULL(LB.Valor,0) + ISNULL(LB.JUROS,0) + ISNULL(LB.MULTA,0)) - ISNULL(LB.DESCONTO,0),2) FROM LancamentoBancario LB  WHERE LB.ID = @Id

	-- Return the result of the function
	RETURN @vR

END

GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_LIQUIDO_TITULO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 08/05/2018
-- Description:	RETORNA VALOR TOTAL LIQUIDO Do Titulo
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_LIQUIDO_TITULO]
(
	@Id Int
)
RETURNS Numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Vr numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @vr = ((ISNULL(ti.Valor ,0) + ISNULL(ti.Juros  ,0) + ISNULL(ti.Multa ,0))  - ISNULL(ti.desconto ,0) - isnull(ti.ValorBaixado,0))   FROM Titulo Ti WHERE Ti.Id  = @Id 

	-- Return the result of the function
	RETURN round(@vr,2)

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_LIQUIDO_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 16/04/2017
-- Description:	RETORNA VALOR TOTAL LIQUIDO DA VENDA
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_LIQUIDO_VENDA]
(
	@Id Int
)
RETURNS Numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Vr numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @vr = (SUM(ISNULL(vi.TotalItem,0)) + SUM(ISNULL(vi.ValorIpi,0)) + SUM(ISNULL(vi.ValorST ,0)) + SUM(ISNULL(vi.ValorFrete ,0))) - SUM(ISNULL(vi.ValorDesconto ,0)) FROM VendaItens vi WHERE vi.VendaId = @Id 

	-- Return the result of the function
	RETURN round(@vr,2)

END
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_PRODUTOS_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 16/04/2017
-- Description:	RETORNA VALOR TOTAL DOS PRODUTOS NA VENDA
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_PRODUTOS_VENDA]
(
	@Id Int
)
RETURNS Numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Vr numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @vr = SUM(ISNULL(vi.TotalItem,0))  FROM VendaItens vi WHERE vi.VendaId = @Id 
	if @vr is null
	begin
	  set @vr = 0
	end

	-- Return the result of the function
	RETURN round(@vr,2)

END



GO
/****** Object:  UserDefinedFunction [dbo].[FUN_VALOR_TOTAL_ITEM]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR 
-- Create date: 13/04/2018
-- Description:	VALOR TOTAL DO ITEM
-- =============================================
CREATE FUNCTION [dbo].[FUN_VALOR_TOTAL_ITEM]
(
	@id int
)
RETURNS numeric(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @vr numeric(18,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @VR = (VI.Qtde * VI.ValorUnitario)  FROM VendaItens VI WHERE VI.ID = @ID

	-- Return the result of the function
	RETURN ROUND(@VR,2)

END
GO
/****** Object:  Table [dbo].[Anexo]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Anexo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NULL,
	[Anexo] [varbinary](max) NULL,
	[Tipo] [varchar](20) NULL,
 CONSTRAINT [PK_Anexo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Assistencia]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assistencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Numero] [int] NULL,
	[NumeroAno] [varchar](100) NULL,
	[Data] [datetime] NULL,
	[DataFinalizacao] [datetime] NULL,
	[Status] [varchar](200) NULL,
	[VendaId] [int] NULL,
	[PessoaId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[Obs] [ntext] NULL,
	[Usuario] [varchar](150) NULL,
	[DataInclusao] [datetime] NULL,
	[FormaEnvio] [varchar](250) NULL,
	[NumeroRastreio] [varchar](250) NULL,
	[NumeroSerie] [varchar](250) NULL,
 CONSTRAINT [PK_Assistencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssistenciaHistorico]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssistenciaHistorico](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AssistenciaId] [int] NULL,
	[Data] [datetime] NULL,
	[Relato] [ntext] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_AssistenciaHistorico] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AtualizacaoPrecos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AtualizacaoPrecos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[ProdutoId] [int] NULL,
	[EntradaId] [int] NULL,
	[Atualizado] [bit] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[ItemId] [int] NULL,
	[CustoAntigo] [numeric](18, 2) NULL,
	[CustoNovo] [numeric](18, 2) NULL,
	[PrecoAntigo] [numeric](18, 2) NULL,
	[PrecoNovo] [numeric](18, 2) NULL,
 CONSTRAINT [PK_AtualizacaoPrecos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Auditoria]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auditoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](50) NULL,
	[Relato] [ntext] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
	[IdTabela] [int] NULL,
 CONSTRAINT [PK_Auditoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Boleto]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Boleto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NomeCedente] [varchar](200) NULL,
	[EnderecoCedente] [varchar](100) NULL,
	[CnpjCedente] [varchar](18) NULL,
	[Agencia] [varchar](10) NULL,
	[DigAg] [varchar](3) NULL,
	[Conta] [varchar](25) NULL,
	[DigCt] [varchar](3) NULL,
	[Banco] [varchar](3) NULL,
	[Carteira] [varchar](15) NULL,
	[Convenio] [varchar](15) NULL,
	[Vencimento] [datetime] NULL,
	[Valor] [numeric](18, 2) NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Juros] [numeric](18, 2) NULL,
	[Multa] [numeric](18, 2) NULL,
	[Protesto] [int] NULL,
	[NossoNumero] [varchar](50) NULL,
	[Documento] [varchar](50) NULL,
	[LinhaDigitavel] [varchar](100) NULL,
	[CodigoBarras] [varchar](100) NULL,
	[DocSacado] [varchar](18) NULL,
	[NomeSacado] [varchar](200) NULL,
	[EnderecoSacado] [varchar](200) NULL,
	[BairroSacado] [varchar](100) NULL,
	[CepSacado] [varchar](10) NULL,
	[CidadeSacado] [varchar](100) NULL,
	[UfSacado] [char](2) NULL,
	[Obs] [ntext] NULL,
	[Remessa] [bit] NULL,
	[Lote] [int] NULL,
	[DataGeracao] [datetime] NULL,
 CONSTRAINT [PK_Boleto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CaixaAuditoria]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CaixaAuditoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataAlteracao] [datetime] NULL,
	[ValorInfomado] [numeric](18, 2) NULL,
	[Diferenca] [numeric](18, 2) NULL,
	[DataCaixa] [datetime] NULL,
	[UsuarioCaixa] [varchar](100) NULL,
 CONSTRAINT [PK_CaixaAuditoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CenarioFiscal]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CenarioFiscal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Descricao] [varchar](200) NULL,
	[Tipo] [varchar](50) NULL,
	[Devolucao] [bit] NULL,
	[CtbCodNatureza] [varchar](100) NULL,
	[CtbCodigoConta] [varchar](60) NULL,
	[CtbNomeConta] [varchar](60) NULL,
	[SemFinanceiro] [bit] NULL,
	[Ajuste] [bit] NULL,
	[SemCusto] [bit] NULL,
	[IdAntigo] [int] NULL,
 CONSTRAINT [PK_CenarioFiscal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CenarioFiscalItens]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CenarioFiscalItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CenarioId] [int] NULL,
	[Ncm] [varchar](15) NULL,
	[Ex] [varchar](3) NULL,
	[PessoaId] [int] NULL,
	[Imposto] [varchar](50) NULL,
	[Tipo] [varchar](15) NULL,
	[Uf] [char](2) NULL,
	[Cfop] [char](5) NULL,
	[Cst] [varchar](4) NULL,
	[Aliquota] [numeric](18, 2) NULL,
	[Reducao] [numeric](18, 2) NULL,
	[Acrescimo] [numeric](18, 2) NULL,
	[Difal] [numeric](18, 2) NULL,
	[FCP] [numeric](18, 2) NULL,
	[Interna] [bit] NULL,
	[GeraDifal] [bit] NULL,
 CONSTRAINT [PK_CenarioFiscalItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentroResultado]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CentroResultado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](100) NULL,
	[Tipo] [nvarchar](35) NULL,
	[Analitico] [char](1) NULL,
	[SuperiorId] [int] NULL,
	[EmpresaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[Classificador] [varchar](100) NULL,
	[Reduzido] [int] NULL,
	[IdAtual] [int] NULL,
	[IdSuperior] [int] NULL,
 CONSTRAINT [PK_CentroResultado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cfop]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cfop](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cfop] [char](5) NULL,
	[Descricao] [varchar](1000) NULL,
 CONSTRAINT [PK_Cfop] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cheque]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cheque](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContaId] [int] NULL,
	[NomeBanco] [nvarchar](50) NULL,
	[ContaCheque] [nvarchar](30) NULL,
	[AgenciaCheque] [nvarchar](15) NULL,
	[NrCheque] [nvarchar](15) NULL,
	[Tipo] [nvarchar](50) NULL,
	[Terceiro] [nvarchar](100) NULL,
	[PreData] [date] NULL,
	[ClienteId] [int] NULL,
	[Valor] [numeric](18, 2) NULL,
	[DataCadastro] [date] NULL,
	[Utilizado] [bit] NULL,
	[Depositado] [bit] NULL,
	[EmpresaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Cheque_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Config]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Config](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Parametro] [varchar](200) NULL,
	[Valor] [varchar](500) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[LogoEmpresa] [image] NULL,
	[FundoEmpresa] [image] NULL,
	[LogoRelEmpresa] [image] NULL,
 CONSTRAINT [PK_Config] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conta]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Agencia] [varchar](10) NULL,
	[DigAg] [varchar](3) NULL,
	[Conta] [varchar](25) NULL,
	[DigCt] [varchar](3) NULL,
	[Banco] [varchar](3) NULL,
	[Carteira] [varchar](15) NULL,
	[NomeBanco] [varchar](50) NULL,
	[Convenio] [varchar](15) NULL,
	[Juros] [numeric](18, 2) NULL,
	[Multa] [numeric](18, 2) NULL,
	[EmpresaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[NrRemessa] [int] NULL,
 CONSTRAINT [PK_Conta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContaML]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContaML](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Conta] [varchar](100) NULL,
	[Code] [varchar](100) NULL,
	[Token] [varchar](500) NULL,
	[Refresh] [varchar](500) NULL,
	[IdVendedor] [varchar](50) NULL,
 CONSTRAINT [PK_ContaML] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustoHistorico]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustoHistorico](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[ProdutoId] [int] NULL,
	[DataMovto] [datetime] NULL,
	[EntradaId] [int] NULL,
	[ItemId] [int] NULL,
	[Custo] [numeric](18, 2) NULL,
	[Origem] [varchar](150) NULL,
	[QtdeOrigem] [numeric](18, 6) NULL,
	[ValorOrigem] [numeric](18, 6) NULL,
	[Cancelado] [bit] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[CustoAnterior] [numeric](18, 2) NULL,
 CONSTRAINT [PK_CustoHistorico] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeparaEntrada]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeparaEntrada](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[CfopOrigem] [varchar](20) NULL,
	[CfopIntDest] [varchar](20) NULL,
	[CfopExtDest] [varchar](20) NULL,
	[CstIcmsOrigem] [varchar](20) NULL,
	[CstIcmsDest] [varchar](20) NULL,
	[CstFederalOrigem] [varchar](20) NULL,
	[CstFederalDest] [varchar](20) NULL,
	[CstIpiOrigem] [varchar](20) NULL,
	[CstIpiDest] [varchar](20) NULL,
 CONSTRAINT [PK_DeparaEntrada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Escrituracao]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Escrituracao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[PessoaId] [int] NULL,
	[TipoId] [int] NULL,
	[Chave] [varchar](100) NULL,
	[Documento] [varchar](50) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[Valor] [numeric](18, 2) NULL,
	[Data] [datetime] NULL,
	[ProdutoNome] [varchar](200) NULL,
 CONSTRAINT [PK_Escrituracao] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EscrituracaoTipos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EscrituracaoTipos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [varchar](50) NULL,
	[Descricao] [varchar](100) NULL,
	[ExigeChave] [bit] NULL,
	[Cfop] [varchar](4) NULL,
	[ExigeProduto] [bit] NULL,
 CONSTRAINT [PK_EscrituracaoTipos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estoque]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estoque](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Tipo] [char](1) NULL,
	[DataMovto] [datetime] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[Custo] [numeric](18, 4) NULL,
	[VendaId] [int] NULL,
	[InventarioId] [int] NULL,
	[Origem] [varchar](150) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[ItemId] [int] NULL,
	[PrecoVenda] [numeric](18, 6) NULL,
	[EntradaCustoId] [int] NULL,
	[TrocaId] [int] NULL,
	[TrocaItemId] [int] NULL,
 CONSTRAINT [PK_Estoque] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Filiais]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Filiais](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CnpjLoja] [varchar](50) NULL,
	[NomeLoja] [varchar](200) NULL,
 CONSTRAINT [PK_Filiais] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormaPagamento]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormaPagamento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Descricao] [varchar](200) NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Juros] [numeric](18, 2) NULL,
	[Usuario] [varchar](200) NULL,
	[DataInclusao] [datetime] NULL,
	[Boleto] [bit] NULL,
	[CodigoSat] [int] NULL,
	[CartaoSat] [varchar](10) NULL,
	[ExibeCaixa] [bit] NULL,
	[ContaId] [int] NULL,
	[Concilia] [bit] NULL,
 CONSTRAINT [PK_FormaPagamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormaPagamentoPrazos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormaPagamentoPrazos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormaId] [int] NULL,
	[Prazo] [int] NULL,
	[Liquidar] [bit] NULL,
	[Parcela] [int] NULL,
	[Conciliar] [bit] NULL,
 CONSTRAINT [PK_FormaPagamentoPrazos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormasEntrada]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormasEntrada](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NULL,
	[Liquidar] [bit] NULL,
	[Cheque] [bit] NULL,
	[Usuario] [varchar](50) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
	[ContaId] [int] NULL,
 CONSTRAINT [PK_FormasEntrada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Foto]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Foto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DescBase64] [ntext] NULL,
	[TabelaNome] [varchar](100) NULL,
	[TabelaId] [int] NULL,
 CONSTRAINT [PK_Foto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IBGE]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IBGE](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Municipio] [varchar](150) NULL,
	[CodigoIBGE] [nvarchar](50) NULL,
	[UF] [varchar](2) NULL,
 CONSTRAINT [PK_IBGE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventario]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Data] [datetime] NULL,
	[UsuarioId] [int] NULL,
	[Status] [varchar](100) NULL,
	[Obs] [ntext] NULL,
 CONSTRAINT [PK_Inventario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventarioItens]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventarioItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InventarioId] [int] NULL,
	[ProdutoId] [int] NULL,
	[SaldoAtual] [decimal](18, 4) NULL,
	[Saldo] [decimal](18, 4) NULL,
	[Impresso] [bit] NULL,
 CONSTRAINT [PK_InventarioItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LancamentoBancario]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LancamentoBancario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContaId] [int] NULL,
	[Valor] [numeric](18, 2) NULL,
	[TituloId] [int] NULL,
	[Conciliado] [bit] NULL,
	[DataLancto] [date] NULL,
	[Juros] [numeric](18, 2) NULL,
	[Multa] [numeric](18, 2) NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Tipo] [char](1) NULL,
	[Obs] [ntext] NULL,
	[ChequeId] [int] NULL,
	[NrDoc] [nvarchar](50) NULL,
	[Usuario] [varchar](50) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
	[TipoPagamento] [varchar](50) NULL,
	[ExibeCaixa] [bit] NULL,
	[DataConciliacao] [datetime] NULL,
	[TrocaId] [int] NULL,
	[Avulso] [bit] NULL,
	[ValorLiquido]  AS ([dbo].[FUN_VALOR_LIQ_LANCTO]([id])),
 CONSTRAINT [PK_LancamentoBancario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogModulos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogModulos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechamentoId] [int] NULL,
	[VendaId] [int] NULL,
	[TituloId] [int] NULL,
	[Obs] [varchar](250) NULL,
	[DataCorrecao] [datetime] NULL,
 CONSTRAINT [PK_LogModulos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NcmItens]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NcmItens](
	[Id] [int] NOT NULL,
	[Uf] [char](2) NULL,
	[AliqNacional] [numeric](18, 2) NULL,
	[AliqImportada] [numeric](18, 2) NULL,
	[AliqEstadual] [numeric](18, 2) NULL,
	[AliqMunicipal] [numeric](18, 2) NULL,
	[Chave] [varchar](30) NULL,
	[Ncm] [varchar](20) NULL,
 CONSTRAINT [PK_NcmItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdensML]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdensML](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackId] [bigint] NULL,
	[OrdemId] [bigint] NULL,
	[VendaId] [int] NULL,
 CONSTRAINT [PK_OrdensML] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pais]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pais](
	[Id] [int] NOT NULL,
	[Ibge] [char](4) NULL,
	[Nome] [varchar](50) NULL,
 CONSTRAINT [PK_Pais] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pessoa]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pessoa](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](200) NULL,
	[CnpjCpf] [nvarchar](18) NULL,
	[Tipo] [nvarchar](15) NULL,
	[Cep] [nvarchar](9) NULL,
	[Cidade] [nvarchar](100) NULL,
	[Estado] [char](2) NULL,
	[Endereco] [nvarchar](100) NULL,
	[Numero] [char](5) NULL,
	[Complemento] [nvarchar](50) NULL,
	[Bairro] [nvarchar](100) NULL,
	[Ibge] [nvarchar](10) NULL,
	[TipoPessoa] [nvarchar](10) NULL,
	[Data] [date] NULL,
	[Fantasia] [nvarchar](100) NULL,
	[EmpresaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[Consumidor] [int] NULL,
	[Fone] [varchar](100) NULL,
	[InscricaoEstadual] [varchar](30) NULL,
	[Crt] [int] NULL,
	[TipoContribuinte] [int] NULL,
	[PaisId] [int] NULL,
	[TipoCertificado] [int] NULL,
	[NomeCertificado] [varchar](200) NULL,
	[SenhaCertificado] [varchar](100) NULL,
	[TipoPreco] [varchar](50) NULL,
	[FormaPagId] [int] NULL,
	[Seguimento] [varchar](100) NULL,
	[VrLimCredito] [numeric](18, 2) NULL,
	[Cod_Ant] [int] NULL,
	[CnpjCpfAnt] [nvarchar](18) NULL,
	[IdOld] [int] NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Categoria] [varchar](15) NULL,
	[EnviaSku] [bit] NULL,
 CONSTRAINT [PK_Pessoa] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PessoaContatos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PessoaContatos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PessoaId] [int] NULL,
	[Tipo] [nvarchar](50) NULL,
	[Valor] [nvarchar](200) NULL,
	[Obs] [nvarchar](2000) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[IdOld] [int] NULL,
 CONSTRAINT [PK_PessoaContatos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Produto]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Produto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [char](8) NULL,
	[Codigo] [int] NULL,
	[Descricao] [varchar](120) NULL,
	[Um] [varchar](6) NULL,
	[Grupo] [varchar](50) NULL,
	[Ncm] [varchar](15) NULL,
	[Ex] [varchar](3) NULL,
	[Custo] [numeric](18, 2) NULL,
	[Margem] [numeric](18, 2) NULL,
	[Preco] [numeric](18, 2) NULL,
	[Estoque] [bit] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
	[Varejo] [numeric](18, 2) NULL,
	[Atacado] [numeric](18, 2) NULL,
	[QtdeAtacado] [int] NULL,
	[PesoRef] [numeric](18, 3) NULL,
	[EntradaCustoId] [int] NULL,
	[InsumoLoja] [bit] NULL,
	[Armazenamento] [varchar](100) NULL,
	[EstoqueMin] [numeric](18, 4) NULL,
	[Cest] [int] NULL,
	[Inativo] [bit] NULL,
	[CodInterno] [varchar](50) NULL,
	[EstoqueAtual] [numeric](18, 4) NULL,
	[Marca] [varchar](100) NULL,
	[Ean] [varchar](100) NULL,
	[Modelo] [varchar](100) NULL,
	[SkuExterno] [varchar](50) NULL,
 CONSTRAINT [PK_Produto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Produto] UNIQUE NONCLUSTERED 
(
	[EmpresaId] ASC,
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProdutoComposicao]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdutoComposicao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrigemId] [int] NULL,
	[ItemId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[CustoTotal]  AS ([dbo].[FUN_CUSTO_TOTAL_COMPOSICAO_ITEM]([ItemId],[OrigemId])),
 CONSTRAINT [PK_ProdutoComposicao] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProdutoEan]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdutoEan](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdutoId] [int] NULL,
	[Ean] [varchar](100) NULL,
	[Padrao] [bit] NULL,
	[Qtde] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ProdutoEan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProdutoEanBkp]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdutoEanBkp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdutoId] [int] NULL,
	[Ean] [varchar](100) NULL,
	[Padrao] [bit] NULL,
	[Qtde] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ProdutoEanBkp] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProdutoFornecedores]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdutoFornecedores](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NOT NULL,
	[ProdutoId] [int] NOT NULL,
	[FornecedorId] [int] NOT NULL,
	[CodigoFornecedor] [varchar](100) NOT NULL,
	[Preco] [numeric](18, 4) NULL,
	[Sinal] [varchar](20) NULL,
	[Fator] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ProdutoFornecedores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProdutoUnidades]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProdutoUnidades](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdutoId] [int] NULL,
	[Um] [varchar](6) NULL,
	[SinalEntrada] [varchar](20) NULL,
	[SinalSaida] [varchar](20) NULL,
	[FatorConversao] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ProdutoUnidades] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_ProdutoUnidades] UNIQUE NONCLUSTERED 
(
	[ProdutoId] ASC,
	[Um] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Romaneio]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Romaneio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [int] NULL,
	[Tipo] [varchar](100) NULL,
	[Status] [varchar](50) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[Data] [datetime] NULL,
	[Obs] [ntext] NULL,
	[EmpresaId] [int] NULL,
	[Pedidos]  AS ([dbo].[FUN_TOTAL_PEDIDOS_ROMANEIO]([id])),
 CONSTRAINT [PK_Romaneio] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0000]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0000](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [varchar](4) NULL,
	[Cod_Ver_02] [varchar](3) NULL,
	[Cod_Fin_03] [char](1) NULL,
	[Dt_Ini_04] [varchar](8) NULL,
	[Dt_Fin_05] [varchar](8) NULL,
	[Nome_06] [varchar](100) NULL,
	[Cnpj_07] [varchar](14) NULL,
	[Cpf_08] [varchar](11) NULL,
	[Uf_09] [char](2) NULL,
	[Ie_10] [varchar](14) NULL,
	[Cod_Mun_11] [varchar](7) NULL,
	[Im_12] [varchar](14) NULL,
	[Suframa_13] [varchar](9) NULL,
	[Ind_Perfil_14] [char](1) NULL,
	[Ind_Ativ_15] [char](1) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0000] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0005]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0005](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](5) NULL,
	[Fantasia_02] [varchar](60) NULL,
	[Cep_03] [varchar](8) NULL,
	[End_04] [varchar](60) NULL,
	[Num_05] [varchar](10) NULL,
	[Compl_06] [varchar](60) NULL,
	[Bairro_07] [varchar](60) NULL,
	[Fone_08] [varchar](11) NULL,
	[Fax_09] [varchar](11) NULL,
	[Email_10] [varchar](100) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0005] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0150]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0150](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Part_02] [varchar](60) NULL,
	[Nome_03] [varchar](100) NULL,
	[Cod_Pais_04] [varchar](5) NULL,
	[Cnpj_05] [varchar](14) NULL,
	[Cpf_06] [varchar](11) NULL,
	[Ie_07] [varchar](14) NULL,
	[Cod_Mun_08] [varchar](7) NULL,
	[Suframa_09] [varchar](9) NULL,
	[End_10] [varchar](60) NULL,
	[Num_11] [varchar](10) NULL,
	[Compl_12] [varchar](60) NULL,
	[Bairro_13] [varchar](60) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0150] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0190]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0190](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Unid_02] [varchar](6) NULL,
	[Descr_03] [varchar](50) NULL,
	[Usuario] [varchar](200) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0190] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0200]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0200](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Item_02] [varchar](60) NULL,
	[Descr_Item_03] [varchar](200) NULL,
	[Cod_Barra_04] [varchar](50) NULL,
	[Cod_Ant_Item_05] [varchar](60) NULL,
	[Unid_Inv_06] [varchar](6) NULL,
	[Tipo_Item_07] [char](2) NULL,
	[Cod_Ncm_08] [varchar](8) NULL,
	[Ex_IPI_09] [varchar](3) NULL,
	[Cod_Gen_10] [varchar](2) NULL,
	[Cod_Lst_11] [varchar](4) NULL,
	[Aliq_Icms_12] [numeric](18, 2) NULL,
	[Cod_Grupo_13] [varchar](4) NULL,
	[Desc_Grupo_14] [varchar](40) NULL,
	[Cod_Sefaz_15] [varchar](4) NULL,
	[Csosn_16] [varchar](3) NULL,
	[Cst_Icms_17] [varchar](3) NULL,
	[Per_Red_Bc_Icms_18] [numeric](18, 2) NULL,
	[Bc_Icms_ST_19] [numeric](18, 2) NULL,
	[Cst_Ipi_Entrada_20] [varchar](2) NULL,
	[Cst_Ipi_Saida_21] [varchar](2) NULL,
	[Aliq_Ipi_22] [numeric](18, 2) NULL,
	[Cst_Pis_Entrada_23] [varchar](2) NULL,
	[Cst_Pis_Saida_24] [varchar](2) NULL,
	[Nat_Rec_Pis_25] [varchar](3) NULL,
	[Aliq_Pis_26] [numeric](18, 2) NULL,
	[Cst_Cofins_Entrada_27] [varchar](2) NULL,
	[Cst_Cofins_Saida_28] [varchar](2) NULL,
	[Nat_Rec_Cofins_29] [varchar](3) NULL,
	[Aliq_Cofins_30] [numeric](18, 2) NULL,
	[Aliq_Iss_31] [varchar](4) NULL,
	[CC_32] [varchar](25) NULL,
	[Observacao_33] [varchar](60) NULL,
	[Cod_Cest_34] [varchar](7) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0200] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sped0500]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sped0500](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Dt_Alt_02] [varchar](8) NULL,
	[Cod_Nat_Cc_03] [char](1) NULL,
	[Ind_Cta_04] [char](1) NULL,
	[Nivel_05] [varchar](5) NULL,
	[Cod_Cta_06] [varchar](60) NULL,
	[Nome_Cta_07] [varchar](60) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_Sped0500] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC100]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC100](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Ind_Oper_02] [char](1) NULL,
	[Ind_Emit_03] [char](1) NULL,
	[Cod_Par_04] [int] NULL,
	[Cod_Mod_05] [char](2) NULL,
	[Cod_Sit_06] [char](2) NULL,
	[Ser_07] [varchar](3) NULL,
	[Num_Doc_08] [varchar](30) NULL,
	[Chv_NFe_09] [varchar](44) NULL,
	[Dt_Doc_10] [varchar](10) NULL,
	[Dt_E_S_11] [varchar](10) NULL,
	[Vl_Doc_12] [numeric](18, 2) NULL,
	[Ind_Pgt_13] [char](1) NULL,
	[Vl_Desc_14] [numeric](18, 2) NULL,
	[Vl_Abat_Nt_15] [numeric](18, 2) NULL,
	[Vl_Merc_16] [numeric](18, 2) NULL,
	[Ind_Frt_17] [char](1) NULL,
	[Vl_Frt_18] [numeric](18, 2) NULL,
	[Vl_Seg_19] [numeric](18, 2) NULL,
	[Vl_Out_Da_20] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_21] [numeric](18, 2) NULL,
	[Vl_Icms_22] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_St_23] [numeric](18, 2) NULL,
	[Vl_IcmsSt_24] [numeric](18, 2) NULL,
	[Vl_Ipi_25] [numeric](18, 2) NULL,
	[Vl_Pis_26] [numeric](18, 2) NULL,
	[Vl_Cofins_27] [numeric](18, 2) NULL,
	[Vl_Pis_St_28] [numeric](18, 2) NULL,
	[Vl_Cofins_st_29] [numeric](18, 2) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC100] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC170]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC170](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](5) NULL,
	[Num_Item_02] [int] NULL,
	[Cod_Item_03] [varchar](10) NULL,
	[Descr_Compl_04] [varchar](100) NULL,
	[Qtde_05] [numeric](18, 5) NULL,
	[Unid_06] [varchar](6) NULL,
	[Vl_Item_07] [numeric](18, 2) NULL,
	[Vl_Desc_08] [numeric](18, 2) NULL,
	[Ind_Mov_09] [int] NULL,
	[Cst_Icms_10] [varchar](3) NULL,
	[Cfop_11] [varchar](4) NULL,
	[Cod_Nat_12] [varchar](10) NULL,
	[Vl_Bc_Icms_13] [numeric](18, 2) NULL,
	[Aliq_Icms_14] [numeric](18, 2) NULL,
	[Vl_Icms_15] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_ST_16] [numeric](18, 2) NULL,
	[Aliq_St_17] [numeric](18, 2) NULL,
	[Vl_Icms_St_18] [numeric](18, 2) NULL,
	[Ind_Apur_19] [int] NULL,
	[Cst_Ipi_20] [varchar](2) NULL,
	[Cod_Enq_21] [varchar](3) NULL,
	[Vl_Bc_Ipi_22] [numeric](18, 2) NULL,
	[Aliq_Ipi_23] [numeric](18, 2) NULL,
	[Vl_Ipi_24] [numeric](18, 2) NULL,
	[Cst_Pis_25] [char](2) NULL,
	[Vl_Bc_Pis_26] [numeric](18, 2) NULL,
	[Aliq_Pis_27] [numeric](18, 2) NULL,
	[Quant_Bc_Pis_28] [numeric](18, 3) NULL,
	[Aliq_Pis_Qtde_29] [numeric](18, 4) NULL,
	[Vl_Pis_30] [numeric](18, 2) NULL,
	[Cst_Cofins_31] [char](2) NULL,
	[Vl_Bc_Cofins_32] [numeric](18, 2) NULL,
	[Aliq_Cofins_33] [numeric](18, 2) NULL,
	[Quant_Bc_Cofins_34] [numeric](18, 3) NULL,
	[Aliq_Cofins_Qtde_35] [numeric](18, 4) NULL,
	[Vl_Cofins_36] [numeric](18, 2) NULL,
	[Cod_Cta_37] [varchar](60) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[C100Id] [int] NULL,
 CONSTRAINT [PK_SpedC170] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC190]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC190](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cst_Icms_02] [varchar](3) NULL,
	[Cfop_03] [char](4) NULL,
	[Aliq_Icms_04] [numeric](18, 2) NULL,
	[Vl_Op_05] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_06] [numeric](18, 2) NULL,
	[Vl_Icms_07] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_St_08] [numeric](18, 2) NULL,
	[Vl_Icms_St_09] [numeric](18, 2) NULL,
	[Vl_Red_Bc_10] [numeric](18, 2) NULL,
	[Vl_Ipi_11] [numeric](18, 2) NULL,
	[Cod_Obs_12] [varchar](6) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[C100Id] [int] NULL,
 CONSTRAINT [PK_SpedC190] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC400]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC400](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Mod_02] [char](2) NULL,
	[Ecf_Mod_03] [varchar](20) NULL,
	[Ecf_Fab_04] [varchar](20) NULL,
	[Ecf_Cx_05] [varchar](3) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC400] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC405]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC405](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Dt_Doc_02] [varchar](8) NULL,
	[Cro_03] [varchar](3) NULL,
	[Crz_04] [varchar](6) NULL,
	[Num_Coo_Fin_05] [varchar](6) NULL,
	[Gt_fin_06] [varchar](5) NULL,
	[Vl_Brt_07] [varchar](50) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC405] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC460]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC460](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[C405Id] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Mod_02] [char](2) NULL,
	[Cod_Sit_03] [char](2) NULL,
	[Num_Doc_04] [varchar](6) NULL,
	[Dt_Doc_05] [varchar](8) NULL,
	[Vl_Doc_06] [numeric](18, 2) NULL,
	[Vl_Pis_07] [numeric](18, 2) NULL,
	[Vl_Cofins_08] [numeric](18, 2) NULL,
	[Cpf_Cnpj_09] [varchar](14) NULL,
	[Nom_Adq_10] [varchar](60) NULL,
	[Nr_Sat_11] [varchar](9) NULL,
	[Chv_Cfe_12] [varchar](44) NULL,
	[Cfe_Canc_13] [varchar](6) NULL,
	[Ind_Pgto_14] [char](1) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC460] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC470]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC470](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[C405Id] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Item_02] [varchar](60) NULL,
	[Qtd_03] [numeric](18, 3) NULL,
	[Qtd_Canc_04] [numeric](18, 3) NULL,
	[Unid_05] [varchar](6) NULL,
	[Vl_Item_06] [numeric](18, 2) NULL,
	[Cst_Icms_07] [varchar](3) NULL,
	[Cfop_08] [char](4) NULL,
	[Aliq_Icms_09] [numeric](18, 2) NULL,
	[Vl_Pis_10] [numeric](18, 2) NULL,
	[Vl_Cofins_11] [numeric](18, 2) NULL,
	[Cst_Pis_12] [char](2) NULL,
	[Nat_Rec_Pis_13] [varchar](3) NULL,
	[Vl_Bc_Pis_14] [numeric](18, 2) NULL,
	[Aliq_Pis_15] [numeric](18, 4) NULL,
	[Quant_Bc_Pis_16] [numeric](18, 2) NULL,
	[Aliq_Pis_Quant_17] [numeric](18, 2) NULL,
	[Cst_Cofins_18] [char](2) NULL,
	[Nat_Rec_Cofins_19] [varchar](3) NULL,
	[Vl_Bc_Cofins_20] [numeric](18, 2) NULL,
	[Aliq_Cofins_21] [numeric](18, 4) NULL,
	[Quant_Bc_Cofins_22] [numeric](18, 2) NULL,
	[Aliq_Cofins_Quant_23] [numeric](18, 2) NULL,
	[Cod_Cta_24] [varchar](60) NULL,
	[Ind_Mov_25] [int] NULL,
	[Tot_Ecf_26] [varchar](4) NULL,
	[Vl_Desc_27] [numeric](18, 2) NULL,
	[Vl_Out_Da_28] [numeric](18, 2) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC470] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC500]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC500](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](5) NULL,
	[Ind_Oper_02] [int] NULL,
	[Ind_Emit_03] [int] NULL,
	[Cod_Part_04] [varchar](60) NULL,
	[Cod_Mod_05] [char](2) NULL,
	[Cod_Sit_06] [char](2) NULL,
	[Ser_07] [varchar](4) NULL,
	[Sub_08] [varchar](3) NULL,
	[Cod_Cons_09] [char](2) NULL,
	[Num_Doc_10] [varchar](9) NULL,
	[Dt_Doc_11] [varchar](8) NULL,
	[Dt_E_S_12] [varchar](8) NULL,
	[Vl_Doc_13] [numeric](18, 2) NULL,
	[Vl_Desc_14] [numeric](18, 2) NULL,
	[Vl_Forn_15] [numeric](18, 2) NULL,
	[Vl_Serv_Nt_16] [numeric](18, 2) NULL,
	[Vl_Terc_17] [numeric](18, 2) NULL,
	[Vl_Da_18] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_19] [numeric](18, 2) NULL,
	[Vl_Icms_20] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_St_21] [numeric](18, 2) NULL,
	[Vl_Icms_St_22] [numeric](18, 2) NULL,
	[Cod_Inf_23] [varchar](6) NULL,
	[Vl_Pis_24] [numeric](18, 2) NULL,
	[Vl_Cofins_25] [numeric](18, 2) NULL,
	[Tp_Ligacao_26] [int] NULL,
	[Cod_Grupo_Tensao_27] [char](2) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedC500] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedC590]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedC590](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](5) NULL,
	[Cst_Icms_02] [varchar](3) NULL,
	[Cfop_03] [varchar](4) NULL,
	[Aliq_Icms_04] [numeric](18, 2) NULL,
	[Vl_Oper_05] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_06] [numeric](18, 2) NULL,
	[Vl_Icms_07] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_St_08] [numeric](18, 2) NULL,
	[Vl_Icms_St_09] [numeric](18, 2) NULL,
	[Vl_Red_Bc_10] [numeric](18, 2) NULL,
	[Cod_Obs_11] [varchar](6) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[C500Id] [int] NULL,
 CONSTRAINT [PK_SpedC590] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedD100]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedD100](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Ind_Oper_02] [int] NULL,
	[Ind_Emit_03] [int] NULL,
	[Cod_Part_04] [varchar](60) NULL,
	[Cod_Mod_05] [char](2) NULL,
	[Cod_Sit_06] [char](2) NULL,
	[Ser_07] [varchar](4) NULL,
	[Sub_08] [varchar](3) NULL,
	[Num_Doc_09] [varchar](30) NULL,
	[Chv_Cte_10] [varchar](44) NULL,
	[Dt_Doc_11] [varchar](8) NULL,
	[Dt_A_P_12] [varchar](8) NULL,
	[Tp_Cte_13] [varchar](5) NULL,
	[Chv_Cte_Ref_14] [varchar](44) NULL,
	[Vl_Doc_15] [numeric](18, 2) NULL,
	[Vl_Desc_16] [numeric](18, 2) NULL,
	[Ind_Frt_17] [int] NULL,
	[Vl_Serv_18] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_19] [numeric](18, 2) NULL,
	[Vl_Icms_20] [numeric](18, 2) NULL,
	[Vl_Nt_21] [numeric](18, 2) NULL,
	[Cod_Inf_22] [varchar](6) NULL,
	[Cod_Cta_23] [varchar](50) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedD100] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedD190]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedD190](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cst_Icms_02] [char](3) NULL,
	[Cfop_03] [varchar](4) NULL,
	[Aliq_Icms_04] [numeric](18, 2) NULL,
	[Vl_Opr_05] [numeric](18, 2) NULL,
	[Vl_Bc_Icms_06] [numeric](18, 2) NULL,
	[Vl_Icms_07] [numeric](18, 2) NULL,
	[Vl_Red_Bc_08] [numeric](18, 2) NULL,
	[Cod_Obs_09] [varchar](6) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[D100Id] [int] NULL,
 CONSTRAINT [PK_SpedD190] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpedH010]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpedH010](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Reg_01] [char](4) NULL,
	[Cod_Item_02] [varchar](60) NULL,
	[Unid_03] [varchar](6) NULL,
	[Qtde_04] [numeric](18, 3) NULL,
	[Vl_Unit_05] [numeric](18, 6) NULL,
	[Vl_Item_06] [numeric](18, 7) NULL,
	[Ind_Prop_07] [int] NULL,
	[Cod_Part_08] [varchar](60) NULL,
	[Txt_Compl_09] [varchar](100) NULL,
	[Cod_Cta_10] [varchar](60) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
 CONSTRAINT [PK_SpedH010] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TabelaDifal]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TabelaDifal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UfOrigem] [char](2) NULL,
	[UfDestino] [char](2) NULL,
	[AliqInterna] [numeric](18, 2) NULL,
	[AliqInterUF] [numeric](18, 2) NULL,
 CONSTRAINT [PK_TabelaDifal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Titulo]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Titulo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](15) NULL,
	[Abertura] [date] NULL,
	[Vencimento] [date] NULL,
	[PessoaId] [int] NULL,
	[Valor] [numeric](18, 2) NULL,
	[CentroResultadoId] [int] NULL,
	[Obs] [ntext] NULL,
	[Tipo] [nvarchar](15) NULL,
	[ValorBaixado]  AS ([dbo].[FUN_VALOR_BAIXADO]([id])),
	[EmpresaId] [int] NULL,
	[VendaId] [int] NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Juros] [numeric](18, 2) NULL,
	[Multa] [numeric](18, 2) NULL,
	[Descricao] [varchar](100) NULL,
	[Prazo]  AS ([dbo].[FUN_PRAZO_TITULO]([id])),
	[Alterado] [bit] NULL,
	[Usuario] [varchar](200) NULL,
	[DataInclusao] [datetime] NULL,
	[Numero] [varchar](50) NULL,
	[Liquidar] [bit] NULL,
	[ValorLiquido]  AS ([dbo].[FUN_VALOR_LIQUIDO_TITULO]([id])),
	[FormaId] [int] NULL,
	[BoletoId] [int] NULL,
	[Documento] [varchar](50) NULL,
	[FormaPagDesc] [varchar](100) NULL,
	[NrCheque] [varchar](50) NULL,
	[Parcela] [int] NULL,
	[SemBoleto] [bit] NULL,
	[Chave] [varchar](100) NULL,
	[Transportadora] [bit] NULL,
	[CodAnt] [int] NULL,
	[VrBaixado] [numeric](18, 2) NULL,
	[TrocaId] [int] NULL,
	[Haver] [char](1) NULL,
 CONSTRAINT [PK_Titulo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TituloAnexo]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TituloAnexo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TituloId] [int] NOT NULL,
	[AnexoId] [int] NOT NULL,
 CONSTRAINT [PK_TituloAnexo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpClienteFornecedor]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpClienteFornecedor](
	[CODTRANSPORTADORA] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelCompras]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelCompras](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [int] NULL,
	[Descricao] [varchar](200) NULL,
	[DataCompra] [datetime] NULL,
	[CustoCompra] [numeric](18, 2) NULL,
	[CustoMedio] [numeric](18, 2) NULL,
	[QtdeComprada] [numeric](18, 2) NULL,
	[QtdeVendida] [numeric](18, 2) NULL,
	[Estoque] [numeric](18, 2) NULL,
	[Logo] [image] NULL,
	[Media] [numeric](18, 2) NULL,
 CONSTRAINT [PK_TmpRelCompras] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelEtiqueta]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelEtiqueta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Produto] [varchar](200) NULL,
	[Codigo] [int] NULL,
	[Qtde] [int] NULL,
	[ImpValor] [bit] NULL,
	[Preco] [numeric](18, 2) NULL,
	[Impresso] [bit] NULL,
	[Codigo2] [int] NULL,
	[Produto2] [varchar](200) NULL,
	[ImpValor2] [bit] NULL,
	[Preco2] [numeric](18, 2) NULL,
 CONSTRAINT [PK_TmpRelEtiqueta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelFinanceiro]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelFinanceiro](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](100) NULL,
	[Tipo] [varchar](50) NULL,
	[Situacao] [varchar](50) NULL,
	[Pessoa] [varchar](150) NULL,
	[CentroResultado] [varchar](100) NULL,
	[Abertura] [datetime] NULL,
	[Vencimento] [datetime] NULL,
	[Valor] [numeric](18, 2) NULL,
	[Juros] [numeric](18, 2) NULL,
	[Multa] [numeric](18, 2) NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Logotipo] [image] NULL,
	[FantasiaEmp] [varchar](100) NULL,
 CONSTRAINT [PK_TmpRelFinanceiro] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelMapaPedido]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelMapaPedido](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocalArmazenamento] [varchar](100) NULL,
	[NrPedido] [int] NULL,
	[NrRomaneio] [int] NULL,
	[SaidaRomaneio] [datetime] NULL,
	[DescricaoProduto] [varchar](100) NULL,
 CONSTRAINT [PK_TmpRelMapaPedido] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelProduto]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelProduto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NULL,
	[Um] [varchar](50) NULL,
	[Preco] [numeric](18, 2) NULL,
	[PrecoAtacado] [numeric](18, 2) NULL,
	[QtdeAtacado] [int] NULL,
	[EmpresaNome] [varchar](100) NULL,
	[EmpresaEnd] [varchar](150) NULL,
	[Grupo] [varchar](100) NULL,
	[Codigo] [int] NULL,
	[Modelo] [varchar](100) NULL,
 CONSTRAINT [PK_TmpRelProduto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelPromissoria]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelPromissoria](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NomeEmpresa] [varchar](200) NULL,
	[ValorExtenso] [varchar](200) NULL,
	[DataAtual] [varchar](50) NULL,
	[CidadeEmitente] [varchar](200) NULL,
	[Emitente] [varchar](200) NULL,
	[EnderecoEmitente] [varchar](300) NULL,
	[CepEmpresa] [varchar](50) NULL,
	[CpfEmitente] [varchar](50) NULL,
	[Rua] [varchar](200) NULL,
	[VencimentoExtenso] [varchar](50) NULL,
	[Valor] [numeric](18, 2) NULL,
	[CnpjEmpresa] [varchar](50) NULL,
	[UfEmitente] [char](2) NULL,
 CONSTRAINT [PK_TmpRelPromissoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelReciboPagto]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelReciboPagto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NomePessoa] [varchar](200) NULL,
	[CnpjCpfPessoa] [varchar](50) NULL,
	[ValorTitulo] [numeric](18, 2) NULL,
	[ValorBaixadoTitulo] [numeric](18, 2) NULL,
	[DescricaoTitulo] [varchar](200) NULL,
	[EmissaoTitulo] [datetime] NULL,
	[VenctoTitulo] [datetime] NULL,
	[DataLancto] [datetime] NULL,
	[CidadeEmpresa] [varchar](200) NULL,
	[NomeEmpresa] [varchar](200) NULL,
	[LogotipoEmpresa] [image] NULL,
	[ValorTotal] [numeric](18, 2) NULL,
	[ValorTotalExtenso] [varchar](250) NULL,
	[Venda] [int] NULL,
 CONSTRAINT [PK_TmpRelReciboPagto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelTitulo]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelTitulo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fornecedor] [varchar](100) NULL,
	[CR] [varchar](100) NULL,
	[Vencimento] [datetime] NULL,
	[Valor] [numeric](18, 2) NULL,
	[Documento] [varchar](100) NULL,
	[FormaPag] [varchar](50) NULL,
	[Obs] [ntext] NULL,
	[Emissao] [datetime] NULL,
	[NumParc] [int] NULL,
	[ValorTotal] [numeric](18, 2) NULL,
	[NrCheque] [nvarchar](15) NULL,
 CONSTRAINT [PK_TmpRelTitulo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpRelVendaProdutos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpRelVendaProdutos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [int] NULL,
	[Produto] [varchar](200) NULL,
	[Qtde] [numeric](18, 2) NULL,
	[Valor] [numeric](18, 2) NULL,
	[Logo] [image] NULL,
	[Marca] [varchar](100) NULL,
	[Chave] [varchar](50) NULL,
 CONSTRAINT [PK_TmpRelVendaProdutos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TmpTributacao]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TmpTributacao](
	[codigo] [int] NULL,
	[nome] [varchar](300) NULL,
	[um] [varchar](50) NULL,
	[ncm] [varchar](50) NULL,
	[icms] [numeric](18, 2) NULL,
	[Cst] [varchar](50) NULL,
	[AliPis] [numeric](18, 2) NULL,
	[CspPis] [varchar](50) NULL,
	[AliCofins] [numeric](18, 2) NULL,
	[cfog] [varchar](50) NULL,
	[IcmsEnt] [numeric](18, 2) NULL,
	[CstEnt] [varchar](50) NULL,
	[CstIpiEnt] [varchar](50) NULL,
	[AliqPisEnt] [numeric](18, 2) NULL,
	[CstPisEnt] [varchar](50) NULL,
	[AliqCofEnt] [numeric](18, 2) NULL,
	[CfopIntEnt] [varchar](50) NULL,
	[CfopForaEnt] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Troca]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Troca](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Status] [varchar](50) NULL,
	[DataTroca] [datetime] NULL,
	[PessoaId] [int] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[FormaId] [int] NULL,
	[SaldoTroca] [numeric](18, 2) NULL,
	[TotaHaver] [numeric](18, 2) NULL,
	[Obs] [ntext] NULL,
	[Desconto] [numeric](18, 2) NULL,
	[Separada] [bit] NULL,
 CONSTRAINT [PK_Troca] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrocaItensDev]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrocaItensDev](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TrocaId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[ValorUnitario] [numeric](18, 4) NULL,
	[DataInclusao] [datetime] NULL,
	[Usuario] [varchar](100) NULL,
	[Um] [varchar](6) NULL,
	[TotalItem] [numeric](18, 4) NULL,
	[NumeroSerie] [varchar](250) NULL,
 CONSTRAINT [PK_TrocaItensDev] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrocaItensLevados]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrocaItensLevados](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TrocaId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[ValorUnitario] [numeric](18, 4) NULL,
	[DataInclusao] [datetime] NULL,
	[Usuario] [varchar](100) NULL,
	[Um] [varchar](6) NULL,
	[TotalItem] [numeric](18, 4) NULL,
	[NumeroSerie] [varchar](250) NULL,
 CONSTRAINT [PK_TrocaItensLevados] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrocaSeparacao]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrocaSeparacao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TrocaId] [int] NULL,
	[ItemId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[QtdeSeparada] [numeric](18, 4) NULL,
	[Saldo]  AS ([dbo].[FUN_SALDO_SEPARAR_ITEM_TROCA]([id])),
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
 CONSTRAINT [PK_TrocaSeparacao] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[Nome] [varchar](200) NULL,
	[Senha] [varchar](100) NULL,
	[Supervisor] [bit] NULL,
	[Tipo] [varchar](50) NULL,
	[ExibeCusto] [bit] NULL,
	[IdAntigo] [int] NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioAcessos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioAcessos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NULL,
	[Aplicacao] [varchar](100) NULL,
 CONSTRAINT [PK_UsuarioAcessos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Venda]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Venda](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[ClienteId] [int] NULL,
	[Tipo] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[VendedorId] [int] NULL,
	[NomeCliente] [varchar](200) NULL,
	[UfCliente] [char](2) NULL,
	[Obs] [ntext] NULL,
	[DataPedido] [datetime] NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[TipoDesconto] [char](1) NULL,
	[DescricaoCenario] [varchar](200) NULL,
	[Serie] [int] NULL,
	[DataSaida] [datetime] NULL,
	[EntSai] [char](1) NULL,
	[Finalidade] [int] NULL,
	[Numero] [bigint] NULL,
	[Especie] [varchar](100) NULL,
	[Volumes] [int] NULL,
	[ModFrete] [int] NULL,
	[PesoLiquido] [numeric](18, 3) NULL,
	[PesoBruto] [numeric](18, 3) NULL,
	[Placa] [char](8) NULL,
	[SiglaUf] [char](2) NULL,
	[Chave] [varchar](100) NULL,
	[TransportadoraId] [int] NULL,
	[InfAdicionais] [ntext] NULL,
	[Recibo] [varchar](100) NULL,
	[Protocolo] [varchar](100) NULL,
	[ProtocoloCancelamento] [varchar](100) NULL,
	[JustificativaCancelamento] [nvarchar](255) NULL,
	[NumeroFornecedor] [bigint] NULL,
	[CartaCorrecao] [ntext] NULL,
	[DataCartaCorrecao] [datetime] NULL,
	[UltimaSeqCartaCorrecao] [int] NULL,
	[RomaneioId] [int] NULL,
	[NrSat] [int] NULL,
	[FormaId] [int] NULL,
	[ObsSeparacao] [ntext] NULL,
	[ImportadaXml] [bit] NULL,
	[EnviadaNuvem] [int] NULL,
	[Separado] [bit] NULL,
	[FreteNoTotalEntrada] [bit] NULL,
	[NrTalao] [bigint] NULL,
	[SemPagamento] [bit] NULL,
	[TotalBaseIcms]  AS ([dbo].[FUN_TOTAIS_NF]([id],'BI')),
	[TotalValorIcms]  AS ([dbo].[FUN_TOTAIS_NF]([id],'VI')),
	[TotalBaseST]  AS ([dbo].[FUN_TOTAIS_NF]([id],'BS')),
	[TotalValorST]  AS ([dbo].[FUN_TOTAIS_NF]([id],'VS')),
	[TotalFrete]  AS ([dbo].[FUN_TOTAIS_NF]([id],'FR')),
	[TotalDesconto]  AS ([dbo].[FUN_TOTAIS_NF]([id],'DS')),
	[TotalValorIpi]  AS ([dbo].[FUN_TOTAIS_NF]([id],'IP')),
	[TotalValorPis]  AS ([dbo].[FUN_TOTAIS_NF]([id],'PI')),
	[TotalValorCofins]  AS ([dbo].[FUN_TOTAIS_NF]([id],'CO')),
	[TotalOutros]  AS ([dbo].[FUN_TOTAIS_NF]([id],'OT')),
	[TotalNFe]  AS ([dbo].[FUN_TOTAIS_NF]([id],'NF')),
	[TotalLiquido]  AS ([dbo].[FUN_TOTAL_VENDA]([id])),
	[TotalVenda]  AS ([dbo].[FUN_VALOR_PRODUTOS_VENDA]([id])),
	[ShippingId] [varchar](50) NULL,
	[ContaMLId] [int] NULL,
	[FreteML] [numeric](18, 2) NULL,
	[ValorPago] [numeric](18, 2) NULL,
	[Troco] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Venda] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaDevolucoes]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaDevolucoes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaId] [int] NULL,
	[Chave] [varchar](100) NULL,
	[Sat] [varchar](50) NULL,
 CONSTRAINT [PK_VendaDevolucoes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaFilial]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaFilial](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpresaId] [int] NULL,
	[CnpjFilial] [varchar](50) NULL,
	[IdPdv] [int] NULL,
	[NrCaixaPdv] [int] NULL,
	[Status] [varchar](50) NULL,
	[NomeCliente] [varchar](200) NULL,
	[CnpjCpfCliente] [varchar](50) NULL,
	[UfCliente] [char](2) NULL,
	[Obs] [ntext] NULL,
	[DataPedido] [datetime] NULL,
	[TotalVenda] [numeric](18, 2) NULL,
	[Serie] [int] NULL,
	[DataSaida] [datetime] NULL,
	[EntSai] [char](1) NULL,
	[Finalidade] [int] NULL,
	[Numero] [bigint] NULL,
	[Especie] [varchar](100) NULL,
	[Volumes] [int] NULL,
	[ModFrete] [int] NULL,
	[PesoLiquido] [numeric](18, 3) NULL,
	[PesoBruto] [numeric](18, 3) NULL,
	[Placa] [char](8) NULL,
	[SiglaUf] [char](2) NULL,
	[Chave] [varchar](100) NULL,
	[InfAdicionais] [ntext] NULL,
	[TotalBaseIcms] [numeric](18, 2) NULL,
	[TotalValorIcms] [numeric](18, 2) NULL,
	[TotalBaseST] [numeric](18, 2) NULL,
	[TotalValorST] [numeric](18, 2) NULL,
	[TotalFrete] [numeric](18, 2) NULL,
	[TotalDesconto] [numeric](18, 2) NULL,
	[TotalValorIpi] [numeric](18, 2) NULL,
	[TotalValorPis] [numeric](18, 2) NULL,
	[TotalValorCofins] [numeric](18, 2) NULL,
	[TotalOutros] [numeric](18, 2) NULL,
	[TotalNFe] [numeric](18, 2) NULL,
	[Recibo] [varchar](100) NULL,
	[Protocolo] [varchar](100) NULL,
	[ProtocoloCancelamento] [varchar](100) NULL,
	[JustificativaCancelamento] [nvarchar](255) NULL,
	[CartaCorrecao] [ntext] NULL,
	[DataCartaCorrecao] [datetime] NULL,
	[UltimaSeqCartaCorrecao] [int] NULL,
	[NrSat] [int] NULL,
	[InscricaoEstadual] [varchar](30) NULL,
	[IdCliente] [int] NULL,
	[Endereco] [varchar](100) NULL,
	[NumeroEndereco] [char](5) NULL,
	[Complemento] [varchar](50) NULL,
	[Bairro] [varchar](100) NULL,
	[Ibge] [varchar](10) NULL,
 CONSTRAINT [PK_VendaFilial] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaFilialItens]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaFilialItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaFilialId] [int] NULL,
	[ProdutoId] [int] NULL,
	[DescricaoProduto] [varchar](200) NULL,
	[Qtde] [numeric](18, 4) NULL,
	[ValorUnitario] [numeric](18, 4) NULL,
	[CstIcms] [varchar](4) NULL,
	[BaseIcms] [numeric](18, 2) NULL,
	[AliqIcms] [numeric](18, 2) NULL,
	[ValorIcms] [numeric](18, 2) NULL,
	[ReducaoIcms] [numeric](18, 2) NULL,
	[BaseST] [numeric](18, 2) NULL,
	[AliqST] [numeric](18, 2) NULL,
	[IvaST] [numeric](18, 2) NULL,
	[ValorST] [numeric](18, 2) NULL,
	[CstFederal] [varchar](4) NULL,
	[BaseFederal] [numeric](18, 2) NULL,
	[ValorPis] [numeric](18, 2) NULL,
	[AliqPis] [numeric](18, 2) NULL,
	[ValorCofins] [numeric](18, 2) NULL,
	[AliqCofins] [numeric](18, 2) NULL,
	[CstIpi] [varchar](4) NULL,
	[BaseIpi] [numeric](18, 2) NULL,
	[AliqIpi] [numeric](18, 2) NULL,
	[ValorIpi] [numeric](18, 2) NULL,
	[Cfop] [varchar](5) NULL,
	[Cest] [varchar](20) NULL,
	[ValorDesconto] [numeric](18, 2) NULL,
	[ValorFrete] [numeric](18, 2) NULL,
	[ValorOutros] [numeric](18, 2) NULL,
	[TotalItem] [numeric](18, 2) NULL,
	[Um] [varchar](6) NULL,
	[ObsItem] [varchar](500) NULL,
	[CnpjFilial] [varchar](50) NULL,
	[IdPdv] [int] NULL,
	[CodigoProduto] [int] NULL,
 CONSTRAINT [PK_VendaFilialItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaItens]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaId] [int] NULL,
	[CenarioId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[ValorUnitario] [numeric](18, 6) NULL,
	[CustoVenda] [numeric](18, 2) NULL,
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[CstIcms] [varchar](4) NULL,
	[BaseIcms] [numeric](18, 2) NULL,
	[AliqIcms] [numeric](18, 2) NULL,
	[ValorIcms] [numeric](18, 2) NULL,
	[ReducaoIcms] [numeric](18, 2) NULL,
	[BaseST] [numeric](18, 2) NULL,
	[AliqST] [numeric](18, 2) NULL,
	[IvaST] [numeric](18, 2) NULL,
	[ValorST] [numeric](18, 2) NULL,
	[CstFederal] [varchar](4) NULL,
	[BaseFederal] [numeric](18, 2) NULL,
	[ValorPis] [numeric](18, 2) NULL,
	[AliqPis] [numeric](18, 2) NULL,
	[ValorCofins] [numeric](18, 2) NULL,
	[AliqCofins] [numeric](18, 2) NULL,
	[CstIpi] [varchar](4) NULL,
	[BaseIpi] [numeric](18, 2) NULL,
	[AliqIpi] [numeric](18, 2) NULL,
	[ValorIpi] [numeric](18, 2) NULL,
	[Cfop] [varchar](5) NULL,
	[Cest] [numeric](7, 0) NULL,
	[ValorDesconto] [numeric](18, 2) NULL,
	[ValorFrete] [numeric](18, 2) NULL,
	[ChaveOrigem] [varchar](44) NULL,
	[ValorOutros] [numeric](18, 2) NULL,
	[TotalItem]  AS ([dbo].[FUN_VALOR_TOTAL_ITEM]([id])),
	[CodProdutoFornecedor] [varchar](200) NULL,
	[DescricaoProdutoFornecedor] [varchar](200) NULL,
	[NcmProdutoFornecedor] [varchar](15) NULL,
	[UmProdutoFornecedor] [varchar](6) NULL,
	[Um] [varchar](6) NULL,
	[ObsItem] [varchar](500) NULL,
	[DevolucaoId] [int] NULL,
	[QtdeDevolvida] [numeric](18, 4) NULL,
	[QtdePC] [int] NULL,
	[ValorDifal] [numeric](18, 2) NULL,
	[DifalAliqInterUF] [numeric](18, 2) NULL,
	[DifalAliqUFDest] [numeric](18, 2) NULL,
	[DifalFCPDest] [numeric](18, 2) NULL,
	[DifalValorDest] [numeric](18, 2) NULL,
	[DifalBase] [numeric](18, 2) NULL,
	[ValorDollar] [numeric](18, 2) NULL,
	[ValorML] [numeric](18, 2) NULL,
	[TarifaML] [numeric](18, 2) NULL,
	[CodigoTerceiro] [varchar](100) NULL,
 CONSTRAINT [PK_VendaItens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaSeparacao]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaSeparacao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaId] [int] NULL,
	[ItemId] [int] NULL,
	[ProdutoId] [int] NULL,
	[Qtde] [numeric](18, 4) NULL,
	[QtdeSeparada] [numeric](18, 4) NULL,
	[Saldo]  AS ([dbo].[FUN_SALDO_SEPARAR_ITEM]([id])),
	[Usuario] [varchar](100) NULL,
	[DataInclusao] [datetime] NULL,
	[EmpresaId] [int] NULL,
 CONSTRAINT [PK_VendaSeparacao] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaServicos]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaServicos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaId] [int] NULL,
	[Servico] [varchar](500) NULL,
	[Valor] [numeric](18, 2) NULL,
	[Faturado] [bit] NULL,
	[ValorDesconto] [numeric](18, 2) NULL,
 CONSTRAINT [PK_VendaServicos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendaTitulosTransp]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendaTitulosTransp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendaId] [int] NOT NULL,
	[TituloId] [int] NOT NULL,
 CONSTRAINT [PK_VendaTitulosTransp] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LancamentoBancario] ADD  CONSTRAINT [DF_LancamentoBancario_Avulso]  DEFAULT ((0)) FOR [Avulso]
GO
ALTER TABLE [dbo].[Assistencia]  WITH CHECK ADD  CONSTRAINT [FK_Assistencia_Pessoa] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Assistencia] CHECK CONSTRAINT [FK_Assistencia_Pessoa]
GO
ALTER TABLE [dbo].[Assistencia]  WITH CHECK ADD  CONSTRAINT [FK_Assistencia_Pessoa1] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Assistencia] CHECK CONSTRAINT [FK_Assistencia_Pessoa1]
GO
ALTER TABLE [dbo].[Assistencia]  WITH CHECK ADD  CONSTRAINT [FK_Assistencia_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[Assistencia] CHECK CONSTRAINT [FK_Assistencia_Produto]
GO
ALTER TABLE [dbo].[Assistencia]  WITH CHECK ADD  CONSTRAINT [FK_Assistencia_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[Assistencia] CHECK CONSTRAINT [FK_Assistencia_Venda]
GO
ALTER TABLE [dbo].[AssistenciaHistorico]  WITH CHECK ADD  CONSTRAINT [FK_AssistenciaHistorico_Assistencia] FOREIGN KEY([AssistenciaId])
REFERENCES [dbo].[Assistencia] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssistenciaHistorico] CHECK CONSTRAINT [FK_AssistenciaHistorico_Assistencia]
GO
ALTER TABLE [dbo].[AtualizacaoPrecos]  WITH CHECK ADD  CONSTRAINT [FK_AtualizacaoPrecos_AtualizacaoPrecos] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[AtualizacaoPrecos] CHECK CONSTRAINT [FK_AtualizacaoPrecos_AtualizacaoPrecos]
GO
ALTER TABLE [dbo].[AtualizacaoPrecos]  WITH CHECK ADD  CONSTRAINT [FK_AtualizacaoPrecos_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[AtualizacaoPrecos] CHECK CONSTRAINT [FK_AtualizacaoPrecos_Pessoa]
GO
ALTER TABLE [dbo].[AtualizacaoPrecos]  WITH CHECK ADD  CONSTRAINT [FK_AtualizacaoPrecos_Venda] FOREIGN KEY([EntradaId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[AtualizacaoPrecos] CHECK CONSTRAINT [FK_AtualizacaoPrecos_Venda]
GO
ALTER TABLE [dbo].[Auditoria]  WITH CHECK ADD  CONSTRAINT [FK_Auditoria_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Auditoria] CHECK CONSTRAINT [FK_Auditoria_Pessoa]
GO
ALTER TABLE [dbo].[CaixaAuditoria]  WITH CHECK ADD  CONSTRAINT [FK_CaixaAuditoria_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[CaixaAuditoria] CHECK CONSTRAINT [FK_CaixaAuditoria_Empresa]
GO
ALTER TABLE [dbo].[CenarioFiscal]  WITH CHECK ADD  CONSTRAINT [FK_CenarioFiscal_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[CenarioFiscal] CHECK CONSTRAINT [FK_CenarioFiscal_Pessoa]
GO
ALTER TABLE [dbo].[CenarioFiscalItens]  WITH CHECK ADD  CONSTRAINT [FK_CenarioFiscalItens_CenarioFiscalItens] FOREIGN KEY([CenarioId])
REFERENCES [dbo].[CenarioFiscal] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CenarioFiscalItens] CHECK CONSTRAINT [FK_CenarioFiscalItens_CenarioFiscalItens]
GO
ALTER TABLE [dbo].[CenarioFiscalItens]  WITH CHECK ADD  CONSTRAINT [FK_CenarioFiscalItens_Pessoa] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[CenarioFiscalItens] CHECK CONSTRAINT [FK_CenarioFiscalItens_Pessoa]
GO
ALTER TABLE [dbo].[CentroResultado]  WITH NOCHECK ADD  CONSTRAINT [FK_CentroResultado_CentroResultado] FOREIGN KEY([SuperiorId])
REFERENCES [dbo].[CentroResultado] ([Id])
GO
ALTER TABLE [dbo].[CentroResultado] CHECK CONSTRAINT [FK_CentroResultado_CentroResultado]
GO
ALTER TABLE [dbo].[CentroResultado]  WITH CHECK ADD  CONSTRAINT [FK_CentroResultado_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[CentroResultado] CHECK CONSTRAINT [FK_CentroResultado_Pessoa]
GO
ALTER TABLE [dbo].[Cheque]  WITH CHECK ADD  CONSTRAINT [FK_Cheque_Conta] FOREIGN KEY([ContaId])
REFERENCES [dbo].[Conta] ([Id])
GO
ALTER TABLE [dbo].[Cheque] CHECK CONSTRAINT [FK_Cheque_Conta]
GO
ALTER TABLE [dbo].[Cheque]  WITH CHECK ADD  CONSTRAINT [FK_Cheque_Pessoa] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Cheque] CHECK CONSTRAINT [FK_Cheque_Pessoa]
GO
ALTER TABLE [dbo].[Cheque]  WITH CHECK ADD  CONSTRAINT [FK_Cheque_Pessoa1] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Cheque] CHECK CONSTRAINT [FK_Cheque_Pessoa1]
GO
ALTER TABLE [dbo].[Config]  WITH CHECK ADD  CONSTRAINT [FK_Config_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Config] CHECK CONSTRAINT [FK_Config_Pessoa]
GO
ALTER TABLE [dbo].[Conta]  WITH CHECK ADD  CONSTRAINT [FK_Conta_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Conta] CHECK CONSTRAINT [FK_Conta_Pessoa]
GO
ALTER TABLE [dbo].[CustoHistorico]  WITH CHECK ADD  CONSTRAINT [FK_CustoHistorico_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[CustoHistorico] CHECK CONSTRAINT [FK_CustoHistorico_Pessoa]
GO
ALTER TABLE [dbo].[CustoHistorico]  WITH CHECK ADD  CONSTRAINT [FK_CustoHistorico_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[CustoHistorico] CHECK CONSTRAINT [FK_CustoHistorico_Produto]
GO
ALTER TABLE [dbo].[DeparaEntrada]  WITH CHECK ADD  CONSTRAINT [FK_DeparaEntrada_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[DeparaEntrada] CHECK CONSTRAINT [FK_DeparaEntrada_Pessoa]
GO
ALTER TABLE [dbo].[Escrituracao]  WITH CHECK ADD  CONSTRAINT [FK_Escrituracao_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Escrituracao] CHECK CONSTRAINT [FK_Escrituracao_Empresa]
GO
ALTER TABLE [dbo].[Escrituracao]  WITH CHECK ADD  CONSTRAINT [FK_Escrituracao_EscrituracaoTipos] FOREIGN KEY([TipoId])
REFERENCES [dbo].[EscrituracaoTipos] ([Id])
GO
ALTER TABLE [dbo].[Escrituracao] CHECK CONSTRAINT [FK_Escrituracao_EscrituracaoTipos]
GO
ALTER TABLE [dbo].[Escrituracao]  WITH CHECK ADD  CONSTRAINT [FK_Escrituracao_Fornecedor] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Escrituracao] CHECK CONSTRAINT [FK_Escrituracao_Fornecedor]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_Inventario] FOREIGN KEY([InventarioId])
REFERENCES [dbo].[Inventario] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_Inventario]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_Pessoa]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_Produto]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_Troca]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_TrocaItensLevados] FOREIGN KEY([TrocaItemId])
REFERENCES [dbo].[TrocaItensLevados] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_TrocaItensLevados]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_Venda]
GO
ALTER TABLE [dbo].[Estoque]  WITH CHECK ADD  CONSTRAINT [FK_Estoque_VendaItens] FOREIGN KEY([ItemId])
REFERENCES [dbo].[VendaItens] ([Id])
GO
ALTER TABLE [dbo].[Estoque] CHECK CONSTRAINT [FK_Estoque_VendaItens]
GO
ALTER TABLE [dbo].[FormaPagamento]  WITH CHECK ADD  CONSTRAINT [FK_FormaPagamento_Conta] FOREIGN KEY([ContaId])
REFERENCES [dbo].[Conta] ([Id])
GO
ALTER TABLE [dbo].[FormaPagamento] CHECK CONSTRAINT [FK_FormaPagamento_Conta]
GO
ALTER TABLE [dbo].[FormaPagamento]  WITH CHECK ADD  CONSTRAINT [FK_FormaPagamento_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[FormaPagamento] CHECK CONSTRAINT [FK_FormaPagamento_Pessoa]
GO
ALTER TABLE [dbo].[FormaPagamentoPrazos]  WITH CHECK ADD  CONSTRAINT [FK_FormaPagamentoPrazos_FormaPagamento] FOREIGN KEY([FormaId])
REFERENCES [dbo].[FormaPagamento] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FormaPagamentoPrazos] CHECK CONSTRAINT [FK_FormaPagamentoPrazos_FormaPagamento]
GO
ALTER TABLE [dbo].[FormasEntrada]  WITH CHECK ADD  CONSTRAINT [FK_FormasEntrada_Conta] FOREIGN KEY([ContaId])
REFERENCES [dbo].[Conta] ([Id])
GO
ALTER TABLE [dbo].[FormasEntrada] CHECK CONSTRAINT [FK_FormasEntrada_Conta]
GO
ALTER TABLE [dbo].[FormasEntrada]  WITH CHECK ADD  CONSTRAINT [FK_FormasEntrada_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[FormasEntrada] CHECK CONSTRAINT [FK_FormasEntrada_Pessoa]
GO
ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD  CONSTRAINT [FK_Inventario_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Inventario] CHECK CONSTRAINT [FK_Inventario_Pessoa]
GO
ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD  CONSTRAINT [FK_Inventario_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuario] ([Id])
GO
ALTER TABLE [dbo].[Inventario] CHECK CONSTRAINT [FK_Inventario_Usuario]
GO
ALTER TABLE [dbo].[InventarioItens]  WITH CHECK ADD  CONSTRAINT [FK_InventarioItens_Inventario] FOREIGN KEY([InventarioId])
REFERENCES [dbo].[Inventario] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InventarioItens] CHECK CONSTRAINT [FK_InventarioItens_Inventario]
GO
ALTER TABLE [dbo].[InventarioItens]  WITH CHECK ADD  CONSTRAINT [FK_InventarioItens_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[InventarioItens] CHECK CONSTRAINT [FK_InventarioItens_Produto]
GO
ALTER TABLE [dbo].[LancamentoBancario]  WITH CHECK ADD  CONSTRAINT [FK_LancamentoBancario_Cheque] FOREIGN KEY([ChequeId])
REFERENCES [dbo].[Cheque] ([Id])
GO
ALTER TABLE [dbo].[LancamentoBancario] CHECK CONSTRAINT [FK_LancamentoBancario_Cheque]
GO
ALTER TABLE [dbo].[LancamentoBancario]  WITH CHECK ADD  CONSTRAINT [FK_LancamentoBancario_Conta] FOREIGN KEY([ContaId])
REFERENCES [dbo].[Conta] ([Id])
GO
ALTER TABLE [dbo].[LancamentoBancario] CHECK CONSTRAINT [FK_LancamentoBancario_Conta]
GO
ALTER TABLE [dbo].[LancamentoBancario]  WITH CHECK ADD  CONSTRAINT [FK_LancamentoBancario_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[LancamentoBancario] CHECK CONSTRAINT [FK_LancamentoBancario_Empresa]
GO
ALTER TABLE [dbo].[LancamentoBancario]  WITH CHECK ADD  CONSTRAINT [FK_LancamentoBancario_Titulo] FOREIGN KEY([TituloId])
REFERENCES [dbo].[Titulo] ([Id])
GO
ALTER TABLE [dbo].[LancamentoBancario] CHECK CONSTRAINT [FK_LancamentoBancario_Titulo]
GO
ALTER TABLE [dbo].[LancamentoBancario]  WITH CHECK ADD  CONSTRAINT [FK_LancamentoBancario_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
GO
ALTER TABLE [dbo].[LancamentoBancario] CHECK CONSTRAINT [FK_LancamentoBancario_Troca]
GO
ALTER TABLE [dbo].[OrdensML]  WITH CHECK ADD  CONSTRAINT [FK_OrdensML_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrdensML] CHECK CONSTRAINT [FK_OrdensML_Venda]
GO
ALTER TABLE [dbo].[Pessoa]  WITH CHECK ADD  CONSTRAINT [FK_Pessoa_FormaPagamento] FOREIGN KEY([FormaPagId])
REFERENCES [dbo].[FormaPagamento] ([Id])
GO
ALTER TABLE [dbo].[Pessoa] CHECK CONSTRAINT [FK_Pessoa_FormaPagamento]
GO
ALTER TABLE [dbo].[Pessoa]  WITH CHECK ADD  CONSTRAINT [FK_Pessoa_Pais] FOREIGN KEY([PaisId])
REFERENCES [dbo].[Pais] ([Id])
GO
ALTER TABLE [dbo].[Pessoa] CHECK CONSTRAINT [FK_Pessoa_Pais]
GO
ALTER TABLE [dbo].[Pessoa]  WITH CHECK ADD  CONSTRAINT [FK_Pessoa_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Pessoa] CHECK CONSTRAINT [FK_Pessoa_Pessoa]
GO
ALTER TABLE [dbo].[Pessoa]  WITH CHECK ADD  CONSTRAINT [FK_Pessoa_Pessoa1] FOREIGN KEY([Id])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Pessoa] CHECK CONSTRAINT [FK_Pessoa_Pessoa1]
GO
ALTER TABLE [dbo].[PessoaContatos]  WITH CHECK ADD  CONSTRAINT [FK_PessoaContatos_Pessoa] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PessoaContatos] CHECK CONSTRAINT [FK_PessoaContatos_Pessoa]
GO
ALTER TABLE [dbo].[ProdutoComposicao]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoComposicao_ItemComposicao] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[ProdutoComposicao] CHECK CONSTRAINT [FK_ProdutoComposicao_ItemComposicao]
GO
ALTER TABLE [dbo].[ProdutoComposicao]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoComposicao_Produto] FOREIGN KEY([OrigemId])
REFERENCES [dbo].[Produto] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProdutoComposicao] CHECK CONSTRAINT [FK_ProdutoComposicao_Produto]
GO
ALTER TABLE [dbo].[ProdutoEan]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoEan_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[ProdutoEan] CHECK CONSTRAINT [FK_ProdutoEan_Produto]
GO
ALTER TABLE [dbo].[ProdutoFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoFornecedores_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[ProdutoFornecedores] CHECK CONSTRAINT [FK_ProdutoFornecedores_Pessoa]
GO
ALTER TABLE [dbo].[ProdutoFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoFornecedores_Pessoa1] FOREIGN KEY([FornecedorId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[ProdutoFornecedores] CHECK CONSTRAINT [FK_ProdutoFornecedores_Pessoa1]
GO
ALTER TABLE [dbo].[ProdutoFornecedores]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoFornecedores_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProdutoFornecedores] CHECK CONSTRAINT [FK_ProdutoFornecedores_Produto]
GO
ALTER TABLE [dbo].[ProdutoUnidades]  WITH CHECK ADD  CONSTRAINT [FK_ProdutoUnidades_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProdutoUnidades] CHECK CONSTRAINT [FK_ProdutoUnidades_Produto]
GO
ALTER TABLE [dbo].[Romaneio]  WITH CHECK ADD  CONSTRAINT [FK_Romaneio_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Romaneio] CHECK CONSTRAINT [FK_Romaneio_Pessoa]
GO
ALTER TABLE [dbo].[Sped0000]  WITH CHECK ADD  CONSTRAINT [FK_Sped0000_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0000] CHECK CONSTRAINT [FK_Sped0000_Pessoa]
GO
ALTER TABLE [dbo].[Sped0005]  WITH CHECK ADD  CONSTRAINT [FK_Sped0005_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0005] CHECK CONSTRAINT [FK_Sped0005_Pessoa]
GO
ALTER TABLE [dbo].[Sped0150]  WITH CHECK ADD  CONSTRAINT [FK_Sped0150_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0150] CHECK CONSTRAINT [FK_Sped0150_Pessoa]
GO
ALTER TABLE [dbo].[Sped0190]  WITH CHECK ADD  CONSTRAINT [FK_Sped0190_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0190] CHECK CONSTRAINT [FK_Sped0190_Pessoa]
GO
ALTER TABLE [dbo].[Sped0200]  WITH CHECK ADD  CONSTRAINT [FK_Sped0200_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0200] CHECK CONSTRAINT [FK_Sped0200_Pessoa]
GO
ALTER TABLE [dbo].[Sped0500]  WITH CHECK ADD  CONSTRAINT [FK_Sped0500_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Sped0500] CHECK CONSTRAINT [FK_Sped0500_Pessoa]
GO
ALTER TABLE [dbo].[SpedC100]  WITH CHECK ADD  CONSTRAINT [FK_SpedC100_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC100] CHECK CONSTRAINT [FK_SpedC100_Pessoa]
GO
ALTER TABLE [dbo].[SpedC170]  WITH CHECK ADD  CONSTRAINT [FK_SpedC170_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC170] CHECK CONSTRAINT [FK_SpedC170_Pessoa]
GO
ALTER TABLE [dbo].[SpedC170]  WITH CHECK ADD  CONSTRAINT [FK_SpedC170_SpedC100] FOREIGN KEY([C100Id])
REFERENCES [dbo].[SpedC100] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedC170] CHECK CONSTRAINT [FK_SpedC170_SpedC100]
GO
ALTER TABLE [dbo].[SpedC190]  WITH CHECK ADD  CONSTRAINT [FK_SpedC190_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC190] CHECK CONSTRAINT [FK_SpedC190_Pessoa]
GO
ALTER TABLE [dbo].[SpedC190]  WITH CHECK ADD  CONSTRAINT [FK_SpedC190_SpedC100] FOREIGN KEY([C100Id])
REFERENCES [dbo].[SpedC100] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedC190] CHECK CONSTRAINT [FK_SpedC190_SpedC100]
GO
ALTER TABLE [dbo].[SpedC400]  WITH CHECK ADD  CONSTRAINT [FK_SpedC400_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC400] CHECK CONSTRAINT [FK_SpedC400_Pessoa]
GO
ALTER TABLE [dbo].[SpedC405]  WITH CHECK ADD  CONSTRAINT [FK_SpedC405_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC405] CHECK CONSTRAINT [FK_SpedC405_Pessoa]
GO
ALTER TABLE [dbo].[SpedC460]  WITH CHECK ADD  CONSTRAINT [FK_SpedC460_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC460] CHECK CONSTRAINT [FK_SpedC460_Pessoa]
GO
ALTER TABLE [dbo].[SpedC460]  WITH CHECK ADD  CONSTRAINT [FK_SpedC460_SpedC405] FOREIGN KEY([C405Id])
REFERENCES [dbo].[SpedC405] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedC460] CHECK CONSTRAINT [FK_SpedC460_SpedC405]
GO
ALTER TABLE [dbo].[SpedC470]  WITH CHECK ADD  CONSTRAINT [FK_SpedC470_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC470] CHECK CONSTRAINT [FK_SpedC470_Pessoa]
GO
ALTER TABLE [dbo].[SpedC470]  WITH CHECK ADD  CONSTRAINT [FK_SpedC470_SpedC405] FOREIGN KEY([C405Id])
REFERENCES [dbo].[SpedC405] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedC470] CHECK CONSTRAINT [FK_SpedC470_SpedC405]
GO
ALTER TABLE [dbo].[SpedC500]  WITH CHECK ADD  CONSTRAINT [FK_SpedC500_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC500] CHECK CONSTRAINT [FK_SpedC500_Pessoa]
GO
ALTER TABLE [dbo].[SpedC590]  WITH CHECK ADD  CONSTRAINT [FK_SpedC590_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedC590] CHECK CONSTRAINT [FK_SpedC590_Pessoa]
GO
ALTER TABLE [dbo].[SpedC590]  WITH CHECK ADD  CONSTRAINT [FK_SpedC590_SpedC500] FOREIGN KEY([C500Id])
REFERENCES [dbo].[SpedC500] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedC590] CHECK CONSTRAINT [FK_SpedC590_SpedC500]
GO
ALTER TABLE [dbo].[SpedD100]  WITH CHECK ADD  CONSTRAINT [FK_SpedD100_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedD100] CHECK CONSTRAINT [FK_SpedD100_Pessoa]
GO
ALTER TABLE [dbo].[SpedD190]  WITH CHECK ADD  CONSTRAINT [FK_SpedD190_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedD190] CHECK CONSTRAINT [FK_SpedD190_Pessoa]
GO
ALTER TABLE [dbo].[SpedD190]  WITH CHECK ADD  CONSTRAINT [FK_SpedD190_SpedD100] FOREIGN KEY([D100Id])
REFERENCES [dbo].[SpedD100] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpedD190] CHECK CONSTRAINT [FK_SpedD190_SpedD100]
GO
ALTER TABLE [dbo].[SpedH010]  WITH CHECK ADD  CONSTRAINT [FK_SpedH010_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[SpedH010] CHECK CONSTRAINT [FK_SpedH010_Pessoa]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_Boleto] FOREIGN KEY([BoletoId])
REFERENCES [dbo].[Boleto] ([Id])
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_Boleto]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_CentroResultado] FOREIGN KEY([CentroResultadoId])
REFERENCES [dbo].[CentroResultado] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_CentroResultado]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_Empresa]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_FormaPagamento] FOREIGN KEY([FormaId])
REFERENCES [dbo].[FormaPagamento] ([Id])
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_FormaPagamento]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_Pessoa] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_Pessoa]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_Troca]
GO
ALTER TABLE [dbo].[Titulo]  WITH CHECK ADD  CONSTRAINT [FK_Titulo_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[Titulo] CHECK CONSTRAINT [FK_Titulo_Venda]
GO
ALTER TABLE [dbo].[TituloAnexo]  WITH CHECK ADD  CONSTRAINT [FK_TituloAnexo_Anexo] FOREIGN KEY([AnexoId])
REFERENCES [dbo].[Anexo] ([Id])
GO
ALTER TABLE [dbo].[TituloAnexo] CHECK CONSTRAINT [FK_TituloAnexo_Anexo]
GO
ALTER TABLE [dbo].[TituloAnexo]  WITH CHECK ADD  CONSTRAINT [FK_TituloAnexo_Titulo] FOREIGN KEY([TituloId])
REFERENCES [dbo].[Titulo] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TituloAnexo] CHECK CONSTRAINT [FK_TituloAnexo_Titulo]
GO
ALTER TABLE [dbo].[Troca]  WITH CHECK ADD  CONSTRAINT [FK_Troca_FormaPagamento] FOREIGN KEY([FormaId])
REFERENCES [dbo].[FormaPagamento] ([Id])
GO
ALTER TABLE [dbo].[Troca] CHECK CONSTRAINT [FK_Troca_FormaPagamento]
GO
ALTER TABLE [dbo].[Troca]  WITH CHECK ADD  CONSTRAINT [FK_Troca_Pessoa] FOREIGN KEY([PessoaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Troca] CHECK CONSTRAINT [FK_Troca_Pessoa]
GO
ALTER TABLE [dbo].[Troca]  WITH CHECK ADD  CONSTRAINT [FK_Troca_Pessoa1] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Troca] CHECK CONSTRAINT [FK_Troca_Pessoa1]
GO
ALTER TABLE [dbo].[TrocaItensDev]  WITH CHECK ADD  CONSTRAINT [FK_TrocaItensDev_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[TrocaItensDev] CHECK CONSTRAINT [FK_TrocaItensDev_Produto]
GO
ALTER TABLE [dbo].[TrocaItensDev]  WITH CHECK ADD  CONSTRAINT [FK_TrocaItensDev_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TrocaItensDev] CHECK CONSTRAINT [FK_TrocaItensDev_Troca]
GO
ALTER TABLE [dbo].[TrocaItensLevados]  WITH CHECK ADD  CONSTRAINT [FK_TrocaItensLevados_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[TrocaItensLevados] CHECK CONSTRAINT [FK_TrocaItensLevados_Produto]
GO
ALTER TABLE [dbo].[TrocaItensLevados]  WITH CHECK ADD  CONSTRAINT [FK_TrocaItensLevados_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TrocaItensLevados] CHECK CONSTRAINT [FK_TrocaItensLevados_Troca]
GO
ALTER TABLE [dbo].[TrocaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_TrocaSeparacao_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[TrocaSeparacao] CHECK CONSTRAINT [FK_TrocaSeparacao_Pessoa]
GO
ALTER TABLE [dbo].[TrocaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_TrocaSeparacao_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[TrocaSeparacao] CHECK CONSTRAINT [FK_TrocaSeparacao_Produto]
GO
ALTER TABLE [dbo].[TrocaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_TrocaSeparacao_Troca] FOREIGN KEY([TrocaId])
REFERENCES [dbo].[Troca] ([Id])
GO
ALTER TABLE [dbo].[TrocaSeparacao] CHECK CONSTRAINT [FK_TrocaSeparacao_Troca]
GO
ALTER TABLE [dbo].[TrocaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_TrocaSeparacao_TrocaItensLevados] FOREIGN KEY([ItemId])
REFERENCES [dbo].[TrocaItensLevados] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TrocaSeparacao] CHECK CONSTRAINT [FK_TrocaSeparacao_TrocaItensLevados]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Pessoa]
GO
ALTER TABLE [dbo].[UsuarioAcessos]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioAcessos_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuario] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioAcessos] CHECK CONSTRAINT [FK_UsuarioAcessos_Usuario]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_Cliente] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_Cliente]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_ContaML] FOREIGN KEY([ContaMLId])
REFERENCES [dbo].[ContaML] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_ContaML]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_Empresa]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_FormaPagamento] FOREIGN KEY([FormaId])
REFERENCES [dbo].[FormaPagamento] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_FormaPagamento]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_Pessoa] FOREIGN KEY([TransportadoraId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_Pessoa]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_Romaneio] FOREIGN KEY([RomaneioId])
REFERENCES [dbo].[Romaneio] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_Romaneio]
GO
ALTER TABLE [dbo].[Venda]  WITH CHECK ADD  CONSTRAINT [FK_Venda_Vendedor] FOREIGN KEY([VendedorId])
REFERENCES [dbo].[Usuario] ([Id])
GO
ALTER TABLE [dbo].[Venda] CHECK CONSTRAINT [FK_Venda_Vendedor]
GO
ALTER TABLE [dbo].[VendaDevolucoes]  WITH CHECK ADD  CONSTRAINT [FK_VendaDevolucoes_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaDevolucoes] CHECK CONSTRAINT [FK_VendaDevolucoes_Venda]
GO
ALTER TABLE [dbo].[VendaFilialItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaFilialItens_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[VendaFilialItens] CHECK CONSTRAINT [FK_VendaFilialItens_Produto]
GO
ALTER TABLE [dbo].[VendaFilialItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaFilialItens_VendaFilial] FOREIGN KEY([VendaFilialId])
REFERENCES [dbo].[VendaFilial] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaFilialItens] CHECK CONSTRAINT [FK_VendaFilialItens_VendaFilial]
GO
ALTER TABLE [dbo].[VendaItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaItens_CenarioFiscal] FOREIGN KEY([CenarioId])
REFERENCES [dbo].[CenarioFiscal] ([Id])
GO
ALTER TABLE [dbo].[VendaItens] CHECK CONSTRAINT [FK_VendaItens_CenarioFiscal]
GO
ALTER TABLE [dbo].[VendaItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaItens_Devolucao] FOREIGN KEY([DevolucaoId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[VendaItens] CHECK CONSTRAINT [FK_VendaItens_Devolucao]
GO
ALTER TABLE [dbo].[VendaItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaItens_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[VendaItens] CHECK CONSTRAINT [FK_VendaItens_Produto]
GO
ALTER TABLE [dbo].[VendaItens]  WITH CHECK ADD  CONSTRAINT [FK_VendaItens_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaItens] CHECK CONSTRAINT [FK_VendaItens_Venda]
GO
ALTER TABLE [dbo].[VendaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_VendaSeparacao_Pessoa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Pessoa] ([Id])
GO
ALTER TABLE [dbo].[VendaSeparacao] CHECK CONSTRAINT [FK_VendaSeparacao_Pessoa]
GO
ALTER TABLE [dbo].[VendaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_VendaSeparacao_Produto] FOREIGN KEY([ProdutoId])
REFERENCES [dbo].[Produto] ([Id])
GO
ALTER TABLE [dbo].[VendaSeparacao] CHECK CONSTRAINT [FK_VendaSeparacao_Produto]
GO
ALTER TABLE [dbo].[VendaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_VendaSeparacao_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
GO
ALTER TABLE [dbo].[VendaSeparacao] CHECK CONSTRAINT [FK_VendaSeparacao_Venda]
GO
ALTER TABLE [dbo].[VendaSeparacao]  WITH CHECK ADD  CONSTRAINT [FK_VendaSeparacao_VendaItens] FOREIGN KEY([ItemId])
REFERENCES [dbo].[VendaItens] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaSeparacao] CHECK CONSTRAINT [FK_VendaSeparacao_VendaItens]
GO
ALTER TABLE [dbo].[VendaServicos]  WITH CHECK ADD  CONSTRAINT [FK_VendaServicos_Venda] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaServicos] CHECK CONSTRAINT [FK_VendaServicos_Venda]
GO
ALTER TABLE [dbo].[VendaTitulosTransp]  WITH CHECK ADD  CONSTRAINT [FK_VendaTitulosTransp_Titulo] FOREIGN KEY([TituloId])
REFERENCES [dbo].[Titulo] ([Id])
GO
ALTER TABLE [dbo].[VendaTitulosTransp] CHECK CONSTRAINT [FK_VendaTitulosTransp_Titulo]
GO
ALTER TABLE [dbo].[VendaTitulosTransp]  WITH CHECK ADD  CONSTRAINT [FK_VendaTitulosTransp_VendaTitulosTransp] FOREIGN KEY([VendaId])
REFERENCES [dbo].[Venda] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendaTitulosTransp] CHECK CONSTRAINT [FK_VendaTitulosTransp_VendaTitulosTransp]
GO
/****** Object:  StoredProcedure [dbo].[PRO_PESQUISA_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 16/12/2021
-- Description:	PESQUISA DE VENDA
-- =============================================
CREATE PROCEDURE [dbo].[PRO_PESQUISA_VENDA]
	@Emp int,
	@DataIni date,
	@DataFim date
WITH RECOMPILE
AS
BEGIN
	select V.Id,
		   V.Numero,
		   V.DataPedido,
		   V.Status,
		   V.Tipo,
		   ISNULL((SELECT SUM (ISNULL(VS.VALOR,0)) - SUM(ISNULL(VS.VALORDESCONTO,0)) FROM VENDASERVICOS VS WHERE VS.VENDAID = V.ID), 0) +
		   ISNULL((SELECT SUM(ISNULL(VI.TotalItem,0)) + SUM(ISNULL(VI.VALORIPI,0)) + SUM(ISNULL(VI.VALORST,0)) + SUM(ISNULL(VI.VALORFRETE,0)) + SUM(ISNULL(VI.VALOROUTROS,0)) - SUM(ISNULL(VI.VALORDESCONTO,0)) 
		             FROM VENDAITENS VI 
				    WHERE VI.VENDAID = V.ID), 0) As TotalLiquido,
		   C.Nome as PessoaNome,
		   V.ClienteId,
		   V.VendedorId,
		   V.Obs, 		    
		   V.NrTalao
	  from Venda V
inner join Pessoa C on C.Id = V.ClienteId
	 where V.EmpresaId = @Emp
	 and (case when @DataIni = '' then 1 else (case when V.DataPedido >= convert(datetime, @DataIni) and 
	 v.DataPedido < convert(datetime, @DataFim) then 1 else 0 end) end) = 1
	 and V.EntSai = 'S'
  order by id
END




GO
/****** Object:  StoredProcedure [dbo].[PRO_REL_BOLETO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 11/10/2018
-- Description:	RETORNA BOLETOS PARA SER IMPRESSOS
-- =============================================
CREATE PROCEDURE [dbo].[PRO_REL_BOLETO]
	 @idLote int
AS
BEGIN
	SELECT * FROM BOLETO WHERE ISNULL(Lote,0) = @idLote;
END


GO
/****** Object:  StoredProcedure [dbo].[PRO_REL_RECEBIMENTOS_LIQUIDADOS]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 03/03/2020
-- Description:	IMPRESSAO DE RECEBIMENTOS LIQUIDADOS
-- =============================================
CREATE PROCEDURE [dbo].[PRO_REL_RECEBIMENTOS_LIQUIDADOS]
	@Emp Int,
	@Ano Int,
	@Tipo char(1)
AS
BEGIN
		SELECT CASE WHEN @Tipo = 'C' THEN
				MONTH(DATACONCILIACAO)
		   ELSE
				MONTH(DATALANCTO)
		   END AS MES,
		    SUM(L.VALORLIQUIDO) VALOR,
		  (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO
	  FROM TITULO T INNER JOIN LANCAMENTOBANCARIO L ON T.ID = L.TITULOID
	INNER JOIN VENDA V ON T.VENDAID = V.ID
	WHERE T.EmpresaId = @Emp
	  AND T.TIPO = 'RECEBER'
	  AND  (CASE WHEN @Tipo = 'C' THEN
				YEAR(DATACONCILIACAO)
		   ELSE
				YEAR(DATALANCTO)
		   END)    = @Ano
	GROUP BY CASE WHEN @Tipo = 'C' THEN
				MONTH(DATACONCILIACAO)
		   ELSE
				MONTH(DATALANCTO)
		   END 
	ORDER BY 1
END

GO
/****** Object:  StoredProcedure [dbo].[REL_CAIXA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 04/01/2018
-- Description:	RELATORIO DE CAIXA - 17219
-- =============================================
CREATE PROCEDURE [dbo].[REL_CAIXA]
	@USU VARCHAR(200),
	@DATA DATETIME,
	@EMP INT
AS  
BEGIN
	
	SELECT L.TituloId, CASE WHEN L.TIPO = 'C' THEN
						(L.Valor + ISNULL(L.JUROS,0) + ISNULL(L.MULTA,0)) - ISNULL(L.DESCONTO,0)
					   ELSE
						((L.Valor + ISNULL(L.JUROS,0) + ISNULL(L.MULTA,0)) - ISNULL(L.DESCONTO,0)) * -1
					  END AS VALOR,
	   L.TIPOPAGAMENTO,
	   T.VendaId AS VENDA,
	   P.Nome,
	   (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO,
	   L.ExibeCaixa 
  FROM LancamentoBancario L
  INNER JOIN Titulo T ON L.TituloId = T.Id 
  INNER JOIN PESSOA P ON T.PessoaId = P.Id 
  WHERE L.USUARIO = @USU
  AND L.datalancto >= @DATA AND L.DataLancto < DATEADD(DAY,1,@DATA)
  AND L.EMPRESAID = @EMP

END
GO
/****** Object:  StoredProcedure [dbo].[REL_COBRANCA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 27/12/2019
-- Description:	RELATORIO DE COBRANÇA
-- =============================================
CREATE PROCEDURE [dbo].[REL_COBRANCA]
	@Emp Int
AS
BEGIN
	SELECT P.Cod_Ant CODIGO, P.NOME, SUM((T.VALORLIQUIDO - ISNULL(T.DESCONTO,0)) + ISNULL(T.JUROS,0) + ISNULL(T.MULTA,0) ) VALOR , ISNULL( (SELECT TOP 1 vALOR FROM PESSOACONTATOS PC WHERE PC.PessoaId = T.PESSOAID AND PC.TIPO LIKE '%FONE%' OR PC.TIPO LIKE '%FIXO%' OR PC.TIPO LIKE '%CELULAR%'),'') TELEFONE,
	  (SELECT co.logoRelEmpresa  FROM Config CO WHERE CO.EMPRESAID = T.EMPRESAID AND Co.Parametro = 'Imagens da Empresa') AS lOGO
  FROM TITULO T 
  INNER JOIN PESSOA P ON T.PESSOAID = P.ID
 WHERE T.EMPRESAID = @Emp
 AND   T.STATUS = 'ABERTO'
 AND   T.TIPO   = 'RECEBER'
 AND   T.VENCIMENTO < dateadd(day,1,getdate())
 GROUP BY P.Cod_Ant, P.NOME, T.PessoaId , T.EMPRESAID
 ORDER BY P.NOME
END

GO
/****** Object:  StoredProcedure [dbo].[REL_ETIQUETA_DANFE]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gustavo Volke
-- Create date: 19/11/2021
-- Description:	Procedure Relatório Etiqueta DANFE
-- =============================================
CREATE PROCEDURE [dbo].[REL_ETIQUETA_DANFE] 
	@Id int
AS
BEGIN
	SELECT 
		   ISNULL(V.Numero, 0) As NrVenda,
		   ISNULL(V.Chave, 0) As ChaveAcesso,

		   E.Nome As NomeEmitente,
		   (case when isnull(E.endereco,'') = '' then '' else isnull(E.endereco,'') + ', ' + isnull(E.Numero,'') + '. ' + isnull(E.Bairro,'') + ' ' + isnull(E.cep,'') + ' ' + isnull(E.Cidade,'') + '-' + isnull(E.Estado,'') end) as EndEmitente,
		   E.CnpjCpf As CnpjCpfEmitente,
		   
		   EMP.Nome As NomeEmp,
		   (case when isnull(EMP.endereco,'') = '' then '' else isnull(EMP.endereco,'') + ', ' + isnull(EMP.Numero,'') + '. ' + isnull(EMP.Bairro,'') + ' ' + isnull(EMP.cep,'') + ' ' + isnull(EMP.Cidade,'') + '-' + isnull(EMP.Estado,'') end) as EndEmp,
		   EMP.CnpjCpf As CnpjCpfEmp,

		   P.Codigo,
		   P.Descricao,
		   VI.Qtde,
		   VI.ValorUnitario,
		   VI.TotalItem As ValorTotal,
		   P.Um,
		   V.TotalVenda
	  FROM VENDA V
INNER JOIN VENDAITENS VI ON V.ID = VI.VendaId
INNER JOIN PRODUTO P ON P.ID = VI.PRODUTOID
INNER JOIN PESSOA E ON E.Id = V.CLienteId
INNER JOIN PESSOA EMP ON EMP.Id = V.EmpresaId	   
	 WHERE V.ID = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[REL_EXTRATO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 06/05/2019
-- Description:	TAREFA 18987
-- =============================================
CREATE PROCEDURE [dbo].[REL_EXTRATO]
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
SELECT DATEADD(DAY,-1,@INICIAL) as Data,
	   'SALDO ANTERIOR' AS Descricao,
	   CASE WHEN @SaldoAnt >0 THEN 'C' ELSE 'D' end AS Tipo,
	   @SaldoAnt AS ValorConciliado,
	   1 as conciliado,
	   (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO
UNION ALL
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

GO
/****** Object:  StoredProcedure [dbo].[REL_FATURAMENTO_FISCAL]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 15/09/2021
-- Description:	TAREFA 44548
-- =============================================
CREATE PROCEDURE [dbo].[REL_FATURAMENTO_FISCAL]
	-- Add the parameters for the stored procedure here
	@Ini Datetime,
	@Fim Datetime
AS
BEGIN
	SELECT E.NOME AS EMPRESA, ( SUM(ISNULL(TotalItem,0)) + SUM(ISNULL(ValorIpi,0)) + SUM(ISNULL(ValorST,0)) + SUM(ISNULL(ValorFrete,0)) + SUM(ISNULL(ValorOutros,0))) - SUM(ISNULL(ValorDesconto ,0)) AS FATURAMENTO 
	  FROM VENDA V INNER JOIN PESSOA E ON V.EMPRESAID = E.ID
	INNER JOIN VENDAITENS VI ON V.ID = VI.VENDAID
	INNER JOIN CENARIOFISCAL CF ON VI.CENARIOID = CF.ID
	 WHERE V.ENTSAI = 'S'
	   AND V.STATUS = 'NFe-APROVADA'
	   AND V.DATAPEDIDO >= @Ini
	   AND V.DATAPEDIDO < @Fim
	   AND ISNULL(CF.DEVOLUCAO,0) = 0
	GROUP BY E.NOME
END

GO
/****** Object:  StoredProcedure [dbo].[REL_IMP_ASSISTENCIA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[REL_IMP_ASSISTENCIA] 
	@id int
AS
BEGIN
	SELECT A.id as IdAssistencia,
	   A.NumeroAno,
	   A.Status,
	   A.Data as DataAbertura,
	   Venda.NomeCliente,
	   c.CnpjCpf,
	   isnull(cast(c.Cod_Ant as varchar(50)), '' ) as CodAntCliente,
	   0 as TotalDesconto,
	   0 as TotalImpostos,
	   0 as TotalFrete,
	   0 as TotalNFe,
	   0 as TotalLiquido,

	   A.Qtde,
	   0 as ValorUnitario,
	   0 as TotalItem,
	   
	   p.Codigo,
	   p.Descricao,

	   (case when isnull(c.endereco,'') = '' then '' else isnull(c.cep,'') + '  ' +  isnull(c.endereco,'') + ', ' + isnull(c.Numero,'') + ' - ' + isnull(c.Bairro,'') + ' - ' + isnull(c.Cidade,'') + '/' + isnull(c.Estado,'') end) as EndCliente,
	   cast(isnull((select distinct ' -' + PessoaContatos.Valor from PessoaContatos
	   where (PessoaContatos.Tipo like '%FONE%' or PessoaContatos.Tipo like '%CELULAR%')
	   and c.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> ''
	   for xml path ('')), '') as varchar(200)) as FoneCliente,

	   e.nome as NomeEpresa,
	   e.Fantasia as FantasiaEmpresa,
	   e.CnpjCpf as DocEmpresa,
	   e.endereco + ', ' + e.Numero + ' - ' + e.Bairro + ' - ' + e.Cidade + '/' + e.Estado as EndEmpresa,
	   e.Fone as FoneEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%MAIL' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as EmailEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%SITE' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as SiteEmpresa,

	   --U.Nome as NomeUsuario,

	   co.logoRelEmpresa as logotipo,
	   --fr.Descricao as FormaPagamento,
	   0 as QtdeServicos,
	   0 as QtdeCondicoes,
	   Venda.NrTalao ,
	   A.obs
	   
FROM Assistencia A 
     INNER JOIN Pessoa E on A.EmpresaId = e.Id 
	 LEFT OUTER JOIN Venda on Venda.Id = A.VendaId     
	 LEFT OUTER JOIN Pessoa C on Venda.ClienteId  = c.id
	 LEFT JOIN Produto P on A.ProdutoId = P.Id
	 LEFT JOIN Config CO on CO.EmpresaId = A.EmpresaId and Co.Parametro = 'Imagens da Empresa'
where A.id = @id
END


GO
/****** Object:  StoredProcedure [dbo].[REL_IMP_SEPARACAO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 26/08/2019
-- Description:	IMPRESSÃO DE SEPARAÇÃO - 17320
-- =============================================
CREATE PROCEDURE [dbo].[REL_IMP_SEPARACAO]
	@Id Int
AS
BEGIN
	SELECT V.Id,
	       C.NOME,
		   V.DATAPEDIDO,
		   P.DESCRICAO,
		   P.CODIGO,
		   VS.QTDE,
		   co.logoRelEmpresa as LOGOTIPO   
	   FROM VendaSeparacao VS INNER JOIN VENDA V ON VS.VENDAID = V.ID
	  INNER JOIN PESSOA C ON C.ID = V.ClienteId 
	  INNER JOIN PRODUTO P ON VS.ProdutoId = P.ID 
	  LEFT JOIN Config CO on CO.EmpresaId = v.EmpresaId and Co.Parametro = 'Imagens da Empresa'
	  WHERE V.ID = @Id
END

GO
/****** Object:  StoredProcedure [dbo].[REL_IMP_TROCA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jadson Sanches
-- Create date: 16/05/2018
-- Description:	Procedure de Vendas
-- =============================================
CREATE PROCEDURE [dbo].[REL_IMP_TROCA] 
	@id int
AS
BEGIN
SELECT t.id as IdVenda,
	   t.DataTroca,
	   c.Nome as NomeCliente,
	   c.CnpjCpf,
	   ISNULL(t.SaldoTroca, 0) as SaldoTroca,
	   (ISNULL(t.TotaHaver,0)) as TotaHaver,
	   (ISNULL(t.Desconto,0)) as Desconto,

	   ti.Qtde,
	   ti.ValorUnitario,
	   ti.TotalItem,
	   
	   p.Codigo,
	   p.Descricao + (case when isnull(ti.NumeroSerie,'') = '' then '' else ' - Nº Série: ' + ti.NumeroSerie end) as Descricao,

	   (case when isnull(c.endereco,'') = '' then '' else isnull(c.endereco,'') + ', ' + isnull(c.Numero,'') + ' - ' + isnull(c.Bairro,'') + ' - ' + isnull(c.Cidade,'') + '/' + isnull(c.Estado,'') end) as EndCliente,
	   isnull((select top 1 PessoaContatos.Valor from PessoaContatos
	   where PessoaContatos.Tipo = 'FONE'
	   and c.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> ''), '') as FoneCliente,

	   e.nome as NomeEpresa,
	   e.Fantasia as FantasiaEmpresa,
	   e.CnpjCpf as DocEmpresa,
	   e.endereco + ', ' + e.Numero + ' - ' + e.Bairro + ' - ' + e.Cidade + '/' + e.Estado as EndEmpresa,
	   e.Fone as FoneEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%MAIL' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as EmailEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%SITE' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as SiteEmpresa,	      
	   co.logoRelEmpresa as logotipo,
	   'DEV' as Secao,
	   t.Obs	   
FROM Troca t 
     INNER JOIN Pessoa E on t.EmpresaId = e.Id 
     LEFT JOIN TrocaItensDev ti on t.Id = ti.TrocaId
	 LEFT OUTER JOIN Pessoa C on t.PessoaId  = c.id
	 LEFT JOIN Produto P on ti.ProdutoId = P.Id
	 LEFT JOIN Config CO on CO.EmpresaId = t.EmpresaId and Co.Parametro = 'Imagens da Empresa'
where t.id = @id

UNION ALL

SELECT t.id as IdVenda,
	   t.DataTroca,
	   c.Nome as NomeCliente,
	   c.CnpjCpf,
	   ISNULL(t.SaldoTroca, 0) as SaldoTroca,
	   (ISNULL(t.TotaHaver,0)) as TotaHaver,
	   (ISNULL(t.Desconto,0)) as Desconto,
	   
	   ti.Qtde,
	   ti.ValorUnitario,
	   ti.TotalItem,
	   
	   p.Codigo,
	   p.Descricao + (case when isnull(ti.NumeroSerie,'') = '' then '' else ' - Nº Série: ' + ti.NumeroSerie end) as Descricao,

	   (case when isnull(c.endereco,'') = '' then '' else isnull(c.endereco,'') + ', ' + isnull(c.Numero,'') + ' - ' + isnull(c.Bairro,'') + ' - ' + isnull(c.Cidade,'') + '/' + isnull(c.Estado,'') end) as EndCliente,
	   isnull((select top 1 PessoaContatos.Valor from PessoaContatos
	   where PessoaContatos.Tipo = 'FONE'
	   and c.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> ''), '') as FoneCliente,

	   e.nome as NomeEpresa,
	   e.Fantasia as FantasiaEmpresa,
	   e.CnpjCpf as DocEmpresa,
	   e.endereco + ', ' + e.Numero + ' - ' + e.Bairro + ' - ' + e.Cidade + '/' + e.Estado as EndEmpresa,
	   e.Fone as FoneEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%MAIL' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as EmailEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%SITE' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as SiteEmpresa,	      
	   co.logoRelEmpresa as logotipo,
	   'LEVADOS' as Secao,	
	   t.Obs    
FROM Troca t 
     INNER JOIN Pessoa E on t.EmpresaId = e.Id 
     LEFT JOIN TrocaItensLevados ti on t.Id = ti.TrocaId
	 LEFT OUTER JOIN Pessoa C on t.PessoaId  = c.id
	 LEFT JOIN Produto P on ti.ProdutoId = P.Id
	 LEFT JOIN Config CO on CO.EmpresaId = t.EmpresaId and Co.Parametro = 'Imagens da Empresa'
where t.id = @id

END

GO
/****** Object:  StoredProcedure [dbo].[REL_IMP_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jadson Sanches
-- Create date: 16/05/2018
-- Description:	Procedure de Vendas
-- =============================================
CREATE PROCEDURE [dbo].[REL_IMP_VENDA] 
	@id int
AS
BEGIN
	SELECT v.id as IdVenda,
	   v.datapedido as DataVenda,
	   v.NomeCliente,
	   ISNULL(V.NUMERO, 0) AS NrNFe,
	   c.CnpjCpf,	   
	   isnull(cast(c.Cod_Ant as varchar(50)), '' ) as CodAntCliente,
	   ISNULL(v.TotalDesconto, 0) as TotalDesconto,
	   (ISNULL(v.TotalValorST,0) + ISNULL(v.TotalValorIpi,0)) as TotalImpostos,
	   ISNULL(v.TotalFrete,0) as TotalFrete,
	   isnull(v.TotalNFe,0) as TotalNFe,
	   isnull(v.TotalLiquido,0) as TotalLiquido,

	   vi.Qtde,
	   vi.ValorUnitario,
	   vi.TotalItem,
	   
	   p.Codigo,
	   p.Descricao,

	   (case when isnull(c.endereco,'') = '' then '' else isnull(c.cep,'') + '  ' +  isnull(c.endereco,'') + ', ' + isnull(c.Numero,'') + ' - ' + isnull(c.Bairro,'') + ' - ' + isnull(c.Cidade,'') + '/' + isnull(c.Estado,'') end) as EndCliente,
	   cast(isnull((select distinct ' -' + PessoaContatos.Valor from PessoaContatos
	   where (PessoaContatos.Tipo like '%FONE%' or PessoaContatos.Tipo like '%CELULAR%')
	   and c.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> ''
	   for xml path ('')), '') as varchar(200)) as FoneCliente,

	   e.nome as NomeEpresa,
	   e.Fantasia as FantasiaEmpresa,
	   e.CnpjCpf as DocEmpresa,
	   e.endereco + ', ' + e.Numero + ' - ' + e.Bairro + ' - ' + e.Cidade + '/' + e.Estado as EndEmpresa,
	   e.Fone as FoneEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%MAIL' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as EmailEmpresa,
	   (select top 1 PessoaContatos.Valor from PessoaContatos 
	   where PessoaContatos.Tipo like '%SITE' 
	   and e.id = PessoaContatos.PessoaId
	   and isnull(PessoaContatos.Valor,'') <> '') as SiteEmpresa,

	   U.Nome as NomeUsuario,

	   co.logoRelEmpresa as logotipo,
	   fr.Descricao as FormaPagamento,
	   (select count(VendaServicos.Id) from VendaServicos where VendaServicos.VendaId = v.Id) as QtdeServicos,
	   (select count(Titulo.Id) from Titulo where Titulo.VendaId = v.Id) as QtdeCondicoes,
	   convert(varchar(200), v.NrTalao) as NrTalao,
	   v.obs
	   
FROM Venda V 
     INNER JOIN Pessoa E on V.EmpresaId = e.Id 
     LEFT JOIN VendaItens VI on V.Id = vi.VendaId 
	 LEFT OUTER JOIN Pessoa C on V.ClienteId  = c.id
	 LEFT JOIN Produto P on VI.ProdutoId = P.Id
	 LEFT JOIN Usuario U on v.vendedorid = u.id
	 LEFT JOIN Config CO on CO.EmpresaId = v.EmpresaId and Co.Parametro = 'Imagens da Empresa'
	 LEFT JOIN FormaPagamento FR ON v.FormaId = FR.Id   
where v.id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[REL_PAGAMENTO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		BRUNO HENRIQUE
-- Create date: 20/05/2024
-- Description:	TAREFA 92787
-- =============================================
CREATE PROCEDURE [dbo].[REL_PAGAMENTO]
	-- Add the parameters for the stored procedure here
	@Ini Datetime,
	@Fim Datetime
AS
BEGIN
	SELECT  SUM(ISNULL(LB.ValorLiquido, 0)) AS VALOR,
			convert(datetime, '01/' + CAST(MONTH(LB.datalancto) AS varchar(10)) + '/' + 
			CAST(YEAR(LB.datalancto) AS varchar(10)), 103) AS PERIODO
	  FROM LancamentoBancario LB
	 WHERE LB.Tipo = 'D'
	   AND LB.datalancto >= @Ini
	   AND LB.datalancto < @Fim
	GROUP BY '01/' + CAST(MONTH(LB.datalancto) AS varchar(10)) + '/' + CAST(YEAR(LB.datalancto) AS varchar(10))
END
GO
/****** Object:  StoredProcedure [dbo].[REL_REC_LIQUIDO_PERIODO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		LAURO JUNIOR
-- Create date: 28/05/2020
-- Description:	RECEBIMENTO LIQUIDO
-- =============================================

CREATE PROCEDURE [dbo].[REL_REC_LIQUIDO_PERIODO]
	@Emp int,
	@DtIni DateTime,
	@DtFim DateTime
WITH RECOMPILE
AS
BEGIN
   
	SELECT     (lb.Valor - isnull(lb.desconto,0)) as Valor,
	       V.DataPedido,
		   V.Id,
		   C.Nome,
		   V.TotalLiquido,
		   CONVERT(DateTime,LB.DataLancto) DataLancto,
		   (SELECT LogoRelEmpresa FROM CONFIG WHERE EmpresaId = @EMP AND Parametro = 'Imagens da Empresa') LOGOTIPO ,
		   Isnull(V.freteml,0) + ISNULL((SELECT SUM(ISNULL(TARIFAML,0)) FROM VENDAITENS VI WHERE VI.VENDAID = V.ID)    ,0) AS Deducoes
      FROM LancamentoBancario LB INNER JOIN Titulo T on LB.TituloId = T.Id 
INNER JOIN Venda V on T.VendaId = V.Id
INNER JOIN PESSOA C ON V.ClienteId = C.Id 
     WHERE LB.Conciliado = 1
	   AND LB.TIPO = 'C'
	   AND LB.EmpresaId = @Emp 
	   AND V.EntSai = 'S'
	   AND V.Status IN ('NFe-APROVADA', 'FATURADA')
	   AND ISNULL(v.descricaocenario,'') LIKE '%VENDA DE MERCADORIA%'
	   AND LB.DataLancto >= @DtIni
	   AND LB.DataLancto <= @DtFim

ORDER BY lb.DataConciliacao,v.DataPedido    

END




GO
/****** Object:  StoredProcedure [dbo].[REL_SEPARACAO]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REL_SEPARACAO]
	@IdVenda Int
AS
BEGIN
	SELECT V.ID,
	   R.Numero,
	   E.NOME + '- CNPJ:' + E.CNPJCPF,
	   C.FANTASIA,
	   C.CNPJCPF,
	   R.Tipo,
	   V.DATAPEDIDO,
	   V.DATASAIDA,
	   VI.QTDE,
	   P.CODIGO,
	   P.DESCRICAO,
	   P.ARMAZENAMENTO,
	   P.UM,
	   CASE WHEN ISNULL(PESOREF,0) >0 THEN
	   	   CONVERT(VARCHAR(10),CONVERT(INT,(( ROUND((VI.QTDE / ISNULL(PESOREF,1) ),2))))) + ' PC'
	   ELSE
			''
	   END  AS QTDEPC,
	   V.ObsSeparacao
	FROM VENDA V INNER JOIN ROMANEIO R ON V.RomaneioId = R.ID
	INNER JOIN PESSOA E ON V.EmpresaId = E.ID
	INNER JOIN PESSOA C ON V.CLIENTEID = C.ID
	INNER JOIN VENDAITENS VI ON VI.VENDAID = V.ID
	INNER JOIN PRODUTO P ON VI.PRODUTOID = P.ID
	WHERE V.ID = @IdVenda
	ORDER BY P.ARMAZENAMENTO
END
GO
/****** Object:  StoredProcedure [dbo].[REL_VENDA]    Script Date: 22/08/2025 10:23:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		BRUNO HENRIQUE
-- Create date: 21/02/2024
-- Description:	TAREFA 91411
-- =============================================
CREATE PROCEDURE [dbo].[REL_VENDA] 
	-- Add the parameters for the stored procedure here	
	@Ini Datetime,
	@Fim Datetime
AS
BEGIN
    -- Insert statements for procedure here
	SELECT  'PRODUTOS' AS CAMPO,
	        SUM(ISNULL(QTDE, 0) * ISNULL(VALORUNITARIO, 0)) AS VALOR,
			convert(datetime, '01/' + CAST(MONTH(V.DATAPEDIDO) AS varchar(10)) + '/' + CAST(YEAR(V.DATAPEDIDO) AS varchar(10)), 103) AS PERIODO
	  FROM VENDA V INNER JOIN VENDAITENS VI ON V.ID = VI.VENDAID
	INNER JOIN CENARIOFISCAL CF ON VI.CENARIOID = CF.ID	
	 WHERE V.ENTSAI = 'S'
	   AND (V.STATUS = 'NFe-APROVADA' OR V.STATUS = 'FATURADA')
	   AND V.DATAPEDIDO >= @Ini
	   AND V.DATAPEDIDO < @Fim
	   AND ISNULL(CF.DEVOLUCAO,0) = 0
	GROUP BY '01/' + CAST(MONTH(V.DATAPEDIDO) AS varchar(10)) + '/' + CAST(YEAR(V.DATAPEDIDO) AS varchar(10))

	UNION ALL
	SELECT  'SERVICOS' AS CAMPO,
	        SUM(ISNULL(VI.Valor, 0)) AS VALOR,
			convert(datetime, '01/' + CAST(MONTH(V.DATAPEDIDO) AS varchar(10)) + '/' + CAST(YEAR(V.DATAPEDIDO) AS varchar(10)), 103) AS PERIODO
	  FROM VENDA V INNER JOIN VendaServicos  VI ON V.ID = VI.VENDAID
	 WHERE V.ENTSAI = 'S'
	   AND (V.STATUS = 'NFe-APROVADA' OR V.STATUS = 'FATURADA')
	   AND V.DATAPEDIDO >= @Ini
	   AND V.DATAPEDIDO < @Fim	   
	GROUP BY '01/' + CAST(MONTH(V.DATAPEDIDO) AS varchar(10)) + '/' + CAST(YEAR(V.DATAPEDIDO) AS varchar(10))
END
GO
USE [master]
GO
ALTER DATABASE [Solutec] SET  READ_WRITE 
GO
