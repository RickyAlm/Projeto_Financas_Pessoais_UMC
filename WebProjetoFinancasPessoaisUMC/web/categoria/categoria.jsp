<%-- 
    Document   : categoria
    Created on : 04 de jun. de 2025, 20:40:13
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="java.util.List"%>
<%@page import="model.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../loginUsuario/verificaLogin.jsp"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Administração de Categorias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/fontePoppins.css">
    <link rel="stylesheet" href="../assets/css/styles.css">
    <link rel="stylesheet" href="../assets/css/adminUsuarios.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <%
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        List<Categoria> categorias = null;
        String busca = request.getParameter("busca") != null ? request.getParameter("busca") : "";
        String filtroTipo = request.getParameter("filtroTipo") != null ? request.getParameter("filtroTipo") : "";

        int pagina = 1;
        int porPagina = 10;
        if (request.getParameter("pagina") != null) {
            try {
                pagina = Integer.parseInt(request.getParameter("pagina"));
                if (pagina < 1) pagina = 1;
            } catch (Exception e) { pagina = 1; }
        }
        int totalCategorias = 0;
        try {
            totalCategorias = categoriaDAO.consultarComBusca(busca, filtroTipo).size();
        } catch(Exception e) { totalCategorias = 0; }
        int totalPaginas = (int) Math.ceil((double) totalCategorias / porPagina);

        try {
            categorias = categoriaDAO.consultarComBuscaPaginado(busca, filtroTipo, (pagina-1)*porPagina, porPagina);
        } catch(Exception e) {
            out.println("<script>Swal.fire('Erro!', 'Erro ao carregar categorias: " + e.getMessage() + "', 'error');</script>");
        }
    %>
