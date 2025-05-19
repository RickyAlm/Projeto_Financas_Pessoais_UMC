<%-- 
    Document   : excluirUsuario
    Created on : 16 de mai. de 2025, 21:06:03
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Cookie[] cookies = request.getCookies();
            String idSessao = null;

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("idSessao")) {
                        idSessao = cookie.getValue();
                        break;
                    }
                }
            }

            // Se não encontrou cookie ou a sessão é inválida
            if (idSessao == null || session.isNew() || !session.getId().equals(idSessao) 
                    || session.getAttribute("usuarioLogado") == null) {
                session.invalidate();
                response.sendRedirect("loginUsuario/index.html");
                return;
            }

            Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
            request.setAttribute("usuarioLogado", usuarioLogado);
        %>
    </body>
</html>