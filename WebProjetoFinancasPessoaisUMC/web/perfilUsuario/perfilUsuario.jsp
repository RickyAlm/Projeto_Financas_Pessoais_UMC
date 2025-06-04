<%-- 
    Document   : perfilUsuario
    Created on : 16 de mai. de 2025, 19:50:32
    Author     : Henrique Vieira de Almeida
--%>

<%@page import="model.Usuario"%>
<%@page import="dao.UsuarioDAO"%>
<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Meu Perfil</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="../assets/css/styles.css">
        <link rel="stylesheet" href="../assets/css/perfilUsuario.css">
        <link rel="stylesheet" href="../assets/css/fontePoppins.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="../assets/js/logout.js"></script>
        <script src="../assets/js/redirecionar.js"></script>
<script>
    function confirmarExclusao() {
        Swal.fire({
            title: 'Tem certeza?',
            text: "Você está prestes a excluir sua conta permanentemente!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sim',
            cancelButtonText: 'Não'
        }).then((result) => {
            if (result.isConfirmed) {
                // Criar formulário dinâmico para enviar a confirmação
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'excluirUsuario.jsp';
                
                const confirmacaoInput = document.createElement('input');
                confirmacaoInput.type = 'hidden';
                confirmacaoInput.name = 'confirmacao';
                confirmacaoInput.value = 'true';
                form.appendChild(confirmacaoInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        });
    }
</script>
    </head>
        <body onload="ctrlRedirecionar.redirecionarURL(true)">
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
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
            if (usuario == null) {
                response.sendRedirect("../loginUsuario/index.jsp");
                return;
            }
            
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String acao = request.getParameter("acao");

                if ("atualizar".equals(acao)) {
                    usuario.setNome(request.getParameter("nome"));
                    usuario.setSobrenome(request.getParameter("sobrenome"));
                    usuario.setEmail(request.getParameter("email"));
                    usuario.setTelefone(request.getParameter("telefone"));
                    usuario.setDataNascimento(LocalDate.parse(request.getParameter("dataNascimento")));
                    
                    UsuarioDAO usuarioDAO = new UsuarioDAO();
                    boolean sucesso = usuarioDAO.alterar(usuario);
                    
                    if (sucesso) {
                        session.setAttribute("usuario", usuario);
                        out.println("<script>Swal.fire('Sucesso!', 'Dados atualizados com sucesso!', 'success');</script>");
                        out.println("<script>window.top.frames['menu_page'].location.href = '../menu.jsp?active=perfilUsuario';</script>");
                    } else {
                        out.println("<script>Swal.fire('Erro!', 'Falha ao atualizar dados!', 'error');</script>");
                    }
                } else if ("alterar-senha".equals(acao)) {
                    String senhaAtual = request.getParameter("senhaAtual");
                    String novaSenha = request.getParameter("novaSenha");
                    String confirmarSenha = request.getParameter("confirmarSenha");

                    String senhaAtualMD5 = md5(senhaAtual);
                    String novaSenhaMD5 = md5(novaSenha);
                    String confirmarSenhaMD5 = md5(confirmarSenha);

                    if (!usuario.getSenha().equals(senhaAtualMD5)) {
                        out.println("<script>Swal.fire('Erro!', 'Senha atual incorreta!', 'error');</script>");
                    } else if (novaSenha == null || novaSenha.trim().isEmpty()) {
                        out.println("<script>Swal.fire('Erro!', 'A nova senha não pode ser vazia!', 'error');</script>");
                    } else if (!novaSenhaMD5.equals(confirmarSenhaMD5)) {
                        out.println("<script>Swal.fire('Erro!', 'As novas senhas não coincidem!', 'error');</script>");
                    } else if (senhaAtualMD5.equals(novaSenhaMD5)) {
                        out.println("<script>Swal.fire('Erro!', 'A nova senha não pode ser igual à senha atual!', 'error');</script>");
                    } else {
                        usuario.setSenha(novaSenhaMD5);
                        UsuarioDAO usuarioDAO = new UsuarioDAO();
                        boolean sucesso = usuarioDAO.alterar(usuario);

                        if (sucesso) {
                            session.setAttribute("usuarioLogado", usuario);
                            out.println("<script>Swal.fire('Sucesso!', 'Senha alterada com sucesso!', 'success');</script>");
                        } else {
                            out.println("<script>Swal.fire('Erro!', 'Falha ao alterar senha!', 'error');</script>");
                        }
                    }
                }
            }
        %>
        
        <div class="main-content poppins-regular">
            <div class="profile-container">
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="profile-avatar"><%= usuario.getNome().charAt(0) %></div>
                        <h3 class="profile-name"><%= usuario.getNome() + " " + usuario.getSobrenome() %></h3>
                        <div class="profile-email"><%= usuario.getEmail() %></div>
                    </div>

                    <form method="post" action="perfilUsuario.jsp">
                        <input type="hidden" id="acaoInput" name="acao" value="atualizar">
                        <div class="profile-section">
                            <h4 class="section-title">Informações Pessoais</h4>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="div-campo-input mb-3">
                                        <i class="fas fa-user"></i>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="nome" name="nome" placeholder="Nome" value="<%= usuario.getNome() %>">
                                            <label for="nome">Nome</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="div-campo-input mb-3">
                                        <i class="fas fa-user"></i>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="sobrenome" name="sobrenome" placeholder="Sobrenome" value="<%= usuario.getSobrenome() %>">
                                            <label for="sobrenome">Sobrenome</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="div-campo-input mb-3">
                                <i class="fas fa-envelope"></i>
                                <div class="form-floating">
                                    <input type="email" class="form-control" id="email" name="email" placeholder="E-mail" value="<%= usuario.getEmail() %>">
                                    <label for="email">E-mail</label>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="div-campo-input mb-3">
                                        <i class="fas fa-phone"></i>
                                        <div class="form-floating">
                                            <input type="tel" class="form-control" id="telefone" name="telefone" placeholder="Telefone" value="<%= usuario.getTelefone() %>">
                                            <label for="telefone">Telefone</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="div-campo-input mb-3">
                                        <i class="fas fa-calendar"></i>
                                        <div class="form-floating">
                                            <input type="date" class="form-control" id="dataNascimento" name="dataNascimento" placeholder="Data de Nascimento" value="<%= usuario.getDataNascimento() %>">
                                            <label for="dataNascimento">Data de Nascimento</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="profile-section">
                            <h4 class="section-title">Alterar Senha</h4>

                            <div class="div-campo-input mb-3">
                                <i class="fas fa-lock"></i>
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="senhaAtual" name="senhaAtual" placeholder="">
                                    <label for="senhaAtual">Senha Atual</label>
                                </div>
                            </div>

                            <div class="div-campo-input mb-3">
                                <i class="fas fa-lock"></i>
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="novaSenha" name="novaSenha" placeholder="">
                                    <label for="novaSenha">Nova Senha</label>
                                </div>
                            </div>

                            <div class="div-campo-input mb-3">
                                <i class="fas fa-lock"></i>
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="confirmarSenha" name="confirmarSenha" placeholder="">
                                    <label for="confirmarSenha">Confirmar Nova Senha</label>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-cadastro" onclick="document.getElementById('acaoInput').value='alterar-senha'">
                                <i class="fas fa-key"></i> Alterar Senha
                            </button>
                        </div>

                        <div class="profile-actions">
                            <button id="btnLogout" type="button" class="btn btn-logout" onclick="ctrlLogout.logout()">
                                <i class="fas fa-sign-out-alt"></i>
                            </button>
                            <button type="submit" class="btn btn-cadastro" onclick="document.getElementById('acaoInput').value='atualizar'">
                                <i class="fas fa-save"></i> Atualizar Dados
                            </button>
                            <button type="button" class="btn btn-delete btn-delete-modal" onclick="confirmarExclusao()">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirmar Exclusão</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-delete btn-delete-modal" onclick="confirmarExclusao()">
                    <i class="fas fa-trash-alt"></i> Deletar Conta
                </button>
            </div>
        </div>
    </div>
</div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
