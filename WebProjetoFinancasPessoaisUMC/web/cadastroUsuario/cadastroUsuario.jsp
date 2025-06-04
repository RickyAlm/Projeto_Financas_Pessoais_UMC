<%-- 
    Document   : cadastroUsuario
    Created on : 15 de mai. de 2025, 11:44:47
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="dao.UsuarioDAO"%>
<%@page import="model.Usuario"%>
<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cadastro de Usuários</title>
    </head>
    <body>
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

        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String nome = request.getParameter("nome");
                String sobrenome = request.getParameter("sobrenome");
                String email = request.getParameter("email");
                String telefone = request.getParameter("telefone");
                String dataNascimentoStr = request.getParameter("dataNascimento");
                String senha = request.getParameter("senha");
                String confirmarSenha = request.getParameter("confirmarSenha");
                String termos = request.getParameter("termos");

                if (nome == null || sobrenome == null || email == null || telefone == null || 
                    dataNascimentoStr == null || senha == null || confirmarSenha == null) {

                    out.println("<script>alert('Todos os campos são obrigatórios!');</script>");
                } 
                else if (termos == null) {
                    out.println("<script>alert('Você deve aceitar os termos de serviço!');</script>");
                }
                else if (!senha.equals(confirmarSenha)) {
                    out.println("<script>alert('As senhas não coincidem!');</script>");
                }
                else {
                    try {
                        UsuarioDAO dao = new UsuarioDAO();
                        Usuario existente = dao.buscarPorEmail(email);
                        if (existente != null) {
                            response.sendRedirect("index.html?erro=email");
                            return;
                        }

                        Usuario usuario = new Usuario();
                        usuario.setNome(nome);
                        usuario.setSobrenome(sobrenome);
                        usuario.setEmail(email);
                        usuario.setTelefone(telefone);
                        usuario.setDataNascimento(LocalDate.parse(dataNascimentoStr));
                        usuario.setSenha(md5(senha));

                        UsuarioDAO usuarioDAO = new UsuarioDAO();
                        boolean sucesso = usuarioDAO.inserir(usuario);

                        if (sucesso) {
                            response.sendRedirect("../loginUsuario/index.jsp");
                            return;
                        } else {
                            out.println("<script>alert('Erro ao cadastrar usuário!');</script>");
                        }
                    } catch (Exception e) {
                        out.println("<script>alert('Erro no cadastro: " + e.getMessage().replace("'", "\\'") + "');</script>");
                        e.printStackTrace();
                    }
                }
            }
        %>
    </body>
</html>
