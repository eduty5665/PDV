Public Class wdCadCliente
    Dim objCliente As New Cliente
    Dim srcContatos As CollectionViewSource
    Dim srcCliente As CollectionViewSource
    Dim objContato As ClienteContatos
    Dim Verificar As Boolean
    Dim lstClientes As List(Of Cliente)

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
            Titlelbl.Content = "- Cadastro de Fornecedores"
            FotoCt.Visibility = Windows.Visibility.Collapsed
            CPFLbl.Content = "CNPJ"
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
        Try
            If ValidaCampos(retorno) = False Then
                Exit Sub
            End If

            If objCliente.Contatos Is Nothing Then
                objCliente.Contatos = New List(Of ClienteContatos)
            End If

            retorno = "Salvar dados contato"
            If objContato Is Nothing Then
                objContato = New ClienteContatos
                objCliente.Contatos.Add(objContato)
            End If
            objContato.Contato = Contatotxt.Text
            objContato.Observacao = OBSConttxt.Text
            objContato.Tipo = TipoContcmb.Text

            Dim msgSucessContat As String = "Contato salvo com sucesso! " & vbNewLine & "Total de Registros: " & objCliente.Contatos.Count
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

            Dim msgSucessDel As String = "Contato excluido com sucesso! " & vbNewLine & "Total de Registros: " & objCliente.Contatos.Count
            MsgBox(msgSucessDel, MsgBoxStyle.Information, "Exclusão de Contato")

            srcContatos.Source = Nothing
            srcContatos.Source = objCliente.Contatos.ToList
        Else
            Dim msgErrorDel As String = "Nenhum contato selecionado para exclusão! " & vbNewLine & "Total de Registros: " & objCliente.Contatos.Count
            MsgBox(msgErrorDel, MsgBoxStyle.Information, "Exclusão de Contato")
        End If

        LimpaCampos("CT")
    End Sub

    Private Sub SalvarBtn_Click(sender As Object, e As RoutedEventArgs) Handles SalvarBtn.Click
        Dim retorno As String = ""
        Try
            If SalvarCliente(retorno) = False Then
                Exit Sub
            End If

            retorno = "Criação de Lista"
            If lstClientes Is Nothing Then
                lstClientes = New List(Of Cliente)
            End If
            lstClientes.Add(objCliente)
            srcContatos.Source = Nothing
            srcCliente.Source = lstClientes.ToList

            Dim msgSucessCli As String = "Cliente salvo com sucesso! " & vbNewLine & "Total de Registros: " & objCliente.Contatos.Count
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

    Private Sub SairBtn_Click(sender As Object, e As RoutedEventArgs) Handles SairBtn.Click
        Me.Close()
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
            Case Key.Escape
                SairBtn_Click(Nothing, Nothing)
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
#End Region

#Region "Chamada de Telas - SUB"
    Private Sub Window_Loaded_1(sender As Object, e As RoutedEventArgs)
        FotoCt.Content = New ucCadFoto
    End Sub

    Private Sub wdCadCliente(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
        Verificar = True
        If Verificar Then
            srcContatos = CType(Me.FindResource("ClienteContatosViewSource"), CollectionViewSource)
            srcCliente = CType(Me.FindResource("ExibirClienteViewSource"), CollectionViewSource)

            If objCliente.Contatos Is Nothing Then
                objCliente.Contatos = New List(Of ClienteContatos)
            End If

            srcContatos.Source = objCliente.Contatos.ToList

            Datatxt.Text = Date.Now
        End If
    End Sub
#End Region

End Class
