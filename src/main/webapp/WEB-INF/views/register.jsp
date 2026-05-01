<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Đăng ký</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container">
  <div class="row justify-content-center mt-5">
    <div class="col-md-4">

      <div class="card shadow p-4">
        <h3 class="text-center mb-3">Đăng ký</h3>

        <form action="register" method="post">
          <input class="form-control mb-2" name="username" placeholder="Username" required>
          <input class="form-control mb-2" type="password" name="password" placeholder="Password" required>
          <input class="form-control mb-2" name="fullName" placeholder="Họ tên">
          <input class="form-control mb-2" type="email" name="email" placeholder="Email">

          <button class="btn btn-primary w-100">Đăng ký</button>
        </form>

        <p class="text-danger mt-2">${error}</p>

        <div class="text-center mt-2">
          <a href="login">Đã có tài khoản? Đăng nhập</a>
        </div>
      </div>

    </div>
  </div>
</div>

</body>
</html>