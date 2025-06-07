<%-- 
    Document   : index
    Created on : 25 de mai. de 2025, 21:10:47
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="dao.DadosMensaisDAO"%>
<%@page import="model.DadosMensais"%>
<%@page import="model.Usuario"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    DadosMensaisDAO dadosMensaisDAO = new DadosMensaisDAO();
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    String[] meses = {"01","02","03","04","05","06","07","08","09","10","11","12"};
    String[] nomesMeses = {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"};
    String anoAtual = String.valueOf(java.time.LocalDate.now().getYear());
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finanças Pessoais - Meus Meses</title>
    <link rel="stylesheet" href="../assets/css/fontePoppins.css">
    <link rel="stylesheet" href="../assets/css/minhasFinancas.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header poppins-bold">
            <h1>Minhas Finanças</h1>
            <p>Selecione um mês para visualizar ou adicionar transações</p>
        </div>

        <div class="months-grid">
            <% for (int i = 0; i < 12; i++) {
                String mesAno = anoAtual + "-" + meses[i];
                DadosMensais dados = usuario != null ? dadosMensaisDAO.buscarPorUsuarioEMes(usuario.getIdUsuario(), mesAno) : null;
                double receitas = dados != null ? dados.getTotal_receitas() : 0.0;
                double despesas = dados != null ? dados.getTotal_despesas() : 0.0;
                boolean isCurrentMonth = (java.time.LocalDate.now().getMonthValue() == (i+1));
            %>
            <form action="transacoesMensais.jsp" method="post" class="month-card-form">
                <input type="hidden" name="mesSelecionado" value="<%= mesAno %>">
                <button type="submit" class="month-card <%= isCurrentMonth ? "current-month" : "" %>">
                    <div class="month-card-header poppins-semibold"><%= nomesMeses[i] %></div>
                    <div class="month-card-body">
                        <div class="month-stats poppins-regular">
                            <div class="stat">
                                <div class="stat-value stat-income"><%= formatoMoeda.format(receitas) %></div>
                                <div class="stat-label">Receitas</div>
                            </div>
                            <div class="stat">
                                <div class="stat-value stat-expense"><%= formatoMoeda.format(despesas) %></div>
                                <div class="stat-label">Despesas</div> 
                            </div>
                        </div>
                    </div>
                </button>
            </form>
            <% } %>
        </div>
    </div>
</body>
</html>
