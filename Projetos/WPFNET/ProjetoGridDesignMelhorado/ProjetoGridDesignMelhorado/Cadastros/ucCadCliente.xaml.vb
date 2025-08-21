Public Class ucCadCliente
    Dim objCliente As Cliente
    Dim srcContatos As CollectionViewSource
    Dim srcCliente As CollectionViewSource
    Dim objContato As ClienteContatos
    Dim lstClientes As List(Of Cliente)
    Dim Verificar As Boolean

#Region "Construtores - SUB"
    Public Sub New()

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Public Sub New(tipo As String)

        ' This call is required by the designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        If tipo = "C" Then
            Titlelbl.Content = "- Cadastro de Clientes"
        Else
            'TabItem.NameProperty.Name = "Fornecedores"
            Titlelbl.Content = "- Cadastro de Fornecedores"
            FotoCt.Visibility = Windows.Visibility.Collapsed
            CPFLbl.Content = "CNPJ"
            CPFPes.Header = "CNPJ"
            NomePes.Header = "Nome do Fornecedor"
            CFG.FormataCNPJ("F", CPFtxt.Text)
            RGLbl.Visibility = Windows.Visibility.Hidden
            RGtxt.Visibility = Windows.Visibility.Hidden
        End If
    End Sub
#End Region

