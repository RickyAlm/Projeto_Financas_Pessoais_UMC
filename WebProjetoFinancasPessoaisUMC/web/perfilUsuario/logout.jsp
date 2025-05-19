<%-- 
    Document   : logout.jsp
    Created on : 16 de mai. de 2025, 21:01:48
    Author     : Rick
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    session.invalidate();
    
    Cookie cookie = new Cookie("idSessao", "");
    cookie.setPath("/");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
%>
<html>
<head>
    <title>Saindo...</title>
    <script>
        window.top.location.href = "<%= request.getContextPath() %>/loginUsuario/index.html";
    </script>
</head>
<body>
    <p>Por favor aguarde, você está sendo desconectado...</p>
</body>
</html>
