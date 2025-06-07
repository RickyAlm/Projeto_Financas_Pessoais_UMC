<%-- 
    Document   : adminUsuarios
    Created on : 17 de mai. de 2025, 18:29:17
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="java.util.List"%>
<%@page import="model.Usuario"%>
<%@page import="dao.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../loginUsuario/verificaLogin.jsp"%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administração de Usuários</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/fontePoppins.css">
    <link rel="stylesheet" href="../assets/css/styles.css">
    <link rel="stylesheet" href="../assets/css/adminUsuarios.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../assets/js/redirecionar.js"></script>
    <%
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        List<Usuario> usuarios = null;

        String filtroStatus = request.getParameter("status") != null ? request.getParameter("status") : "todos";
        String filtroTipo = request.getParameter("tipo") != null ? request.getParameter("tipo") : "todos";
        String busca = request.getParameter("busca") != null ? request.getParameter("busca") : "";

        try {
            usuarios = usuarioDAO.consultarComFiltro(filtroStatus, filtroTipo, busca);
        } catch(Exception e) {
            out.println("<script>Swal.fire('Erro!', 'Erro ao carregar usuários: " + e.getMessage() + "', 'error');</script>");
        }

        if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("acao") != null && request.getParameter("acao").equals("excluir")) {
            try {
                int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                boolean sucesso = usuarioDAO.excluirPorId(idUsuario);

                if (sucesso) {
                    out.println("<script>Swal.fire('Sucesso!', 'Usuário excluído com sucesso!', 'success').then(() => window.location.href = 'adminUsuarios.jsp');</script>");
                } else {
                    out.println("<script>Swal.fire('Erro!', 'Não foi possível excluir o usuário.', 'error');</script>");
                }
            } catch(Exception e) {
                out.println("<script>Swal.fire('Erro!', 'Ocorreu um erro ao excluir: " + e.getMessage() + "', 'error');</script>");
            }
        }

        if (request.getMethod().equalsIgnoreCase("POST") && "editar".equals(request.getParameter("acao"))) {
            try {
                Integer idUsuarioEdit = Integer.parseInt(request.getParameter("idUsuario"));
                String nome = request.getParameter("nome");
                String sobrenome = request.getParameter("sobrenome");
                String email = request.getParameter("email");
                String tipo = request.getParameter("tipo");
                String status = request.getParameter("status");

                Usuario usuarioEdit = usuarioDAO.consultarPorId(idUsuarioEdit);
                if (usuarioEdit != null) {
                    usuarioEdit.setNome(nome);
                    usuarioEdit.setSobrenome(sobrenome);
                    usuarioEdit.setEmail(email);
                    usuarioEdit.setTipo("admin".equals(tipo) ? Usuario.TipoUsuario.admin : Usuario.TipoUsuario.comum);
                    usuarioEdit.setAtivo("ativo".equals(status));
                    boolean sucesso = usuarioDAO.alterar(usuarioEdit);

                    Integer idUsuarioLogado = usuarioLogado != null ? usuarioLogado.getIdUsuario() : null;
                    if (sucesso) {
                        if (idUsuarioLogado != null && idUsuarioLogado.equals(usuarioEdit.getIdUsuario())) {
                            String tipoAntigo = usuarioLogado.getTipo().toString();
                            String tipoNovo = usuarioEdit.getTipo().toString();
                            if (!tipoAntigo.equals(tipoNovo)) {
                                session.invalidate();
                            %>
                            <script>
                                document.cookie.split(";").forEach(function(c) {
                                    document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/");
                                });
                                
                                if (window.top) {
                                    window.top.location.href = '/WebProjetoFinancasPessoaisUMC/loginUsuario/index.jsp';
                                } else {
                                    window.location.href = '/WebProjetoFinancasPessoaisUMC/loginUsuario/index.jsp';
                                }
                            </script>
                            <%
                            } else {
                                session.setAttribute("usuarioLogado", usuarioEdit);
                                out.println("<script>Swal.fire('Sucesso!', 'Usuário editado com sucesso!', 'success').then(() => { window.location.href = 'adminUsuarios.jsp'; window.top.frames['menu_page'].location.href = '../menu.jsp?active=adminUsuarios'; });</script>");
                            }
                        } else {
                            out.println("<script>Swal.fire('Sucesso!', 'Usuário editado com sucesso!', 'success').then(() => { window.location.href = 'adminUsuarios.jsp'; window.top.frames['menu_page'].location.href = '../menu.jsp?active=adminUsuarios'; });</script>");
                        }
                    } else {
                        out.println("<script>Swal.fire('Erro!', 'Não foi possível editar o usuário.', 'error');</script>");
                    }
                } else {
                    out.println("<script>Swal.fire('Erro!', 'Usuário não encontrado.', 'error');</script>");
                }
            } catch(Exception e) {
                out.println("<script>Swal.fire('Erro!', 'Ocorreu um erro ao editar: " + e.getMessage() + "', 'error');</script>");
            }
        }
    %>
