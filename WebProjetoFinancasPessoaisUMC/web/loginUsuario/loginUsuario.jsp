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

        if (email != null && !email.isEmpty() && senha != null && !senha.isEmpty()) {
            try {
                UsuarioDAO dao = new UsuarioDAO();
                Usuario usuario = dao.buscarPorEmail(email);

                if (usuario != null && usuario.getSenha().equals(senha)) {
                    // Cria o cookie de sessão
                    Cookie cookieSessao = new Cookie("idSessao", session.getId());
                    cookieSessao.setMaxAge(60 * 60 * 24);
                    cookieSessao.setPath("/");
                    response.addCookie(cookieSessao);
                    
                    // Armazena o usuário na sessão
                    session.setAttribute("usuarioLogado", usuario);
                    response.sendRedirect("../index.html");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("loginUsuario.jsp?erro=1");
    }
%>
    </body>
</html>
