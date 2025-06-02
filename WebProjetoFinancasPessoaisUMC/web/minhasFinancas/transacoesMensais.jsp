<%-- 
    Document   : transacoesMensais
    Created on : 18 de mai. de 2025, 23:16:04
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Categoria"%>
<%@page import="java.util.List"%>
<%@page import="dao.CategoriaDAO"%>
<%@page import="model.Transacao"%>
<%@page import="dao.TransacaoDAO"%>
<%@page import="model.Usuario"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.DadosMensaisDAO"%>
<%@page import="model.DadosMensais"%>
<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mesAno = (String) session.getAttribute("mesSelecionado");
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String mesParam = request.getParameter("mesSelecionado");
        if (mesParam != null) {
            mesAno = mesParam;
            session.setAttribute("mesSelecionado", mesAno);
        }
    }

    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

    DadosMensaisDAO dadosMensaisDAO = new DadosMensaisDAO();
    DadosMensais dadosMensais = null;
    if (usuario != null && mesAno != null && !mesAno.isEmpty()) {
        dadosMensais = dadosMensaisDAO.buscarPorUsuarioEMes(usuario.getIdUsuario(), mesAno);
        if (dadosMensais == null) {
            dadosMensais = new DadosMensais();
            dadosMensais.setId_usuario(usuario.getIdUsuario());
            dadosMensais.setMes_ano(mesAno);
            dadosMensais.setMeta(0.0);
            dadosMensais.setRenda_mensal(0.0);
            dadosMensais.setTotal_receitas(0.0);
            dadosMensais.setTotal_despesas(0.0);
            dadosMensais.setEconomia(0.0);
            dadosMensaisDAO.inserir(dadosMensais);
            dadosMensais = dadosMensaisDAO.buscarPorUsuarioEMes(usuario.getIdUsuario(), mesAno);
        }
    }

    int mesNumero = 0;
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

    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Categoria> categorias = categoriaDAO.consultarTodos();

    List<Transacao> transacoes = new ArrayList<>();
    if (mesAno != null && !mesAno.isEmpty() && usuario != null) {
        TransacaoDAO transacaoDAO = new TransacaoDAO();
        transacoes = transacaoDAO.consultarPorUsuarioEMes(usuario.getIdUsuario(), mesAno);
    }

    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    double totalReceitas = 0.0;
    double totalDespesas = 0.0;
    double economia = 0.0;

    for (Transacao t : transacoes) {
        if (t.getTipo() == Transacao.TipoTransacao.receita) {
            totalReceitas += t.getValor();
        } else if (t.getTipo() == Transacao.TipoTransacao.despesa) {
            totalDespesas += t.getValor();
        }
    }

    if (dadosMensais != null) {
        totalReceitas += dadosMensais.getRenda_mensal();
    }

    economia = totalReceitas - totalDespesas;

    if (dadosMensais != null) {
        dadosMensais.setTotal_receitas(totalReceitas);
        dadosMensais.setTotal_despesas(totalDespesas);
        dadosMensais.setEconomia(economia);
        dadosMensaisDAO.atualizarTotais(usuario.getIdUsuario(), mesAno, totalReceitas, totalDespesas, economia);
    }

    String rendaMensalInput = "";
    String metaInput = "";
    if (dadosMensais != null) {
        rendaMensalInput = String.valueOf(dadosMensais.getRenda_mensal()).replace(',', '.');
        metaInput = String.valueOf(dadosMensais.getMeta()).replace(',', '.');
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "atualizarRenda".equals(request.getParameter("acao"))) {
        String rendaStr = request.getParameter("monthlyIncome");
        if (usuario != null && mesAno != null && rendaStr != null && !rendaStr.isEmpty()) {
            try {
                double novaRenda = Double.parseDouble(rendaStr.replace(",", "."));
                if (novaRenda > 0) {
                    DadosMensaisDAO dao = new DadosMensaisDAO();
                    dao.atualizarRendaMensal(usuario.getIdUsuario(), mesAno, novaRenda);

                    double totalReceitasAtual = 0.0;
                    double totalDespesasAtual = 0.0;
                    for (Transacao t : transacoes) {
                        if (t.getTipo() == Transacao.TipoTransacao.receita) {
                            totalReceitasAtual += t.getValor();
                        } else {
                            totalDespesasAtual += t.getValor();
                        }
                    }
                    double economiaAtual = totalReceitasAtual - totalDespesasAtual;
                    dao.atualizarTotais(usuario.getIdUsuario(), mesAno, totalReceitasAtual, totalDespesasAtual, economiaAtual);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "atualizarMeta".equals(request.getParameter("acao"))) {
        String metaStr = request.getParameter("savingsGoal");
        if (usuario != null && mesAno != null && metaStr != null && !metaStr.isEmpty()) {
            try {
                double novaMeta = Double.parseDouble(metaStr.replace(",", "."));
                if (novaMeta >= 0) {
                    DadosMensaisDAO dao = new DadosMensaisDAO();
                    dao.atualizarMeta(usuario.getIdUsuario(), mesAno, novaMeta);
                    
                    if (dadosMensais != null) {
                        dadosMensais.setMeta(novaMeta);
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        response.sendRedirect(request.getRequestURI());
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "atualizarRenda".equals(request.getParameter("acao"))) {
        response.sendRedirect(request.getRequestURI());
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("transactionName") != null) {
        String nome = request.getParameter("transactionName");
        String valorStr = request.getParameter("transactionValue");
        String tipoStr = request.getParameter("transactionType");
        String categoriaStr = request.getParameter("transactionCategory");
        String editIdStr = request.getParameter("editTransactionId");

        if (usuario != null && mesAno != null && nome != null && valorStr != null && tipoStr != null && categoriaStr != null) {
            try {
                double valor = Double.parseDouble(valorStr.replace(",", "."));
                int idCategoria = Integer.parseInt(categoriaStr);
                Transacao.TipoTransacao tipo = tipoStr.equals("income") ? Transacao.TipoTransacao.receita : Transacao.TipoTransacao.despesa;

                TransacaoDAO transacaoDAO = new TransacaoDAO();

                if (editIdStr != null && !editIdStr.isEmpty()) {
                    int idTransacao = Integer.parseInt(editIdStr);
                    Transacao transacaoEdit = new Transacao();
                    transacaoEdit.setId_transacao(idTransacao);
                    transacaoEdit.setId_usuario(usuario.getIdUsuario());
                    transacaoEdit.setId_categoria(idCategoria);
                    transacaoEdit.setNome(nome);
                    transacaoEdit.setValor(valor);
                    transacaoEdit.setTipo(tipo);
                    transacaoEdit.setMesAno(mesAno);
                    transacaoDAO.atualizar(transacaoEdit);
                } else {
                    Transacao novaTransacao = new Transacao();
                    novaTransacao.setId_usuario(usuario.getIdUsuario());
                    novaTransacao.setId_categoria(idCategoria);
                    novaTransacao.setNome(nome);
                    novaTransacao.setValor(valor);
                    novaTransacao.setTipo(tipo);
                    novaTransacao.setMesAno(mesAno);
                    novaTransacao.setData(java.time.LocalDateTime.now());
                    transacaoDAO.inserir(novaTransacao);
                }

                response.sendRedirect(request.getRequestURI());
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    String deleteId = request.getParameter("delete");
    if (deleteId != null && !deleteId.isEmpty()) {
        try {
            int idTransacao = Integer.parseInt(deleteId);
            TransacaoDAO transacaoDAO = new TransacaoDAO();
            transacaoDAO.deletarPorId(idTransacao);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        response.sendRedirect(request.getRequestURI());
        return;
    }

%>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finanças Pessoais - Transações Mensais</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/transacoesMensais.css">
    <link rel="stylesheet" href="../assets/css/minhasFinancas.css">
    <link rel="stylesheet" href="../assets/css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<body>
    <div class="transactions-container">
        <!-- Título com o mês selecionado -->
        <div class="month-header">
            <h1 id="month-title">Transações de <%= mesNome %> <%= ano %></h1>
        </div>

        <!-- Configurações de orçamento -->
        <div class="budget-settings">
            <div class="budget-input input-with-icon">
                <label for="monthly-income">Renda Mensal</label>
                <input type="number" id="monthly-income-value" placeholder="R$ 0,00" value="<%= rendaMensalInput %>" disabled>
                <i class="fas fa-pen edit-budget" onclick="openBudgetModal('monthly-income')"></i>
            </div>
            <div class="budget-input input-with-icon">
                <label for="savings-goal">Meta de Economia</label>
                <input type="number" id="savings-goal-value" placeholder="R$ 0,00" value="<%= metaInput %>" disabled>
                <i class="fas fa-pen edit-budget" onclick="openBudgetModal('savings-goal')"></i>
            </div>
        </div>


        <!-- Modal para editar orçamento -->
        <div class="modal-overlay" id="budgetModal">
            <div class="modal-container">
                <form method="post" id="budgetForm">
                    <div class="modal-header">
                        <h2 id="budget-modal-title">Editar Valor</h2>
                    </div>
                    <div class="modal-body">
                        <div class="budget-input">
                            <input type="number" id="monthly-income" name="monthlyIncome" placeholder="R$ 0,00" value="" min="0.01" step="0.01" required style="display:none;">
                            <input type="number" id="savings-goal" name="savingsGoal" placeholder="R$ 0,00" value="" min="0" step="0.01" required style="display:none;">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-cancel" onclick="closeBudgetModal()">Cancelar</button>
                        <button type="submit" class="btn btn-save">Salvar</button>
                    </div>
                    <input type="hidden" name="acao" id="acao-budget" value="">
                </form>
            </div>
        </div>

        <!-- Lista de transações -->
        <div class="transactions-list">
            <div class="add-transaction" id="addTransactionBtn">
                <i class="fas fa-plus"></i>
                <span>Adicionar Transação</span>
            </div>
            
            <% for (Transacao transacao : transacoes) { 
                String classeValor = transacao.getTipo() == Transacao.TipoTransacao.receita ? "income" : "expense";
                String sinalValor = transacao.getTipo() == Transacao.TipoTransacao.receita ? "+" : "-";
                
                String nomeCategoria = "";
                for (Categoria categoria : categorias) {
                    if (categoria.getId_categoria() == transacao.getId_categoria()) {
                        nomeCategoria = categoria.getNome();
                        break;
                    }
                }
            %>
            <div class="transaction-item">
                <div class="transaction-info">
                    <div class="transaction-name"><%= transacao.getNome() %></div>
                    <span class="transaction-category"><%= nomeCategoria %></span>
                </div>
                <div class="transaction-amount <%= classeValor %>">
                    <%= sinalValor %> <%= formatoMoeda.format(transacao.getValor()) %>
                </div>
                <div class="transaction-actions">
                    <i class="fas fa-pen" onclick="editarTransacao(<%= transacao.getId_transacao() %>)"></i>
                    <i class="fas fa-trash" onclick="excluirTransacao(<%= transacao.getId_transacao() %>)"></i>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Estatísticas mensais -->
        <div class="monthly-stats">
            <h2>Resumo Financeiro</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total de Receitas</h3>
                    <div class="stat-value total-income"><%= formatoMoeda.format(totalReceitas) %></div>
                </div>
                <div class="stat-card">
                    <h3>Total de Despesas</h3>
                    <div class="stat-value total-expenses"><%= formatoMoeda.format(totalDespesas) %></div>
                </div>
                <div class="stat-card">
                    <h3>Economia</h3>
                    <div class="stat-value savings"><%= formatoMoeda.format(economia) %></div>
                </div>
            </div>

            <%
            double percentualEconomia = 0.0;
            if (dadosMensais != null && dadosMensais.getMeta() > 0) {
                percentualEconomia = (economia / dadosMensais.getMeta()) * 100.0;
                if (percentualEconomia < 0) percentualEconomia = 0;
                if (percentualEconomia > 100) percentualEconomia = 100;
            }
            %>
            <div class="progress-container">
                <div class="progress-label">
                    <span>Meta de economia: <%= formatoMoeda.format(dadosMensais != null ? dadosMensais.getMeta() : 0.0) %></span>
                    <span><%= String.format("%.1f%%", percentualEconomia) %></span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <%= percentualEconomia %>%"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para adicionar transação -->
    <div class="modal-overlay" id="transactionModal">
        <div class="modal-container">
            <form method="POST" id="transactionForm">
                <div class="modal-header">
                    <h2>Adicionar Transação</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="transactionName">Nome da Transação</label>
                        <input type="text" id="transactionName" name="transactionName" placeholder="Ex: Salário, Aluguel, Supermercado" required>
                    </div>

                    <div class="form-group">
                        <label for="transactionValue">Valor</label>
                        <input type="number" id="transactionValue" name="transactionValue" placeholder="R$ 0,00" min="0.01" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="transactionType">Tipo</label>
                        <select id="transactionType" name="transactionType" required>
                            <option value="">Selecione o tipo</option>
                            <option value="income">Receita</option>
                            <option value="expense">Despesa</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="transactionCategory">Categoria</label>
                        <select id="transactionCategory" name="transactionCategory" required>
                            <option value="">Selecione a categoria</option>
                            <% for (Categoria categoria : categorias) { %>
                                <option value="<%= categoria.getId_categoria() %>">
                                    <%= categoria.getNome() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <input type="hidden" id="editTransactionId" name="editTransactionId" value="">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" id="cancelBtn">Cancelar</button>
                    <button type="submit" class="btn btn-save">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Controle do modal
        const modal = document.getElementById('transactionModal');
        const addTransactionBtn = document.getElementById('addTransactionBtn');
        const cancelBtn = document.getElementById('cancelBtn');
        
        // Função para abrir o modal para adicionar
        function openModal() {
            modal.classList.add('active');
            document.querySelector('.modal-header h2').textContent = "Adicionar Transação";
            document.getElementById('editTransactionId').value = '';
        }
        
        // Função para abrir o modal para editar
        function editarTransacao(idTransacao) {
            const transacao = transacoes.find(t => t.id === idTransacao);
            if (!transacao) {
                Swal.fire({
                    icon: 'error',
                    title: 'Transação não encontrada!',
                    text: 'Não foi possível localizar a transação selecionada.'
                });
                return;
            }
            document.getElementById('transactionName').value = transacao.nome;
            document.getElementById('transactionValue').value = transacao.valor;
            document.getElementById('transactionType').value = transacao.tipo === "receita" ? "income" : "expense";
            document.getElementById('transactionCategory').value = transacao.categoria;
            document.getElementById('editTransactionId').value = transacao.id;

            document.querySelector('.modal-header h2').textContent = "Editar Transação";
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
            document.getElementById('editTransactionId').value = '';
            document.querySelector('.modal-header h2').textContent = "Adicionar Transação";
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

        document.getElementById('transactionForm').addEventListener('submit', function(e) {
            const valor = parseFloat(document.getElementById('transactionValue').value);
            const tipo = document.getElementById('transactionType').value;
            const categoria = document.getElementById('transactionCategory').value;

            if (isNaN(valor) || valor <= 0) {
                Swal.fire({
                    icon: 'error',
                    title: 'Valor inválido',
                    text: 'O valor deve ser maior que zero'
                });
                e.preventDefault();
                return false;
            }
            if (tipo === '' || categoria === '') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Campos obrigatórios',
                    text: 'Selecione o tipo e a categoria'
                });
                e.preventDefault();
                return false;
            }
            return true;
        });

        // Funções para editar e excluir transações
        function editarTransacao(idTransacao) {
            const transacao = transacoes.find(t => t.id === idTransacao);
            if (!transacao) {
                Swal.fire({
                    icon: 'error',
                    title: 'Transação não encontrada!',
                    text: 'Não foi possível localizar a transação selecionada.'
                });
                return;
            }
            document.getElementById('transactionName').value = transacao.nome;
            document.getElementById('transactionValue').value = transacao.valor;
            document.getElementById('transactionType').value = transacao.tipo === "receita" ? "income" : "expense";
            document.getElementById('transactionCategory').value = transacao.categoria;
            document.getElementById('editTransactionId').value = transacao.id;

            document.querySelector('.modal-header h2').textContent = "Editar Transação";
            modal.classList.add('active');
        }
        
        function excluirTransacao(idTransacao) {
            Swal.fire({
                title: 'Tem certeza?',
                text: "Deseja excluir esta transação?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sim',
                cancelButtonText: 'Não'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '?delete=' + idTransacao;
                }
            });
        }

        const transacoes = [
            <% for (Transacao transacao : transacoes) { %>
            {
                id: <%= transacao.getId_transacao() %>,
                nome: "<%= transacao.getNome().replace("\"", "\\\"") %>",
                valor: <%= transacao.getValor() %>,
                tipo: "<%= transacao.getTipo().toString() %>",
                categoria: <%= transacao.getId_categoria() %>
            },
            <% } %>
        ];
    </script>

    <script>
        let editingBudgetField = null;

        function openBudgetModal(field) {
            editingBudgetField = field;
            document.getElementById('budget-modal-title').textContent =
                field === 'monthly-income' ? 'Renda Mensal' : 'Meta de Economia';

            const incomeInput = document.getElementById('monthly-income');
            const goalInput = document.getElementById('savings-goal');

            if (field === 'monthly-income') {
                incomeInput.style.display = '';
                incomeInput.required = true;
                goalInput.style.display = 'none';
                goalInput.required = false;
                incomeInput.value = document.getElementById('monthly-income-value').value;
            } else {
                goalInput.style.display = '';
                goalInput.required = true;
                incomeInput.style.display = 'none';
                incomeInput.required = false;
                goalInput.value = document.getElementById('savings-goal-value').value;
            }
            document.getElementById('acao-budget').value = field === 'monthly-income' ? 'atualizarRenda' : 'atualizarMeta';
            document.getElementById('budgetModal').classList.add('active');
        }

        function closeBudgetModal() {
            document.getElementById('budgetModal').classList.remove('active');
            editingBudgetField = null;
        }

        document.getElementById('budgetModal').addEventListener('click', function(e) {
            if (e.target === this) closeBudgetModal();
        });

        document.getElementById('budgetForm').addEventListener('submit', function(e) {
            if (editingBudgetField === 'monthly-income') {
                const valor = parseFloat(document.getElementById('monthly-income').value);
                if (isNaN(valor) || valor <= 0) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Valor inválido',
                        text: 'A renda mensal deve ser maior que zero'
                    });
                    e.preventDefault();
                    return false;
                }
            } else if (editingBudgetField === 'savings-goal') {
                const valor = parseFloat(document.getElementById('savings-goal').value);
                if (isNaN(valor) || valor < 0) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Valor inválido',
                        text: 'A meta de economia não pode ser negativa'
                    });
                    e.preventDefault();
                    return false;
                }
            }
            return true;
        });
    </script>
</body>
</html>