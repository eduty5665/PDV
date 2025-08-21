Public Class Cliente
    Public Property DataCad As String
    Public Property CPF As String
    Public Property RG As String
    Public Property Nome As String
    Public Property Status As Boolean
    Public Property Endereco As String
    Public Property Numero As Integer
    Public Property Bairro As String
    Public Property Cidade As String
    Public Property Estado As String
    Public Property CEP As String
    Public Property Complemento As String
    Public Property Usuario As String
    Public Property DataGravacao As DateTime
    Public Property Contatos As List(Of ClienteContatos)
End Class