</head>
<body onload="ctrlRedirecionar.redirecionarURL(true)">
    <div class="main-content poppins-regular">
        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-header">
                    <h2><i class="fas fa-users-cog"></i> Administração de Usuários</h2>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-filter"></i> Filtros</h5>
                    </div>
                    <div class="card-body">
                        <form method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Buscar</label>
                                <input type="text" name="busca" class="form-control campo-busca" placeholder="Nome ou Email" value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select">
                                    <option value="todos" <%= "todos".equals(filtroStatus) ? "selected" : "" %>>Todos</option>
                                    <option value="ativos" <%= "ativos".equals(filtroStatus) ? "selected" : "" %>>Ativos</option>
                                    <option value="inativos" <%= "inativos".equals(filtroStatus) ? "selected" : "" %>>Inativos</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tipo</label>
                                <select name="tipo" class="form-select">
                                    <option value="todos" <%= "todos".equals(filtroTipo) ? "selected" : "" %>>Todos</option>
                                    <option value="admin" <%= "admin".equals(filtroTipo) ? "selected" : "" %>>Administradores</option>
                                    <option value="comum" <%= "comum".equals(filtroTipo) ? "selected" : "" %>>Usuários Comuns</option>
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
                                    <!-- <th>ID</th> -->
                                    <th>Nome</th>
                                    <th>Email</th>
                                    <th>Tipo</th>
                                    <th>Status</th>
                                    <th>Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (usuarios == null) { %>
                                <tr>
                                    <td colspan="6" class="text-center text-danger">Erro ao carregar lista de usuários</td>
                                </tr>
                                <% } else if (usuarios.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="text-center">Nenhum usuário encontrado</td>
                                </tr>
                                <% } else { 
                                    for (Usuario usuario : usuarios) { 
                                %>
                                <tr>
                                    <!-- <td><%= usuario.getIdUsuario() %></td> -->
                                    <td><%= usuario.getNome() %> <%= usuario.getSobrenome() %></td>
                                    <td><%= usuario.getEmail() %></td>
                                    <td>
                                        <span class="badge <%= usuario.isAdmin() ? "bg-warning" : "bg-secondary" %>">
                                            <%= usuario.isAdmin() ? "Administrador" : "Comum" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= usuario.isAtivo() ? "bg-success" : "bg-secondary" %>">
                                            <%= usuario.isAtivo() ? "Ativo" : "Inativo" %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="javascript:void(0);" 
                                            class="btn btn-primary btn-sm" 
                                            title="Editar"
                                            onclick="abrirModalEditarUsuario(<%= usuario.getIdUsuario() %>)">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form method="post" style="display: inline;" id="formExcluir<%= usuario.getIdUsuario() %>">
                                            <input type="hidden" name="acao" value="excluir">
                                            <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">
                                            <button type="button" class="btn btn-danger btn-sm btn-excluir" 
                                                    onclick="confirmarExclusao(<%= usuario.getIdUsuario() %>)"
                                                    title="Excluir">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% 
                                    } 
                                } 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de Edição de Usuário -->
    <div class="modal-overlay" id="usuarioModal">
        <div class="modal-container">
            <form id="formEditarUsuario" method="post" action="adminUsuarios.jsp">
                <input type="hidden" name="acao" value="editar">
                <input type="hidden" id="editUsuarioId" name="idUsuario">
                <div class="modal-header">
                    <h2>Editar Usuário</h2>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editNome">Nome</label>
                        <input type="text" id="editNome" name="nome" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editSobrenome">Sobrenome</label>
                        <input type="text" id="editSobrenome" name="sobrenome" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editEmail">Email</label>
                        <input type="email" id="editEmail" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="editTipo">Tipo</label>
                        <select id="editTipo" name="tipo" class="form-select" required>
                            <option value="admin">Administrador</option>
                            <option value="comum">Comum</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Status</label>
                        <select id="editStatus" name="status" class="form-select" required>
                            <option value="ativo">Ativo</option>
                            <option value="inativo">Inativo</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeUsuarioModal()">Cancelar</button>
                    <button type="submit" class="btn btn-save">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function confirmarExclusao(idUsuario) {
        Swal.fire({
            title: 'Tem certeza?',
            text: "Você está prestes a excluir este usuário permanentemente!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sim',
            cancelButtonText: 'Não'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('formExcluir' + idUsuario).submit();
            }
        });
    }

    function abrirModalEditarUsuario(idUsuario) {
        const usuario = usuarios.find(u => u.id === idUsuario);
        if (!usuario) {
            Swal.fire('Erro', 'Usuário não encontrado!', 'error');
            return;
        }
        document.getElementById('editUsuarioId').value = usuario.id;
        document.getElementById('editNome').value = usuario.nome;
        document.getElementById('editSobrenome').value = usuario.sobrenome;
        document.getElementById('editEmail').value = usuario.email;
        document.getElementById('editTipo').value = usuario.tipo;
        document.getElementById('editStatus').value = usuario.status;
        document.getElementById('usuarioModal').classList.add('active');
    }

    function closeUsuarioModal() {
        document.getElementById('usuarioModal').classList.remove('active');
    }

    const usuarios = [
        <% for (Usuario usuario : usuarios) { %>
        {
            id: <%= usuario.getIdUsuario() %>,
            nome: "<%= usuario.getNome().replace("\"", "\\\"") %>",
            sobrenome: "<%= usuario.getSobrenome().replace("\"", "\\\"") %>",
            email: "<%= usuario.getEmail().replace("\"", "\\\"") %>",
            tipo: "<%= usuario.isAdmin() ? "admin" : "comum" %>",
            status: "<%= usuario.isAtivo() ? "ativo" : "inativo" %>"
        },
        <% } %>
    ];
    </script>
</body>
</html>