<%-- 
    Document   : loginUsuario
    Created on : 15 de mai. de 2025, 16:08:44
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="model.Usuario"%>
<%@page import="dao.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Usuário</title>
    </head>
    <body>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String email = request.getParameter("email");
                String senha = request.getParameter("senha");

                if (email == null || email.isEmpty() || senha == null || senha.isEmpty()) {
                    out.println("<script><alert>E-mail e senha são obrigatórios!</alert></script>");
                } else {
                    try {
                        UsuarioDAO dao = new UsuarioDAO();
                        Usuario usuario = dao.buscarPorEmail(email);

                        if (usuario != null && usuario.getSenha().equals(senha)) {
                            session.setAttribute("usuarioLogado", usuario);
                            response.sendRedirect("../index.html");
                            return;
                        } else {
                            out.println("<script>alert('E-mail ou senha incorretos!');</script>");
                        }
                    } catch (Exception e) {
                        out.println("<script>alert('Erro no sistema. Por favor, tente novamente: ' + e);</script>");
                        e.printStackTrace();
                    }
                }
            }
        %>
    </body>
</html>
