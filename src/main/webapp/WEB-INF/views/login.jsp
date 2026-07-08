<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String registered = request.getParameter("registered");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập — Nhà Hàng Của Chúng Ta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body class="site-body">

<div class="auth-page">
    <div class="auth-card glass-card">
        <div class="auth-logo">🔐</div>
        <h3>Đăng nhập</h3>

        <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <% if ("true".equals(registered)) { %>
        <div class="alert alert-success">Đăng ký thành công! Bạn có thể đăng nhập ngay.</div>
        <% } %>

        <form action="<%= ctx %>/login" method="post">
            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input class="form-control"
                       name="username"
                       placeholder="Username"
                       autocomplete="username"
                       required>
            </div>

            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password"
                       class="form-control"
                       name="password"
                       placeholder="Password"
                       autocomplete="current-password"
                       required>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 mb-3">
                Đăng nhập
            </button>
        </form>

        <div class="auth-divider">Hoặc đăng nhập với</div>

        <a href="<%= ctx %>/oauth/google" class="btn btn-dark w-100 social-btn">
            <img src="https://cdn-icons-png.flaticon.com/512/300/300221.png" width="20" alt="">
            Google
        </a>

        <div class="text-center mt-4 text-muted">
            Chưa có tài khoản?
            <a href="<%= ctx %>/register" class="text-warning fw-semibold">Đăng ký</a>
        </div>

        <div class="text-center mt-3">
            <a href="<%= ctx %>/" class="text-muted small"><i class="bi bi-arrow-left"></i> Về trang chủ</a>
        </div>
    </div>
</div>

</body>
</html>
