<%-- 
    Document   : transacoesMensais
    Created on : 18 de mai. de 2025, 23:16:04
    Author     : Henrique Vieira de Almeida
--%>

<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Obter o mês selecionado da sessão
    String mesAno = (String) session.getAttribute("mesSelecionado");
    int mesNumero = 0;
    
    // Se veio por POST, atualiza a sessão
    if (request.getMethod().equalsIgnoreCase("POST")) {
        mesAno = request.getParameter("mesSelecionado");
        session.setAttribute("mesSelecionado", mesAno);
    }
    
    String mesNome = "Selecione um mês";
    String ano = "";
    
    if (mesAno != null && !mesAno.isEmpty()) {
        String[] partes = mesAno.split("-");
        ano = partes[0];
        mesNumero = Integer.parseInt(partes[1]);
        
        String[] meses = {"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
                         "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"};
        mesNome = meses[mesNumero - 1];
    }
%>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finanças Pessoais - Transações Mensais</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/minhasFinancas.css">
    <link rel="stylesheet" href="../assets/css/transacoesMensais.css">
</head>
<body>
    <div class="transactions-container">
        <!-- Título com o mês selecionado -->
        <div class="month-header">
            <h1 id="month-title">Transações de <%= mesNome %> <%= ano %></h1>
        </div>

        <!-- Configurações de orçamento -->
        <div class="budget-settings">
            <div class="budget-input">
                <label for="monthly-income">Renda Mensal</label>
                <input type="number" id="monthly-income" placeholder="R$ 0,00" value="">
            </div>
            <div class="budget-input">
                <label for="savings-goal">Meta de Economia</label>
                <input type="number" id="savings-goal" placeholder="R$ 0,00" value="">
            </div>
        </div>

        <!-- Lista de transações -->
        <div class="transactions-list">
            <div class="add-transaction">
                <i class="fas fa-plus"></i>
                <span>Adicionar Transação</span>
            </div>

            <!-- Exemplo de transação (receita) -->
<!--            <div class="transaction-item">
                <div class="transaction-info">
                    <div class="transaction-name">Salário</div>
                    <span class="transaction-category">Salário</span>
                </div>
                <div class="transaction-amount income">+ R$ 3.500,00</div>
                <div class="transaction-actions">
                    <i class="fas fa-pen"></i>
                    <i class="fas fa-trash"></i>
                </div>
            </div>

             Exemplo de transação (despesa) 
            <div class="transaction-item">
                <div class="transaction-info">
                    <div class="transaction-name">Aluguel</div>
                    <span class="transaction-category">Moradia</span>
                </div>
                <div class="transaction-amount expense">- R$ 1.200,00</div>
                <div class="transaction-actions">
                    <i class="fas fa-pen"></i>
                    <i class="fas fa-trash"></i>
                </div>
            </div>

             Exemplo de transação (despesa) 
            <div class="transaction-item">
                <div class="transaction-info">
                    <div class="transaction-name">Supermercado</div>
                    <span class="transaction-category">Alimentação</span>
                </div>
                <div class="transaction-amount expense">- R$ 450,00</div>
                <div class="transaction-actions">
                    <i class="fas fa-pen"></i>
                    <i class="fas fa-trash"></i>
                </div>
            </div>
        </div>-->

        <!-- Estatísticas mensais -->
        <div class="monthly-stats">
            <h2>Resumo Financeiro</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total de Receitas</h3>
                    <div class="stat-value total-income">R$ 0,00</div>
                </div>
                <div class="stat-card">
                    <h3>Total de Despesas</h3>
                    <div class="stat-value total-expenses">R$ 0,00</div>
                </div>
                <div class="stat-card">
                    <h3>Economia</h3>
                    <div class="stat-value savings">R$ 0,00</div>
                </div>
            </div>

            <div class="progress-container">
                <div class="progress-label">
                    <span>Meta de economia: R$ 0,00</span>
                    <span>0%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 0%"></div>
                </div>
            </div>
        </div>
    </div>

<!--    <script>
        // Resgata o parâmetro do mês da URL
        const urlParams = new URLSearchParams(window.location.search);
        const mesAno = urlParams.get('mes');
        
        if (mesAno) {
            // Converte o parâmetro para um formato legível
            const [ano, mes] = mesAno.split('-');
            const meses = [
                'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
                'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
            ];
            const mesNome = meses[parseInt(mes) - 1];
            
            // Atualiza o título da página
            document.getElementById('month-title').textContent = `Transações de ${mesNome} ${ano}`;
            
            // Aqui você faria uma requisição para buscar os dados do mês específico
            // e preencheria as transações e estatísticas
        }
    </script>-->
</body>
</html>