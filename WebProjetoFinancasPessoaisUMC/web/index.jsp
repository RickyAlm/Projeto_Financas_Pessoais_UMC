<%-- 
    Document   : index.jsp
    Created on : 16 de mai. de 2025, 22:30:14
    Author     : Rick
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="loginUsuario/verificaLogin.jsp"%>
<html>
    <head>
        <title>Sistema</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <frameset cols="250, *" noresize="noresize" frameborder="0">
        <frame src="menu.jsp" name="menu_page"/>
        <frame src="main.html" name="main_page"/>         
        <noframes>
            <body>
                <div>Seu Browser não suporta frames.</div>
            </body>
        </noframes>
    </frameset>
</html>