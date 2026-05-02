<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String ctx = request.getContextPath();
  String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      font-family: 'Segoe UI';
    }

    .hero {
      min-height: 100vh;
      background:
              linear-gradient(rgba(0,0,0,.6), rgba(0,0,0,.6)),
              url('https://images.unsplash.com/photo-1504674900247-0877df9cc836') center/cover;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .box {
      background: white;
      padding: 35px;
      border-radius: 20px;
      width: 400px;
      box-shadow: 0 15px 40px rgba(0,0,0,.2);
    }

    .social-btn {
      border-radius: 10px;
      font-weight: 600;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: 0.2s;
    }

    .social-btn:hover {
      transform: translateY(-2px);
      opacity: 0.9;
    }

    .divider {
      text-align: center;
      margin: 15px 0;
      font-size: 14px;
      color: #777;
    }
  </style>
</head>

<body>

<div class="hero">

  <div class="box">

    <h3 class="text-center mb-4">📝 Đăng ký</h3>

    <% if(error != null){ %>
    <div class="alert alert-danger"><%=error%></div>
    <% } %>

    <form action="<%=ctx%>/register" method="post">

      <input name="username"
             class="form-control mb-3"
             placeholder="Username"
             required>

      <input type="password"
             name="password"
             class="form-control mb-3"
             placeholder="Password"
             required>

      <input name="fullName"
             class="form-control mb-3"
             placeholder="Họ tên"
             required>

      <input type="email"
             name="email"
             class="form-control mb-3"
             placeholder="Email"
             required>

      <button class="btn btn-dark w-100 mb-2">
        Đăng ký
      </button>

    </form>

    <div class="divider">Hoặc đăng ký nhanh với</div>

    <a href="<%=ctx%>/oauth/google"
       class="btn btn-light w-100 mb-2 social-btn border">
      <img src="https://cdn-icons-png.flaticon.com/512/300/300221.png" width="20">
      Google
    </a>

    <a href="<%=ctx%>/oauth/facebook"
       class="btn btn-primary w-100 social-btn">
      <img src="https://cdn-icons-png.flaticon.com/512/124/124010.png" width="20">
      Facebook
    </a>

    <div class="text-center mt-3">
      Đã có tài khoản?
      <a href="<%=ctx%>/login">Đăng nhập</a>
    </div>

  </div>

</div>

</body>
</html>