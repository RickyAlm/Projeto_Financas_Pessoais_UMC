<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="stylesheet" href="../assets/css/styles.css">
  <link rel="stylesheet" href="../assets/css/loginCadastro.css">
  <link rel="stylesheet" href="../assets/css/fontePoppins.css">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
  <div class="container poppins-regular">
    <div class="login-container pulse">
      <div class="login-header">
        <h2><span class="poppins-regular texto-bemvindo">Bem-vindo ao </span><span class="poppins-medium-italic">Meu</span><span class="poppins-bold-italic">Bolso</span></h2>
      </div>
      <div class="login-body">
        <form method="post" action="loginUsuario.jsp">
          <div class="div-campo-input">
            <i class="fas fa-user"></i>
            <div class="form-floating">
              <input type="email" class="form-control ps-4" id="email" name="email" placeholder="name@example.com">
              <label for="email">E-mail</label>
            </div>
          </div>

          <div class="div-campo-input">
            <i class="fas fa-lock"></i>
            <div class="form-floating">
              <input type="password" class="form-control ps-4" id="senha" name="senha" placeholder="Senha">
              <label for="senha">Senha</label>
            </div>
          </div>

          <div class="d-flex justify-content-between mb-4">
            <div class="form-check lembre-me">
              <input class="form-check-input" type="checkbox" id="lembreMe">
              <label class="form-check-label poppins-regular" for="lembreMe">Lembrar-me</label>
            </div>
            <a href="#" class="esqueceu-senha poppins-regular">Esqueceu a senha?</a>
          </div>

          <button type="submit" class="btn btn-login mb-3 poppins-bold">ENTRAR</button>

          <!-- <div class="cadastre-se-div">
            <span class="cadastre-se-text">OU CONTINUE COM</span>
          </div>

          <div class="social-login">
            <a href="#" class="social-btn facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" class="social-btn google"><i class="fab fa-google"></i></a>
            <a href="#" class="social-btn instagram"><i class="fab fa-instagram"></i></a>
          </div> -->

          <div class="login-footer poppins-regular">
              Não tem uma conta? <a href="../cadastroUsuario/index.html" class="poppins-bold">Cadastre-se</a>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <%
    String erro = request.getParameter("erro");
    if ("1".equals(erro)) {
  %>
  <script>
    Swal.fire({
        icon: 'error',
        title: 'Erro no login',
        text: 'E-mail ou senha inválidos!',
        confirmButtonText: 'OK'
    });
  </script>
  <% } %>
</body>

</html>