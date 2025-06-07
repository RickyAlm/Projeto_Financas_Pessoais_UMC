<%-- 
    Document   : excluirUsuario
    Created on : 16 de mai. de 2025, 21:06:03
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="dao.UsuarioDAO"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <%
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
            if (usuario == null) {
                out.println("<script>"
                    + "Swal.fire({"
                    + "  icon: 'error',"
                    + "  title: 'Acesso não autorizado',"
                    + "  text: 'Você precisa estar logado para acessar esta página',"
                    + "}).then(() => { window.top.location.href = '../loginUsuario/index.jsp'; });"
                    + "</script>");
                return;
            }

            String confirmacao = request.getParameter("confirmacao");

            if (confirmacao == null || !confirmacao.equals("true")) {
                out.println("<script>"
                    + "Swal.fire({"
                    + "  icon: 'error',"
                    + "  title: 'Confirmação necessária',"
                    + "  text: 'Você precisa confirmar a exclusão da conta',"
                    + "}).then(() => { window.history.back(); });"
                    + "</script>");
                return;
            }
            
            try {
                UsuarioDAO usuarioDAO = new UsuarioDAO();
                
                boolean sucesso = usuarioDAO.excluirPorId(usuario.getIdUsuario());
                
                if (sucesso) {
                    session.invalidate();
                    out.println("<script>"
                        + "Swal.fire({"
                        + "  icon: 'success',"
                        + "  title: 'Conta excluída',"
                        + "  text: 'Sua conta foi excluída com sucesso',"
                        + "  showConfirmButton: true"
                        + "}).then(() => { window.top.nem location.href = '../loginUsuario/index.jsp'; });"
                        + "</script>");
                } else {
                    out.println("<script>"
                        + "Swal.fire({"
                        + "  icon: 'error',"
                        + "  title: 'Erro ao excluir',"
                        + "  text: 'Ocorreu um erro ao tentar excluir sua conta',"
                        + "}).then(() => { window.history.back(); });"
                        + "</script>");
                }
            } catch (Exception e) {
                out.println("<script>"
                    + "Swal.fire({"
                    + "  icon: 'error',"
                    + "  title: 'Erro inesperado',"
                    + "  text: 'Ocorreu um erro inesperado: " + e.getMessage().replace("'", "") + "',"
                    + "}).then(() => { window.history.back(); });"
                    + "</script>");
            }
        %>
    </body>
</html>