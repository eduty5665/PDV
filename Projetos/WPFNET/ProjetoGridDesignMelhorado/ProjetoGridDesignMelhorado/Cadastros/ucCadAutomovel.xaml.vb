Public Class ucCadAutomovel
    Dim objVeiculo As Veiculos
    Dim objAbastecimento As New Abastecimento
    Dim srcAbastecimento As CollectionViewSource
    Dim srcVeiculos As CollectionViewSource
    Dim lstVeiculos As List(Of Veiculos)
    Dim Verificar As Boolean

#Region "Construtores - SUB"
    Dim CollectionViewSource As Object

    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
#End Region

#Region "Metodos - SUB"
    Private Sub LimpaCamposVeiculo()
        Placatxt.Text = ""
        Desctxt.Text = ""
        Combcmb.Text = ""
        UltKMtxt.Text = ""
        ValorComptxt.Text = ""
        DataComptxt.Text = ""
        TipoCompcmb.Text = ""
        DataAbasttxt.Text = ""
        KMAbasttxt.Text = ""
        QtdLittxt.Text = ""
        ValorTottxt.Text = ""
        srcAbastecimento.Source = Nothing
        objVeiculo = Nothing
        Placatxt.Focus()
    End Sub

    Private Sub LimpaCamposAbast()
        DataAbasttxt.Text = ""
        KMAbasttxt.Text = ""
        QtdLittxt.Text = ""
        ValorTottxt.Text = ""
        objAbastecimento = Nothing
        DataAbasttxt.Focus()
    End Sub

    Private Function ValidaCampos() As Boolean
        If Not IsDate(DataAbasttxt.Text) Then
            MsgBox("Data de Abastecimento não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            DataAbasttxt.Focus()
            Return False
        ElseIf CFG.RetornaVrPadrao(KMAbasttxt.Text) = 0 Then
            MsgBox("Kilometragem não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            KMAbasttxt.Focus()
            Return False
        ElseIf CFG.RetornaVrPadrao(QtdLittxt.Text) = 0 Then
            MsgBox("Quantidade de Litros não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            QtdLittxt.Focus()
            Return False
        ElseIf CFG.RetornaVrPadrao(ValorTottxt.Text) = 0 Then
            MsgBox("Valor Total não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            ValorTottxt.Focus()
            Return False
        End If


        If objAbastecimento Is Nothing Then
            objAbastecimento = New Abastecimento
        End If

        If lstVeiculos Is Nothing Then
            lstVeiculos = New List(Of Veiculos)
        End If

        If objVeiculo Is Nothing Then
            objVeiculo = New Veiculos
        End If
        Return True
    End Function

    Private Function SalvarVeiculos(ByRef retorno As String) As Boolean
        retorno = "1-ValidaçaoCampos"
        If Placatxt.Text = "" Then
            MsgBox("Placa do Veiculo não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Placatxt.Focus()
            Return False
        ElseIf Desctxt.Text = "" Then
            MsgBox("Descrição não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Desctxt.Focus()
            Return False
        ElseIf Not IsDate(Datatxt.Text) Then
            MsgBox("Data não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Datatxt.Focus()
            Return False
        End If

        If objVeiculo Is Nothing Then
            objVeiculo = New Veiculos()
        End If
        If objVeiculo.Abastecimento Is Nothing Then
            objVeiculo.Abastecimento = New List(Of Abastecimento)
        End If

        retorno = "3-GravaCampos"
        objVeiculo.Placa = Placatxt.Text
        objVeiculo.Descricao = Desctxt.Text
        objVeiculo.Combustivel = Combcmb.Text
        objVeiculo.UltimoKM = CFG.RetornaVrPadrao(UltKMtxt.Text)
        objVeiculo.ValorCompra = CFG.RetornaVrPadrao(ValorComptxt.Text)
        objVeiculo.DateCompra = DataComptxt.Text
        objVeiculo.TipoPagCompra = TipoCompcmb.Text

        retorno = "5-GravaçãoConcluida"
        Return True
    End Function

#End Region

#Region "Eventos Buttons - SUB"
    Private Sub MaisBtn_Click(sender As Object, e As RoutedEventArgs) Handles MaisBtn.Click
        Dim retorno As String = ""
        Try
            If ValidaCampos() = False Then
                Exit Sub
            End If

            If objVeiculo.Abastecimento Is Nothing Then
                objVeiculo.Abastecimento = New List(Of Abastecimento)
            End If

            If objAbastecimento Is Nothing Then
                objAbastecimento = New Abastecimento
            End If

            objAbastecimento.DataAbast = DataAbasttxt.Text
            objAbastecimento.KMVeiculo = CFG.RetornaVrPadrao(KMAbasttxt.Text)
            objAbastecimento.Litros = CFG.RetornaVrPadrao(QtdLittxt.Text)
            objAbastecimento.ValorTotal = CFG.RetornaVrPadrao(ValorTottxt.Text)

            objVeiculo.Abastecimento.Add(objAbastecimento)

            Dim mensagem As String = "Abastecimento salvo com sucesso! "
            MsgBox(mensagem, MsgBoxStyle.Information, "Parabens!")

            srcAbastecimento.Source = Nothing
            srcAbastecimento.Source = objVeiculo.Abastecimento.ToList

            LimpaCamposAbast()

        Catch ex As Exception
            MsgBox(retorno & vbNewLine & "Ocorreu um erro no sistema, entre em contato com a SIZEX!" & vbNewLine & "(" & ex.Message & ")", MsgBoxStyle.Critical, "Gravar Abastecimento")
        End Try

    End Sub

    Private Sub MenosBtn_Click(sender As Object, e As RoutedEventArgs) Handles MenosBtn.Click
        If objVeiculo.Abastecimento IsNot Nothing AndAlso objAbastecimento IsNot Nothing Then
            objVeiculo.Abastecimento.Remove(objAbastecimento)

            Dim msgSucessDel As String = "Contato excluido com sucesso! "
            MsgBox(msgSucessDel, MsgBoxStyle.Information, "Exclusão de Contato")

            srcAbastecimento.Source = Nothing
            srcAbastecimento.Source = objVeiculo.Abastecimento.ToList
        Else
            Dim msgErrorDel As String = "Nenhum contato selecionado para exclusão! "
            MsgBox(msgErrorDel, MsgBoxStyle.Information, "Exclusão de Contato")
        End If

        LimpaCamposAbast()
    End Sub

    Private Sub SalvarBtn_Click(sender As Object, e As RoutedEventArgs) Handles SalvarBtn.Click
        Dim retorno As String = ""
        Try
            If SalvarVeiculos(retorno) = False Then
                Exit Sub
            End If

            If lstVeiculos Is Nothing Then
                lstVeiculos = New List(Of Veiculos)
            End If
            lstVeiculos.Add(objVeiculo)

            srcVeiculos.Source = Nothing
            srcVeiculos.Source = lstVeiculos

            MsgBox("Registro salvo com sucesso", MsgBoxStyle.Information, "Parabens!")

            LimpaCamposVeiculo()

        Catch ex As Exception
            MsgBox("Ocorreu um erro no sistema, entre em contato com a SIZEX!" & vbNewLine & "(" & ex.Message & ")", MsgBoxStyle.Critical, "Gravar Abastecimento")
        End Try

    End Sub

    Private Sub ExcluirBtn_Click(sender As Object, e As RoutedEventArgs) Handles ExcluirBtn.Click
        LimpaCamposVeiculo()
        LimpaCamposAbast()
    End Sub

    Private Sub NovoBtn_Click(sender As Object, e As RoutedEventArgs) Handles NovoBtn.Click
        LimpaCamposVeiculo()
    End Sub

    Private Sub Window_KeyDown(sender As Object, e As KeyEventArgs)
        Select Case e.Key
            Case Key.F2
                NovoBtn_Click(Nothing, Nothing)
            Case Key.F3
                SalvarBtn_Click(Nothing, Nothing)
            Case Key.F4
                ExcluirBtn_Click(Nothing, Nothing)
            Case Key.F6
                If PesLbl.Content = "Pesquisa (Descrição):" Then
                    PesLbl.Content = "Pesquisa (Placa):"
                ElseIf PesLbl.Content = "Pesquisa (Placa):" Then
                    PesLbl.Content = "Pesquisa (Combustível):"
                ElseIf PesLbl.Content = "Pesquisa (Combustível):" Then
                    PesLbl.Content = "Pesquisa (Descrição):"
                End If
                'Case Key.Escape
                '    SairBtn_Click(Nothing, Nothing)
        End Select
    End Sub

    Private Sub PesTxt_TextChanged(sender As Object, e As TextChangedEventArgs) Handles PesTxt.TextChanged
        If lstVeiculos IsNot Nothing AndAlso lstVeiculos.Count > 0 Then
            If PesLbl.Content = "Pesquisa (Descrição):" Then
                srcVeiculos.Source = lstVeiculos.Where(Function(p) p.Descricao.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Placa):" Then
                srcVeiculos.Source = lstVeiculos.Where(Function(p) p.Placa.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Combustivel):" Then
                srcVeiculos.Source = lstVeiculos.Where(Function(p) p.Combustivel.Contains(PesTxt.Text)).ToList
            Else
                MsgBox("Nenhum cadastro realizado, por favor verificar.", MsgBoxStyle.Information, "Erro Cadastro")

            End If
        End If
    End Sub

    Private Sub PesLbl_MouseDoubleClick(sender As Object, e As MouseButtonEventArgs) Handles PesLbl.MouseDoubleClick
        If PesLbl.Content = "Pesquisa (Descrição):" Then
            PesLbl.Content = "Pesquisa (Placa):"
        ElseIf PesLbl.Content = "Pesquisa (Placa):" Then
            PesLbl.Content = "Pesquisa (Combustível):"
        ElseIf PesLbl.Content = "Pesquisa (Combustível):" Then
            PesLbl.Content = "Pesquisa (Descrição):"
        End If
    End Sub
#End Region

#Region "Chamadas de Telas - SUB"
    Private Sub ucCadAutomovel(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
        Verificar = True
        If Verificar Then
            srcAbastecimento = CType(Me.FindResource("AbastecimentoViewSource"), CollectionViewSource)
            srcVeiculos = CType(Me.FindResource("VeiculosViewSource"), CollectionViewSource)
        End If

        'If objVeiculo.lstVeiculos Is Nothing Then
        '    objVeiculo.lstVeiculos = New List(Of Veiculos)
        'End If
        Datatxt.Text = Date.Now
    End Sub

    Private Sub SaiBtn_Click(sender As Object, e As RoutedEventArgs) Handles SaiBtn.Click
        CFG.DestroiTela(Me)
    End Sub
#End Region
    
End Class
