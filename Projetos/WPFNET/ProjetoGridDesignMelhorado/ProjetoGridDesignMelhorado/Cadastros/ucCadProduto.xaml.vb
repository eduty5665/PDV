Public Class ucCadProduto
    Dim objProduto As New Produto
    Dim srcProdutos As CollectionViewSource
    Dim objExibe As ExibirProd

#Region "Construtores - SUB"
    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
#End Region

#Region "Metodos - SUB"
    Private Sub LimpaCamposProduto()
        If objProduto.ExibirProd.Count > 0 Then
            Codigotxt.Text = objProduto.ExibirProd.Select(Function(p) p.Codigo).Max + 1
        Else
            Codigotxt.Text = 1
        End If
        Desctxt.Text = ""
        Grupotxt.Text = ""
        Tipocmb.Text = ""
        Custotxt.Text = "0,00"
        Margemtxt.Text = "0,00"
        Precotxt.Text = "0,00"
        Statuschk.IsChecked = False
        Codigotxt.Focus()
    End Sub

    Private Function SalvaCampos() As Boolean
        If CFG.RetornaVrPadrao(Codigotxt.Text) = 0 Then
            MsgBox("Codigo não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Codigotxt.Focus()
            Return False
        ElseIf Desctxt.Text = "" Then
            MsgBox("Descrição não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Desctxt.Focus()
            Return False
        ElseIf Not IsDate(Datatxt.Text) Then
            MsgBox("Data não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Datatxt.Focus()
            Return False
        ElseIf CFG.RetornaVrPadrao(Precotxt.Text) = 0 Then
            MsgBox("Preço não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Precotxt.Focus()
            Return False
        ElseIf Tipocmb.Text = "" Then
            MsgBox("Tipo do Produto não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Tipocmb.Focus()
            Return False
        End If

        If objProduto Is Nothing Then
            objProduto = New Produto
        End If

        objProduto.Codigo = CInt(Codigotxt.Text)
        objProduto.Descricao = UCase(Desctxt.Text)
        objProduto.Data = Datatxt.Text
        objProduto.Grupo = UCase(Grupotxt.Text)
        objProduto.Tipo = Tipocmb.Text
        objProduto.Custo = CFG.RetornaVrPadrao(Custotxt.Text)
        objProduto.Margem = CFG.RetornaVrPadrao(Margemtxt.Text)
        objProduto.Preco = CDbl(Precotxt.Text)
        objProduto.Status = Statuschk.IsChecked

        Return True
    End Function
#End Region

#Region "Eventos Buttons - SUB"

    Private Sub SalvarBtn_Click(sender As Object, e As RoutedEventArgs) Handles SalvarBtn.Click

        If SalvaCampos() = False Then
            Exit Sub
        End If

        MsgBox("Registro salvo com sucesso", MsgBoxStyle.Information, "Parabens!")

        Dim objExibe As New ExibirProd
        objExibe.Codigo = CInt(Codigotxt.Text)
        objExibe.Descricao = UCase(Desctxt.Text)
        objExibe.Tipo = UCase(Tipocmb.Text)
        objExibe.Grupo = UCase(Grupotxt.Text)
        objExibe.Custo = CDbl(Custotxt.Text)
        objExibe.Preco = CDbl(Precotxt.Text)

        If objProduto.ExibirProd Is Nothing Then
            objProduto.ExibirProd = New List(Of ExibirProd)
        End If

        objProduto.ExibirProd.Add(objExibe)
        srcProdutos.Source = objProduto.ExibirProd.ToList

        LimpaCamposProduto()
    End Sub

    Private Sub ExcluirBtn_Click(sender As Object, e As RoutedEventArgs) Handles ExcluirBtn.Click
        If objProduto.ExibirProd IsNot Nothing AndAlso objProduto IsNot Nothing Then
            objProduto.ExibirProd.Remove(objExibe)

            Dim msgSucessDel As String = "Contato excluido com sucesso! " & vbNewLine & "Total de Registros: " & objProduto.ExibirProd.Count
            MsgBox(msgSucessDel, MsgBoxStyle.Information, "Exclusão de Contato")

            srcProdutos.Source = Nothing
            srcProdutos.Source = objProduto.ExibirProd.ToList
        Else
            Dim msgErrorDel As String = "Nenhum contato selecionado para exclusão! " & vbNewLine & "Total de Registros: " & objProduto.ExibirProd.Count
            MsgBox(msgErrorDel, MsgBoxStyle.Information, "Exclusão de Contato")
        End If
        LimpaCamposProduto()
    End Sub

    Private Sub NovoBtn_Click(sender As Object, e As RoutedEventArgs) Handles NovoBtn.Click
        LimpaCamposProduto()
    End Sub

    Private Sub ProdGrid_MouseDoubleClick(sender As Object, e As MouseButtonEventArgs) Handles ProdGrid.MouseDoubleClick
        If sender.selectedItem IsNot Nothing Then
            objExibe = CType(sender.selectedItem, ExibirProd)
            Codigotxt.Text = objExibe.Codigo
            Desctxt.Text = objExibe.Descricao
            Grupotxt.Text = objExibe.Grupo
            Custotxt.Text = objExibe.Custo
            Precotxt.Text = objExibe.Preco
        End If
    End Sub

    Private Sub Window_KeyDown_1(sender As Object, e As KeyEventArgs)
        Select Case e.Key
            Case Key.F2
                NovoBtn_Click(Nothing, Nothing)
            Case Key.F3
                SalvarBtn_Click(Nothing, Nothing)
            Case Key.F4
                ExcluirBtn_Click(Nothing, Nothing)
            Case Key.F6
                If PesLbl.Content = "Pesquisa (Descrição):" Then
                    PesLbl.Content = "Pesquisa (Codigo):"
                ElseIf PesLbl.Content = "Pesquisa (Codigo):" Then
                    PesLbl.Content = "Pesquisa (Grupo):"
                ElseIf PesLbl.Content = "Pesquisa (Grupo):" Then
                    PesLbl.Content = "Pesquisa (Tipo):"
                ElseIf PesLbl.Content = "Pesquisa (Tipo):" Then
                    PesLbl.Content = "Pesquisa (Preço):"
                ElseIf PesLbl.Content = "Pesquisa (Preço):" Then
                    PesLbl.Content = "Pesquisa (Descrição):"
                End If
            Case Key.Escape
                SairBtn_Click(Nothing, Nothing)
        End Select
    End Sub

    Private Sub Precotxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles Precotxt.LostFocus
        If Custotxt.Text And Precotxt.Text IsNot Nothing Then
            If IsNumeric(Custotxt.Text And Precotxt.Text) Then
                Margemtxt.Text = CFG.FormataMargem(CDbl(Custotxt.Text), CDbl(Precotxt.Text))
            Else
                MsgBox("Erro! Necessita adicionar valor de custo e valor de preco.")
            End If
        End If
    End Sub

    Private Sub Margemtxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles Margemtxt.LostFocus
        If Custotxt.Text And Margemtxt.Text IsNot Nothing Then
            If IsNumeric(Custotxt.Text And Margemtxt.Text) Then
                Precotxt.Text = CFG.FormataPreco(CDbl(Custotxt.Text), CDbl(Margemtxt.Text))
            Else
                MsgBox("Erro! Necessita adicionar valor de custo e margem de lucro.")
            End If
        End If
    End Sub

    Private Sub Custotxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles Custotxt.LostFocus
        Custotxt.Text = Math.Round(CDbl(Custotxt.Text), 2)
    End Sub

    Private Sub PesTxt_TextChanged(sender As Object, e As TextChangedEventArgs) Handles PesTxt.TextChanged
        If objProduto.ExibirProd.Count > 0 Then
            If PesLbl.Content = "Pesquisa (Descrição):" Then
                srcProdutos.Source = objProduto.ExibirProd.Where(Function(p) p.Descricao.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Codigo):" Then
                srcProdutos.Source = objProduto.ExibirProd.Where(Function(p) p.Codigo.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Grupo):" Then
                srcProdutos.Source = objProduto.ExibirProd.Where(Function(p) p.Grupo.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Tipo):" Then
                srcProdutos.Source = objProduto.ExibirProd.Where(Function(p) p.Tipo.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Preço):" Then
                srcProdutos.Source = objProduto.ExibirProd.Where(Function(p) p.Preco.Contains(PesTxt.Text)).ToList
            Else
                MsgBox("Nenhum cadastro realizado, por favor verificar.", MsgBoxStyle.Information, "Erro Cadastro")

            End If
        End If
    End Sub

    Private Sub SairBtn_Click(sender As Object, e As RoutedEventArgs) Handles SairBtn.Click
        CFG.DestroiTela(Me)
    End Sub

    Private Sub PesLbl_MouseDoubleClick(sender As Object, e As MouseButtonEventArgs) Handles PesLbl.MouseDoubleClick
        If PesLbl.Content = "Pesquisa (Descrição):" Then
            PesLbl.Content = "Pesquisa (Codigo):"
        ElseIf PesLbl.Content = "Pesquisa (Codigo):" Then
            PesLbl.Content = "Pesquisa (Grupo):"
        ElseIf PesLbl.Content = "Pesquisa (Grupo):" Then
            PesLbl.Content = "Pesquisa (Tipo):"
        ElseIf PesLbl.Content = "Pesquisa (Tipo):" Then
            PesLbl.Content = "Pesquisa (Preço):"
        ElseIf PesLbl.Content = "Pesquisa (Preço):" Then
            PesLbl.Content = "Pesquisa (Descrição):"
        End If
    End Sub

#End Region

#Region "Chamada de Tela - SUB"
    Private Sub ucCadProduto(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
        srcProdutos = CType(Me.FindResource("ProdutosViewSource"), CollectionViewSource)
        Datatxt.Text = Date.Now
        Codigotxt.Text = 1
    End Sub
#End Region

End Class



