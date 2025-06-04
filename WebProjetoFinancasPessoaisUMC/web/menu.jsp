<%-- 
    Document   : menu.jsp
    Created on : 16 de mai. de 2025, 21:30:50
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String activePage = request.getParameter("active");
    if (activePage == null) activePage = "";

    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
%>
<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Menu Lateral</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="assets/css/fontePoppins.css">
        <link rel="stylesheet" href="assets/css/menu.css">
    </head>
    <body>
        <div class="d-flex flex-nowrap poppins-regular">
            <div class="sidebar d-flex flex-column flex-shrink-0">
                <div class="logo-area">
                    <a href="paginaInicial/index.html" target="main_page" aria-current="page"><img src="assets/img/MeuBolso-Nome.png" alt="Logo" class="logo"></a>
                </div>

                <div class="menu-items">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item <%= ("main".equals(activePage) || "".equals(activePage)) ? "active" : "" %>">
                            <a href="paginaInicial/index.html" target="main_page" class="nav-link poppins-regular" aria-current="page">
                                <i class="fas fa-home"></i>
                                <span class="poppins-regular">Página Inicial</span>
                            </a>
                        </li>

                        <% if (usuarioLogado != null) { %>
                            <li class="nav-item <%= "perfilUsuario".equals(activePage) ? "active" : "" %>">
                                <a href="perfilUsuario/perfilUsuario.jsp" target="main_page" class="nav-link">
                                    <i class="fas fa-user"></i>
                                    <span>Meu Perfil</span>
                                </a>
                            </li>
                            <% if (usuarioLogado.isAdmin()) { %>
                            <li class="nav-item <%= "adminUsuarios".equals(activePage) ? "active" : "" %>">
                                <a href="adminUsuario/adminUsuarios.jsp" target="main_page" class="nav-link">
                                    <i class="fas fa-users-cog"></i>
                                    <span>Lista de Usuários</span>
                                </a>
                            </li>
                            <% } %>
                            <li class="nav-item">
                                <a href="minhasFinancas/index.jsp" target="main_page" class="nav-link">
                                    <i class="fas fa-wallet"></i>
                                    <span>Minhas Finanças</span>
                                </a>
                            </li>
                        <% } else { %>
                            <li class="nav-item">
                                <a href="loginUsuario/index.jsp" target="_top" class="nav-link">
                                    <i class="fas fa-user"></i>
                                    <span>Meu Perfil</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="loginUsuario/index.jsp" target="_top" class="nav-link">
                                    <i class="fas fa-users-cog"></i>
                                    <span>Lista de Usuários</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="loginUsuario/index.jsp" target="_top" class="nav-link">
                                    <i class="fas fa-wallet"></i>
                                    <span>Minhas Finanças</span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>

                <div class="user-area mt-auto">
                    <% if (usuarioLogado != null) { %>
                        <div class="user-avatar"><%= usuarioLogado.getNome().charAt(0) %></div>
                        <div class="user-info">
                            <div class="user-name"><%= usuarioLogado.getNome() %></div>
                            <div class="user-role"><%= usuarioLogado.getTipo().toString().equals("admin") ? "Administrador" : "Usuário" %></div>
                        </div>
                        <a href="perfilUsuario/logout.jsp" class="text-white">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>
                    <% } else { %>
                        <button class="btn btn-primary w-100" onclick="window.top.location.href='loginUsuario/index.jsp'">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sessão
                        </button>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script defer src="assets/js/sidebars.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const navLinks = document.querySelectorAll('.nav-item');

                function setActiveItem() {
                    navLinks.forEach(link => {            
                        if (link.getAttribute('href') === window.location.hash || 
                            link.getAttribute('href') === window.location.pathname) {
                            link.classList.add('active');
                        }
                    });
                }

                setActiveItem();

                navLinks.forEach(link => {
                    link.addEventListener('click', function(e) {
                        navLinks.forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    });
                });
            });
        </script>
    </body>
</html>
