Class MainWindow 

    Dim MenuItem As TabControl

    Private Sub ProdutoMnu_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles ProdutoMnu.MouseLeftButtonDown
        CFG.CarregaTela(Menutb, New ucCadProduto)
    End Sub

    Private Sub ClienteMnu_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles ClienteMnu.MouseLeftButtonDown
        CFG.CarregaTela(Menutb, New ucCadCliente("C"))
    End Sub

    Private Sub VeiculosMnu_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles VeiculosMnu.MouseLeftButtonDown
        CFG.CarregaTela(Menutb, New ucCadAutomovel)
    End Sub

    Private Sub FornMnu_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles FornMnu.MouseLeftButtonDown
        CFG.CarregaTela(Menutb, New ucCadCliente("F"))

    End Sub
End Class
