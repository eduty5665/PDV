Public Class wdLogin

#Region "Construtores - SUB"

#End Region

#Region "Metodos - SUB"
#End Region

#Region "Botoes - SUB"
    Private Sub EntrarBtn_Click(sender As Object, e As RoutedEventArgs) Handles EntrarBtn.Click
        If Nometxt.Text = "" Then
            MsgBox("Usuário não informado, verifique!", MsgBoxStyle.Information, "Validação!")
            Nometxt.Focus()
            Exit Sub
        ElseIf Senhatxt.Password = "" Then
            MsgBox("Senha não informada, verifique!", MsgBoxStyle.Information, "Validação!")
            Senhatxt.Focus()
            Exit Sub
        End If

        Dim senha As String = GetSetting("Treinamento", "Acesso", UCase(Nometxt.Text), "")

        If senha = "" Then
            If MsgBox("Deseja cadastrar este usuário?", MsgBoxStyle.Question + MsgBoxStyle.YesNo, "Usuário!") = MsgBoxResult.Yes Then
                senha = InputBox("Confirme sua senha, a digitando aqui.", "Senha", "")
                If senha = "" Then
                    MsgBox("Senha não cadastrada, verifique.", MsgBoxStyle.Information, "Atenção!")
                    Exit Sub
                End If
                SaveSetting("Treinamento", "Acesso", UCase(Nometxt.Text), Senhatxt.Password)
                MsgBox("Usuário (" & UCase(Nometxt.Text) & ") cadastrado com sucesso!", MsgBoxStyle.Information, "Parabéns!")
                Nometxt.Text = UCase(Nometxt.Text)
                Senhatxt.Password = ""
                Senhatxt.Focus()
            End If
        ElseIf senha = Senhatxt.Password Then
            Dim wd As New MainWindow
            wd.Show()
            Me.Close()
        Else
            MsgBox("Senha informada não confere, verifique!", MsgBoxStyle.Exclamation, "Atenção!")
        End If
    End Sub

    Private Sub SaiBtn_Click(sender As Object, e As RoutedEventArgs) Handles SaiBtn.Click
        Me.Close()
    End Sub
#End Region

#Region "Telas - SUB"
    Private Sub Window_KeyDown_1(sender As Object, e As KeyEventArgs)
        Select Case e.Key
            Case Key.Enter
                EntrarBtn_Click(Nothing, Nothing)
            Case Key.Escape
                SaiBtn_Click(Nothing, Nothing)
        End Select
    End Sub
#End Region
End Class