#Region "Métodos - SUB"
    Private Sub LimpaCampos(tipo As String)
        If tipo = "C" Or tipo = "T" Then
            Datatxt.Text = ""
            CPFtxt.Text = ""
            RGtxt.Text = ""
            Nometxt.Text = ""
            Statuschk.IsChecked = False
            Endtxt.Text = ""
            NumEndtxt.Text = ""
            BairroEndtxt.Text = ""
            CidEndtxt.Text = ""
            EstEndcmb.Text = ""
            CompEndtxt.Text = ""
            CEPEndtxt.Text = ""
            objCliente = Nothing
            srcContatos.Source = Nothing
            CPFtxt.Focus()
        End If
        If tipo = "CT" Or tipo = "T" Then
            Contatotxt.Text = ""
            OBSConttxt.Text = ""
            TipoContcmb.Text = ""
            objContato = Nothing
            Contatotxt.Focus()
        End If
    End Sub
    Private Function SalvarCliente(Optional ByRef retorno As String = "") As Boolean
        retorno = "1-ValidaCampos"
        If Nometxt.Text = "" Then
            MsgBox("Nome não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Nometxt.Focus()
            Return False
        ElseIf CPFtxt.Text = "" Then
            MsgBox("CPF não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            CPFtxt.Focus()
            Return False
        ElseIf Not IsDate(Datatxt.Text) Then
            MsgBox("Data não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Datatxt.Focus()
            Return False
        End If

        retorno = "2-Preenche Campos"
        If objCliente Is Nothing Then
            objCliente = New Cliente
            objCliente.Contatos = New List(Of ClienteContatos)
        End If

        retorno = "3-GravaCampos"
        'Dim objCliente As New Cliente
        objCliente.DataCad = Datatxt.Text
        objCliente.CPF = CPFtxt.Text
        objCliente.RG = RGtxt.Text
        objCliente.Nome = Nometxt.Text
        objCliente.Status = Statuschk.IsChecked
        objCliente.Endereco = Endtxt.Text
        objCliente.Numero = CFG.RetornaVrPadrao(NumEndtxt.Text)
        objCliente.Bairro = BairroEndtxt.Text
        objCliente.Cidade = CidEndtxt.Text
        objCliente.Estado = EstEndcmb.Text
        objCliente.Complemento = CompEndtxt.Text
        objCliente.CEP = CFG.RetornaVrPadrao(CEPEndtxt.Text)

        objCliente.Usuario = InputBox("Informe seu nome para gravação do cliente", "Auditoria", "")
        objCliente.DataGravacao = Date.Now

        retorno = "5-Gravação Concluida"

        Return True
    End Function

    Private Function ValidaCampos(Optional ByRef retorno As String = "") As Boolean
        retorno = "1-ValidaçãoCampos"
        If Nometxt.Text = "" Then
            MsgBox("Nome não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Nometxt.Focus()
            Return False
        ElseIf CPFtxt.Text = "" Then
            MsgBox("CPF não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            CPFtxt.Focus()
            Return False
        ElseIf Not IsDate(Datatxt.Text) Then
            MsgBox("Data não informada, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Datatxt.Focus()
            Return False
        ElseIf Contatotxt.Text = "" Then
            MsgBox("Contato não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            Contatotxt.Focus()
            Return False
        ElseIf OBSConttxt.Text = "" Then
            MsgBox("Observação de Contato não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            OBSConttxt.Focus()
            Return False
        ElseIf TipoContcmb.Text = "" Then
            MsgBox("Tipo de Contato não informado, verifique!", MsgBoxStyle.Exclamation, "Validação")
            TipoContcmb.Focus()
            Return False
        End If

        retorno = "2-ValidaçãoConcluida"

        Return True
    End Function
#End Region

#Region "Eventos Buttons - SUB"
    Private Sub MaisBtn_Click(sender As Object, e As RoutedEventArgs) Handles MaisBtn.Click
        Dim retorno As String = ""

        If objCliente Is Nothing Then
            objCliente = New Cliente
            objCliente.Contatos = New List(Of ClienteContatos)
        ElseIf objCliente.Contatos Is Nothing Then
            objCliente.Contatos = New List(Of ClienteContatos)
        End If

        Try
            If ValidaCampos(retorno) = False Then
                Exit Sub
            End If

            retorno = "Salvar dados contato"

            If lstClientes Is Nothing Then
                lstClientes = New List(Of Cliente)
            End If

            If objContato Is Nothing Then
                objContato = New ClienteContatos
            End If

                objContato.Contato = Contatotxt.Text
                objContato.Observacao = OBSConttxt.Text
                objContato.Tipo = TipoContcmb.Text

                objCliente.Contatos.Add(objContato)

                Dim msgSucessContat As String = "Contato salvo com sucesso! "
                MsgBox(msgSucessContat, MsgBoxStyle.Information, "Gravação de Contatos")

                retorno = "Criação de Lista"
                srcContatos.Source = Nothing
                srcContatos.Source = objCliente.Contatos.ToList

                LimpaCampos("CT")

        Catch ex As Exception
            MsgBox(retorno & vbNewLine & "Ocorreu um erro no sistema, entre em contato com a SIZEX!" & vbNewLine & "(" & ex.Message & ")", MsgBoxStyle.Critical, "Gravar Cliente")
        End Try

    End Sub

    Private Sub MenosBtn_Click(sender As Object, e As RoutedEventArgs) Handles MenosBtn.Click
        If objCliente.Contatos IsNot Nothing AndAlso objContato IsNot Nothing Then
            objCliente.Contatos.Remove(objContato)

            Dim msgSucessDel As String = "Contato excluido com sucesso! "
            MsgBox(msgSucessDel, MsgBoxStyle.Information, "Exclusão de Contato")

            srcContatos.Source = Nothing
            srcContatos.Source = objCliente.Contatos.ToList
        Else
            Dim msgErrorDel As String = "Nenhum contato selecionado para exclusão! "
            MsgBox(msgErrorDel, MsgBoxStyle.Information, "Exclusão de Contato")
        End If

        LimpaCampos("CT")
    End Sub

    Private Sub SalvarBtn_Click(sender As Object, e As RoutedEventArgs) Handles SalvarBtn.Click
        Dim retorno As String = ""
        Try
            'Dim objCliente As New Cliente
            If SalvarCliente(retorno) = False Then
                Exit Sub
            End If

            retorno = "Criação de Lista"
            If lstClientes Is Nothing Then
                lstClientes = New List(Of Cliente)
            End If
            lstClientes.Add(objCliente)

            srcCliente.Source = Nothing
            srcCliente.Source = lstClientes

            Dim msgSucessCli As String = "Cliente salvo com sucesso! "
            MsgBox(msgSucessCli, MsgBoxStyle.Information, "Gravação de Clientes")

            LimpaCampos("T")
        Catch ex As Exception
            MsgBox(retorno & vbNewLine & "Ocorreu um erro no sistema, entre em contato com a SIZEX!" & vbNewLine & "(" & ex.Message & ")", MsgBoxStyle.Critical, "Gravar Cliente")
        End Try


    End Sub

    Private Sub NovoBtn_Click(sender As Object, e As RoutedEventArgs) Handles NovoBtn.Click
        LimpaCampos("T")
    End Sub

    Private Sub ExcluirBtn_Click(sender As Object, e As RoutedEventArgs) Handles ExcluirBtn.Click
        LimpaCampos("T")
    End Sub
    Private Sub DataGrid_MouseDoubleClick(sender As Object, e As MouseButtonEventArgs) Handles ContatosDataGrid.MouseDoubleClick
        If sender.selectedItem IsNot Nothing Then
            objContato = CType(sender.selectedItem, ClienteContatos)
            Contatotxt.Text = objContato.Contato
            OBSConttxt.Text = objContato.Observacao
            TipoContcmb.Text = objContato.Tipo
        End If
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
                If PesLbl.Content = "Pesquisa (Nome):" Then
                    PesLbl.Content = "Pesquisa (CPF):"
                ElseIf PesLbl.Content = "Pesquisa (CPF):" Then
                    PesLbl.Content = "Pesquisa (Endereço):"
                ElseIf PesLbl.Content = "Pesquisa (Endereço):" Then
                    PesLbl.Content = "Pesquisa (Nome):"
                End If
                'Case Key.Escape
                '    SairBtn_Click(Nothing, Nothing)
        End Select
    End Sub

    Private Sub CPFtxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles CPFtxt.LostFocus
        If Titlelbl.Content = "- Cadastro de Fornecedores" Then
            CPFtxt.Text = CFG.FormataCNPJ("F", CPFtxt.Text)
        Else
            CPFtxt.Text = CFG.FormataCPF(CPFtxt.Text)
        End If
    End Sub

    Private Sub RGtxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles RGtxt.LostFocus
        RGtxt.Text = CFG.FormataRG(RGtxt.Text)
    End Sub

    Private Sub Contatotxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles Contatotxt.LostFocus
        Contatotxt.Text = CFG.FormataTipoContato(Contatotxt.Text)
    End Sub

    Private Sub CEPEndtxt_LostFocus(sender As Object, e As RoutedEventArgs) Handles CEPEndtxt.LostFocus
        CEPEndtxt.Text = CFG.FormataCEP(CEPEndtxt.Text)
    End Sub

    Private Sub PesTxt_TextChanged(sender As Object, e As TextChangedEventArgs) Handles PesTxt.TextChanged
        If lstClientes.Count > 0 Then
            If PesLbl.Content = "Pesquisa (Nome):" Then
                srcCliente.Source = lstClientes.Where(Function(p) p.Nome.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (CPF):" Then
                srcCliente.Source = lstClientes.Where(Function(p) p.CPF.Contains(PesTxt.Text)).ToList
            ElseIf PesLbl.Content = "Pesquisa (Endereço):" Then
                srcCliente.Source = lstClientes.Where(Function(p) p.Endereco.Contains(PesTxt.Text)).ToList
            Else
                MsgBox("Nenhum cadastro realizado, por favor verificar.", MsgBoxStyle.Information, "Erro Cadastro")
            End If
        End If
    End Sub


    Private Sub SairBtn_Click(sender As Object, e As RoutedEventArgs) Handles SairBtn.Click
        CFG.DestroiTela(Me)
    End Sub

    Private Sub PesLbl_MouseDoubleClick(sender As Object, e As MouseButtonEventArgs) Handles PesLbl.MouseDoubleClick
        If PesLbl.Content = "Pesquisa (Nome):" Then
            PesLbl.Content = "Pesquisa (CPF):"
        ElseIf PesLbl.Content = "Pesquisa (CPF):" Then
            PesLbl.Content = "Pesquisa (Endereço):"
        ElseIf PesLbl.Content = "Pesquisa (Endereço):" Then
            PesLbl.Content = "Pesquisa (Nome):"
        End If
    End Sub
#End Region

#Region "Chamada de Telas - SUB"
    Private Sub ucCadCliente(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
        Verificar = True
        If Verificar Then
            srcContatos = CType(Me.FindResource("ClienteContatosViewSource"), CollectionViewSource)
            srcCliente = CType(Me.FindResource("ExibirClienteViewSource"), CollectionViewSource)
        End If

        Datatxt.Text = Date.Now
    End Sub

    Private Sub UserControl_Loaded(sender As Object, e As RoutedEventArgs)
        FotoCt.Content = New ucCadFoto
    End Sub
#End Region

    
End Class
