<%-- 
    Document   : loginUsuario
    Created on : 15 de mai. de 2025, 16:08:44
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="model.Usuario"%>
<%@page import="dao.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%! 
    public static String md5(String input) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] array = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : array) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Usuário</title>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

                String senhaMD5 = md5(senha);

                if (usuario != null && usuario.getSenha().equals(senhaMD5)) {
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
        response.sendRedirect("index.jsp?erro=1");
        return;
    }
%>
    </body>
</html>
