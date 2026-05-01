<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body class="bg-dark d-flex align-items-center justify-content-center" style="height:100vh;">

<div class="card p-4 shadow" style="width: 100%; max-width: 400px;">
    <h3 class="text-center mb-3">🍽 Đăng nhập</h3>

    <form action="<%=ctx%>/login" method="post">
        <input class="form-control mb-2" name="username" placeholder="Username">
        <input type="password" class="form-control mb-3" name="password" placeholder="Password">

        <button class="btn btn-primary w-100">Đăng nhập</button>
    </form>

    <p class="text-danger mt-2">${error}</p>

    <div class="text-center mt-3">
        <a href="<%=ctx%>/register">Chưa có tài khoản? Đăng ký</a>
    </div>
</div>

</body>
</html>