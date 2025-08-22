# 📍 Ponto de Venda (PDV)

| 📖 | Este repositório apresenta o desenvolvimento de um sistema **Ponto de Venda (PDV)** em **.NET/WPF**, resultado do treinamento realizado na **Sizex Sistemas Corporativos**. O objetivo de um PDV é automatizar processos de vendas em estabelecimentos comerciais, facilitando o registro de produtos, controle de estoque e emissão de relatórios financeiros. |
| --- | --- |

---

## 💻 Treinamento Sizex

A **Sizex Sistemas Corporativos**, localizada em Catanduva, é uma empresa especializada em soluções tecnológicas para gestão empresarial. Além de oferecer sistemas corporativos completos, a Sizex promove treinamentos focados em **.NET** e **WPF**, capacitando profissionais para o desenvolvimento de softwares robustos e modernos.  

Durante esse treinamento, tive a oportunidade de aprender conceitos fundamentais e aplicá-los diretamente no desenvolvimento de um **PDV funcional**, que integra banco de dados, interface gráfica e boas práticas de programação.

---

## 🚀 Projetos

O repositório contempla diferentes etapas do aprendizado e desenvolvimento:

- ✅ **Testes de Software:**  
  Aplicação de testes unitários e práticos para validar funcionalidades do sistema, garantindo qualidade e confiabilidade no código.  

- ✅ **SQL e Firebird:**  
  Integração com banco de dados **Firebird**, utilizando **SQL** para manipulação de tabelas, consultas, cadastros e relatórios de vendas.  

- ✅ **.NET:**  
  Desenvolvimento do backend utilizando **.NET**, aproveitando sua robustez para estruturar as regras de negócio e gerenciar a lógica do sistema.  

- ✅ **WPF:**  
  Construção da interface gráfica com **Windows Presentation Foundation (WPF)**, permitindo uma experiência mais intuitiva e moderna para o usuário final.  

---

## ⚙️ Guia de Instalação e Execução
```bash
Para garantir que o sistema **Ponto de Venda (PDV)** funcione corretamente em sua máquina, siga os passos abaixo com atenção:
```

### 🔽 1. Download do Projeto
- Faça o download do repositório ou clone diretamente do GitHub:  
  ```bash
  git clone https://github.com/eduty5665/PDV.git
  ```

### 🛠️ 2. Instalação dos Recursos Necessários

- Certifique-se de ter instalado os seguintes recursos antes de abrir o projeto:
  ```bash
  Visual Studio 2012 (ou superior) → Para compilar e executar o código em .NET/WPF.

  SQL Server Management Studio (SSMS 2019) → Para gerenciar o banco de dados e executar scripts SQL.

  Entity Framework → ORM utilizado no projeto para integração entre banco de dados e aplicação.

  Crystal Reports → Biblioteca necessária para geração de relatórios dentro do sistema.

  WPF (Windows Presentation Foundation) → Framework da Microsoft para a interface gráfica do projeto.

  .NET Framework (versão compatível com o projeto, ex: .NET 4.5 ou superior) → Ambiente de execução do sistema.
  ```

### 🗄️ 3. Configuração do Banco de Dados

- Abra o SQL Server Management Studio 2019 (SSMS):
  ```bash
  Crie um novo banco de dados ou utilize um existente para importar as tabelas.

  Copie e cole o script SQL fornecido na pasta do projeto dentro do SSMS.

  Execute o script para criar todas as tabelas, procedures e dados necessários para o funcionamento do PDV.
  ```

### 💻 4. Abrindo o Projeto

- Abra o Visual Studio 2012:
  ```bash
  Vá até a opção Abrir Projeto/Solução e selecione o arquivo .sln do repositório.

  Configure as References do projeto:

  - Adicione novamente pacotes e bibliotecas caso o Visual Studio aponte algum erro de referência (Entity Framework, Crystal Reports, etc).

  - Verifique se o projeto está apontando para a versão correta do .NET Framework.
  ```

### ⚡ 5. Compilação do Código

- Dentro do Visual Studio, selecione o modo Build Solution (Ctrl + Shift + B):
  ```bash
  Aguarde a compilação.

  Corrija eventuais erros de dependências ou versões de framework que possam surgir.
  ```
### 🧪 6. Execução e Testes

- Após a compilação bem-sucedida, rode o projeto pelo Visual Studio (tecla F5):
  ```bash
  Realize os testes básicos:

  - Cadastro de produtos.

  - Registro de vendas.

  - Emissão de relatórios (Crystal Reports).

  - Verificação do estoque e integração com o banco de dados.

  - Caso algum erro ocorra:

    Verifique as configurações de conexão com o banco no arquivo de configuração do projeto.

    Reinstale ou reconfigure as bibliotecas necessárias.
  ```
---

## 🔗 Links

[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://eduty5665.github.io/Portifolio/)  
[![linkedin](https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/eduardo-lemes-185715239/)  
[![email](https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white)](mailto:edulucas.le43@gmail.com)  
[![instagram](https://img.shields.io/badge/-Instagram-%23E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/_eduty/)  
[![facebook](https://img.shields.io/badge/-Facebook-%230077B5?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/eduardo.januario.5876/)

---

🛠️ Feito com dedicação e aprendizado durante o treinamento da **Sizex Sistemas Corporativos** por [**eduty**](https://github.com/eduty5665) 🤍
