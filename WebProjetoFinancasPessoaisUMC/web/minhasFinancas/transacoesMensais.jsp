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
            <div class="add-transaction" id="addTransactionBtn">
                <i class="fas fa-plus"></i>
                <span>Adicionar Transação</span>
            </div>

            <!-- As transações serão inseridas aqui dinamicamente -->
        </div>

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

    <!-- Modal para adicionar transação -->
    <div class="modal-overlay" id="transactionModal">
        <div class="modal-container">
            <div class="modal-header">
                <h2>Adicionar Transação</h2>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="transactionName">Nome da Transação</label>
                    <input type="text" id="transactionName" placeholder="Ex: Salário, Aluguel, Supermercado">
                </div>
                
                <div class="form-group">
                    <label for="transactionValue">Valor</label>
                    <input type="number" id="transactionValue" placeholder="R$ 0,00" step="0.01">
                </div>
                
                <div class="form-group">
                    <label for="transactionType">Tipo</label>
                    <select id="transactionType">
                        <option value="">Selecione o tipo</option>
                        <option value="income">Receita</option>
                        <option value="expense">Despesa</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="transactionCategory">Categoria</label>
                    <select id="transactionCategory">
                        <option value="">Selecione a categoria</option>
                        <optgroup label="Receitas">
                            <option value="salary">Salário</option>
                            <option value="freelance">Freelance</option>
                            <option value="investment">Investimentos</option>
                            <option value="other_income">Outras receitas</option>
                        </optgroup>
                        <optgroup label="Despesas">
                            <option value="housing">Moradia</option>
                            <option value="food">Alimentação</option>
                            <option value="transport">Transporte</option>
                            <option value="health">Saúde</option>
                            <option value="education">Educação</option>
                            <option value="leisure">Lazer</option>
                            <option value="other_expense">Outras despesas</option>
                        </optgroup>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-cancel" id="cancelBtn">Cancelar</button>
                <button class="btn btn-save" id="saveBtn">Salvar</button>
            </div>
        </div>
    </div>

    <script>
        // Controle do modal
        const modal = document.getElementById('transactionModal');
        const addTransactionBtn = document.getElementById('addTransactionBtn');
        const cancelBtn = document.getElementById('cancelBtn');
        
        // Função para abrir o modal
        function openModal() {
            modal.classList.add('active');
        }
        
        // Função para fechar o modal
        function closeModal() {
            modal.classList.remove('active');
            // Limpar os campos ao fechar
            document.getElementById('transactionName').value = '';
            document.getElementById('transactionValue').value = '';
            document.getElementById('transactionType').value = '';
            document.getElementById('transactionCategory').value = '';
        }
        
        // Event listeners
        addTransactionBtn.addEventListener('click', openModal);
        cancelBtn.addEventListener('click', closeModal);
        
        // Fechar modal ao clicar fora
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                closeModal();
            }
        });

        // Lógica para salvar a transação (a ser implementada)
        document.getElementById('saveBtn').addEventListener('click', function() {
            // Aqui você implementaria a lógica para salvar a transação
            const name = document.getElementById('transactionName').value;
            const value = document.getElementById('transactionValue').value;
            const type = document.getElementById('transactionType').value;
            const category = document.getElementById('transactionCategory').value;
            
            if (!name || !value || !type || !category) {
                alert('Por favor, preencha todos os campos!');
                return;
            }
            
            // Exemplo de como você poderia adicionar a transação à lista
            // addTransactionToList(name, value, type, category);
            
            // Fechar o modal após salvar
            closeModal();
        });
    </script>
</body>
</html>