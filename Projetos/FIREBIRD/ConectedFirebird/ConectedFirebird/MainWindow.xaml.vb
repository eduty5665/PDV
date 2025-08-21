Class MainWindow

#Region "Construtores - SUB"
#End Region

#Region "Métodos - SUB"
#End Region

#Region "Buttons - SUB"
#End Region

#Region "Loaded - SUB"
    Private Sub Window_Loaded(sender As Object, e As RoutedEventArgs)
        Dim ctx As New SizexEntities

        Dim lstPessoas As List(Of PESSOA) = ctx.PESSOA.ToList

        Dim novaPessoa As New PESSOA
        novaPessoa.NOME = "TESTE"
        novaPessoa.ENDERECO = "RUA SETE DE SETEMBRO, 245"
        ctx.PESSOA.Add(novaPessoa)
        ctx.SaveChanges()
    End Sub
#End Region
End Class
