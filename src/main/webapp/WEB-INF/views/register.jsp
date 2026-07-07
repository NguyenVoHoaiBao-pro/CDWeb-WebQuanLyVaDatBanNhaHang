<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký — Nhà Hàng Của Chúng Ta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body class="site-body">

<div class="auth-page">
    <div class="auth-card glass-card">
        <div class="auth-logo">📝</div>
        <h3>Đăng ký tài khoản</h3>

        <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="<%= ctx %>/register" method="post">
            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input name="username" class="form-control" placeholder="Username" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Họ tên</label>
                <input name="fullName" class="form-control" placeholder="Họ tên" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" placeholder="Email" required>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100 mb-3">Đăng ký</button>
        </form>

        <div class="auth-divider">Hoặc đăng ký nhanh với</div>

        <a href="<%= ctx %>/oauth/google" class="btn btn-dark w-100 social-btn">
            <img src="https://cdn-icons-png.flaticon.com/512/300/300221.png" width="20" alt="">
            Google
        </a>

        <div class="text-center mt-4 text-muted">
            Đã có tài khoản?
            <a href="<%= ctx %>/login" class="text-warning fw-semibold">Đăng nhập</a>
        </div>

        <div class="text-center mt-3">
            <a href="<%= ctx %>/" class="text-muted small"><i class="bi bi-arrow-left"></i> Về trang chủ</a>
        </div>
    </div>
</div>

</body>
</html>
