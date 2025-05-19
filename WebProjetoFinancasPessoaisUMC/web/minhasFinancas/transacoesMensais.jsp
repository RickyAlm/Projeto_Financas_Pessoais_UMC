<%-- 
    Document   : transacoesMensais
    Created on : 18 de mai. de 2025, 23:16:04
    Author     : Rick
--%>

<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Obter o mês selecionado da sessão
    String mesAno = (String) session.getAttribute("mesSelecionado");
    
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
        int mesNumero = Integer.parseInt(partes[1]);
        
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
    <style>
        :root {
            --cor-principal: #009896;
            --verde-escuro: #008451;
            --verde-muito-escuro: #0C5741;
            --azul-escuro: #194E72;
            --azul-medio: #006996;
            --verde-claro: #4CE6B5;
            --fundo-cinza: #f5f7fa;
            --receita: #28a745;
            --despesa: #dc3545;
        }

        .transactions-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .month-header {
            text-align: center;
            margin-bottom: 30px;
            color: var(--azul-escuro);
            border-bottom: 2px solid var(--cor-principal);
            padding-bottom: 10px;
        }

        .budget-settings {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .budget-input {
            margin-bottom: 15px;
        }

        .budget-input label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: var(--azul-escuro);
        }

        .budget-input input {
            width: 94.5%;
            padding: 10px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
        }

        .budget-input input:focus {
            border-color: var(--cor-principal);
            outline: none;
        }

        .transactions-list {
            margin-top: 30px;
        }

        .add-transaction {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--cor-principal);
            color: white;
            padding: 10px;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 20px;
            transition: all 0.3s;
        }

        .add-transaction:hover {
            background-color: var(--verde-escuro);
            transform: translateY(-2px);
        }

        .add-transaction i {
            margin-right: 10px;
        }

        .transaction-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
        }

        .transaction-item:hover {
            background-color: #f9f9f9;
        }

        .transaction-info {
            flex: 1;
        }

        .transaction-name {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .transaction-category {
            font-size: 12px;
            color: #6c757d;
            background-color: #f1f1f1;
            padding: 3px 8px;
            border-radius: 10px;
            display: inline-block;
        }

        .transaction-amount {
            font-weight: 700;
            margin: 0 20px;
        }

        .income {
            color: var(--receita);
        }

        .expense {
            color: var(--despesa);
        }

        .transaction-actions i {
            margin-left: 15px;
            cursor: pointer;
            color: var(--azul-escuro);
            transition: all 0.2s;
        }

        .transaction-actions i:hover {
            transform: scale(1.1);
        }

        .fa-pen:hover {
            color: var(--cor-principal);
        }

        .fa-trash:hover {
            color: var(--despesa);
        }

        .monthly-stats {
            margin-top: 40px;
            padding: 20px;
            background-color: var(--fundo-cinza);
            border-radius: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 20px;
        }

        .stat-card {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .stat-card h3 {
            margin-top: 0;
            color: var(--azul-escuro);
            font-size: 16px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 700;
            margin: 10px 0;
        }

        .total-income {
            color: var(--receita);
        }

        .total-expenses {
            color: var(--despesa);
        }

        .savings {
            color: var(--cor-principal);
        }

        .progress-container {
            margin-top: 20px;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .progress-bar {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(to right, var(--cor-principal), var(--verde-claro));
            border-radius: 5px;
        }

        @media (max-width: 768px) {
            .budget-settings {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
                <input type="number" id="monthly-income" placeholder="R$ 0,00" value="3500.00">
            </div>
            <div class="budget-input">
                <label for="savings-goal">Meta de Economia</label>
                <input type="number" id="savings-goal" placeholder="R$ 0,00" value="700.00">
            </div>
        </div>

        <!-- Lista de transações -->
        <div class="transactions-list">
            <div class="add-transaction">
                <i class="fas fa-plus"></i>
                <span>Adicionar Transação</span>
            </div>

            <!-- Exemplo de transação (receita) -->
            <div class="transaction-item">
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

            <!-- Exemplo de transação (despesa) -->
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

            <!-- Exemplo de transação (despesa) -->
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
        </div>

        <!-- Estatísticas mensais -->
        <div class="monthly-stats">
            <h2>Resumo Financeiro</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total de Receitas</h3>
                    <div class="stat-value total-income">R$ 3.500,00</div>
                </div>
                <div class="stat-card">
                    <h3>Total de Despesas</h3>
                    <div class="stat-value total-expenses">R$ 1.650,00</div>
                </div>
                <div class="stat-card">
                    <h3>Economia</h3>
                    <div class="stat-value savings">R$ 1.850,00</div>
                </div>
            </div>

            <div class="progress-container">
                <div class="progress-label">
                    <span>Meta de economia: R$ 700,00</span>
                    <span>263%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
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
    </script>
</body>
</html>