</head>
<body>
    <div class="main-content poppins-regular">
        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-header">
                    <h2><i class="fas fa-tags"></i> Administração de Categorias</h2>
                </div>
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-filter"></i> Buscar Categoria</h5>
                        <button class="btn btn-success" onclick="abrirModalCriarCategoria()">
                            <i class="fas fa-plus"></i> Nova Categoria
                        </button>
                    </div>
                    <div class="card-body">
                        <form method="get" class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Buscar</label>
                                <input type="text" name="busca" class="form-control campo-busca" placeholder="Nome ou Tipo" value="<%= busca %>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tipo</label>
                                <select name="filtroTipo" class="form-select">
                                    <option value="" <%= filtroTipo.equals("") ? "selected" : "" %>>Todas</option>
                                    <option value="Despesa" <%= filtroTipo.equals("Despesa") ? "selected" : "" %>>Despesa</option>
                                    <option value="Receita" <%= filtroTipo.equals("Receita") ? "selected" : "" %>>Receita</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-filtrar">
                                    <i class="fas fa-filter"></i> Filtrar
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="profile-section">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Nome</th>
                                    <th>Tipo</th>
                                    <th>Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (categorias == null) { %>
                                <tr>
                                    <td colspan="3" class="text-center text-danger">Erro ao carregar categorias</td>
                                </tr>
                                <% } else if (categorias.isEmpty()) { %>
                                <tr>
                                    <td colspan="3" class="text-center">Nenhuma categoria encontrada</td>
                                </tr>
                                <% } else { 
                                    for (Categoria categoria : categorias) { %>
                                <tr>
                                    <td><%= categoria.getNome() %></td>
                                    <td><%= categoria.getTipo().substring(0,1).toUpperCase() + categoria.getTipo().substring(1).toLowerCase() %></td>
                                    <td>
                                        <a href="javascript:void(0);" 
                                            class="btn btn-primary btn-sm" 
                                            title="Editar"
                                            onclick="abrirModalEditarCategoria(<%= categoria.getId_categoria() %>)">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form method="post" style="display: inline;" id="formExcluir<%= categoria.getId_categoria() %>">
                                            <input type="hidden" name="acao" value="excluir">
                                            <input type="hidden" name="idCategoria" value="<%= categoria.getId_categoria() %>">
                                            <button type="button" class="btn btn-danger btn-sm btn-excluir" 
                                                    onclick="confirmarExclusao(<%= categoria.getId_categoria() %>)"
                                                    title="Excluir">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                    <nav aria-label="Paginação de categorias">
                        <ul class="pagination justify-content-center">
                            <li class="page-item <%= (pagina == 1) ? "disabled" : "" %>">
                                <a class="page-link" href="?pagina=<%= pagina-1 %>&busca=<%= busca %>&filtroTipo=<%= filtroTipo %>">Anterior</a>
                            </li>
                            <% for(int i=1; i<=totalPaginas; i++) { %>
                                <li class="page-item <%= (pagina == i) ? "active" : "" %>">
                                    <a class="page-link" href="?pagina=<%= i %>&busca=<%= busca %>&filtroTipo=<%= filtroTipo %>"><%= i %></a>
                                </li>
                            <% } %>
                            <li class="page-item <%= (pagina == totalPaginas || totalPaginas == 0) ? "disabled" : "" %>">
                                <a class="page-link" href="?pagina=<%= pagina+1 %>&busca=<%= busca %>&filtroTipo=<%= filtroTipo %>">Próxima</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="criarCategoriaModal">
        <div class="modal-container">
            <form id="formCriarCategoria" method="post" action="categoria.jsp">
                <input type="hidden" name="acao" value="criar">
                <div class="modal-header">
                    <h2>Criar Categoria</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="criarNome">Nome</label>
                        <input type="text" id="criarNome" name="nome" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="criarTipo">Tipo</label>
                        <select id="criarTipo" name="tipo" class="form-select" required>
                            <option value="" selected>Selecione...</option>
                            <option value="Despesa">Despesa</option>
                            <option value="Receita">Receita</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeCriarCategoriaModal()">Cancelar</button>
                    <button type="submit" class="btn btn-save">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-overlay" id="editarCategoriaModal">
        <div class="modal-container">
            <form id="formEditarCategoria" method="post" action="categoria.jsp">
                <input type="hidden" name="acao" value="editar">
                <input type="hidden" id="editCategoriaId" name="idCategoria">
                <div class="modal-header">
                    <h2>Editar Categoria</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editNome">Nome</label>
                        <input type="text" id="editNome" name="nome" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTipo">Tipo</label>
                        <select id="editTipo" name="tipo" class="form-select" required>
                            <option value="Despesa">Despesa</option>
                            <option value="Receita">Receita</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeEditarCategoriaModal()">Cancelar</button>
                    <button type="submit" class="btn btn-save">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    function confirmarExclusao(idCategoria) {
        Swal.fire({
            title: 'Tem certeza?',
            text: "Você está prestes a excluir esta categoria!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sim',
            cancelButtonText: 'Não'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formExcluir' + idCategoria).submit();
            }
        });
    }

    function abrirModalCriarCategoria() {
        document.getElementById('criarCategoriaModal').classList.add('active');
        document.getElementById('criarTipo').value = "";
}

document.getElementById('formCriarCategoria').onsubmit = function(e) {
    const tipo = document.getElementById('criarTipo').value;
    if (!tipo) {
        Swal.fire('Atenção', 'Selecione o tipo da categoria (Despesa ou Receita).', 'warning');
        e.preventDefault();
        return false;
    }
    return true;
};

    function closeCriarCategoriaModal() {
        document.getElementById('criarCategoriaModal').classList.remove('active');
    }

    function abrirModalEditarCategoria(idCategoria) {
        const categoria = categorias.find(c => c.id === idCategoria);
        if (!categoria) {
            Swal.fire('Erro', 'Categoria não encontrada!', 'error');
            return;
        }
        document.getElementById('editCategoriaId').value = categoria.id;
        document.getElementById('editNome').value = categoria.nome;
        document.getElementById('editTipo').value = categoria.tipo.trim().charAt(0).toUpperCase() + categoria.tipo.trim().slice(1).toLowerCase();
        document.getElementById('editarCategoriaModal').classList.add('active');
    }
    function closeEditarCategoriaModal() {
        document.getElementById('editarCategoriaModal').classList.remove('active');
    }

    const categorias = [
        <% if (categorias != null) for (Categoria categoria : categorias) { %>
        {
            id: <%= categoria.getId_categoria() %>,
            nome: "<%= categoria.getNome().replace("\"", "\\\"") %>",
            tipo: "<%= categoria.getTipo().replace("\"", "\\\"") %>"
        },
        <% } %>
    ];
    </script>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod()) && "criar".equals(request.getParameter("acao"))) {
            try {
                String nome = request.getParameter("nome");
                String tipo = request.getParameter("tipo");
                Categoria categoria = new Categoria(0, nome, tipo);
                boolean sucesso = categoriaDAO.inserir(categoria);
                if (sucesso) {
                    out.println("<script>Swal.fire('Sucesso!', 'Categoria criada com sucesso!', 'success').then(() => window.location.href = 'categoria.jsp');</script>");
                } else {
                    out.println("<script>Swal.fire('Erro!', 'Não foi possível criar a categoria.', 'error');</script>");
                }
            } catch(Exception e) {
                out.println("<script>Swal.fire('Erro!', 'Erro ao criar: " + e.getMessage() + "', 'error');</script>");
            }
        }

        if ("POST".equalsIgnoreCase(request.getMethod()) && "editar".equals(request.getParameter("acao"))) {
            try {
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                String nome = request.getParameter("nome");
                String tipo = request.getParameter("tipo");
                Categoria categoria = new Categoria(id, nome, tipo);
                boolean sucesso = categoriaDAO.alterar(categoria);
                if (sucesso) {
                    out.println("<script>Swal.fire('Sucesso!', 'Categoria atualizada com sucesso!', 'success').then(() => window.location.href = 'categoria.jsp');</script>");
                } else {
                    out.println("<script>Swal.fire('Erro!', 'Não foi possível atualizar a categoria.', 'error');</script>");
                }
            } catch(Exception e) {
                out.println("<script>Swal.fire('Erro!', 'Erro ao atualizar: " + e.getMessage() + "', 'error');</script>");
            }
        }

        if ("POST".equalsIgnoreCase(request.getMethod()) && "excluir".equals(request.getParameter("acao"))) {
            try {
                int id = Integer.parseInt(request.getParameter("idCategoria"));
                boolean sucesso = categoriaDAO.excluirPorId(id);
                if (sucesso) {
                    out.println("<script>Swal.fire('Sucesso!', 'Categoria excluída com sucesso!', 'success').then(() => window.location.href = 'categoria.jsp');</script>");
                } else {
                    out.println("<script>Swal.fire('Erro!', 'Não foi possível excluir a categoria.', 'error');</script>");
                }
            } catch(Exception e) {
                out.println("<script>Swal.fire('Erro!', 'Erro ao excluir: " + e.getMessage() + "', 'error');</script>");
            }
        }
    %>
</body>
</html>