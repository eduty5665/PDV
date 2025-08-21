Imports CrystalDecisions.CrystalReports.Engine

Class ReportWin
    Public Property LocalizacaoReport As String
    Public Property ParametrosRep As List(Of Object)

    Private Sub Window_Loaded(ByVal sender As System.Object, ByVal e As System.Windows.RoutedEventArgs) Handles MyBase.Loaded
        Dim rep As New ReportDocument
        Dim con As New CrystalDecisions.Shared.ConnectionInfo
        Dim logOn As New CrystalDecisions.Shared.TableLogOnInfo
        Try
            'ReportViewer.Owner = Window.GetWindow(Me)
            con.ServerName = "DESKTOP-KQ6JTO0\SQLEXPRESS"
            con.DatabaseName = "TREINAMENTO"

            rep.Load(LocalizacaoReport)
            For Each tb As Table In rep.Database.Tables
                logOn = tb.LogOnInfo
                logOn.ConnectionInfo = con
                tb.ApplyLogOnInfo(logOn)
            Next
            rep.DataSourceConnections.Item(0).SetLogon("Acesso", "lada11")

            If Not ParametrosRep Is Nothing Then
                For i As Integer = 0 To ParametrosRep.Count - 1
                    rep.SetParameterValue(i, ParametrosRep(i))
                Next
            End If

            ReportViewer.ViewerCore.ReportSource = rep
        Catch ex As Exception
            MsgBox(ex.Message, MsgBoxStyle.Critical, "Erro")
        End Try
    End Sub

   
End Class
