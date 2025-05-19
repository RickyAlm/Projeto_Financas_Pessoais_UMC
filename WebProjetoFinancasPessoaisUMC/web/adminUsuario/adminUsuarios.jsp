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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administração de Usuários</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/styles.css">
    <link rel="stylesheet" href="../assets/css/adminUsuarios.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../assets/js/redirecionar.js"></script>
    <%
UsuarioDAO usuarioDAO = new UsuarioDAO();
List<Usuario> usuarios = null;

try {
    usuarios = usuarioDAO.consultarTodos();
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
%>
</head>
<body onload="ctrlRedirecionar.redirecionarURL(true)">
    <div class="main-content">
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
                            <div class="col-md-4">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select">
                                    <option value="todos">Todos</option>
                                    <option value="ativos">Ativos</option>
                                    <option value="inativos">Inativos</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tipo</label>
                                <select name="tipo" class="form-select">
                                    <option value="todos">Todos</option>
                                    <option value="admin">Administradores</option>
                                    <option value="comum">Usuários Comuns</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary">
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
                                    <th>ID</th>
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
                                    <td><%= usuario.getIdUsuario() %></td>
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
                                        <a href="editarUsuario.jsp?id=<%= usuario.getIdUsuario() %>" 
                                           class="btn btn-primary btn-sm" title="Editar">
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
    </script>
</body>
</html>