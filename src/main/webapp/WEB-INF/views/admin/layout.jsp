<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Admin</title>

    <!-- BOOTSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
    <!-- ICON -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar" id="sidebar">
    <h4>🍽 ADMIN</h4>

    <a href="${pageContext.request.contextPath}/admin">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/admin/products">
        <i class="bi bi-basket"></i> Products
    </a>

    <a href="${pageContext.request.contextPath}/admin/users">
        <i class="bi bi-people"></i> Users
    </a>

    <a href="${pageContext.request.contextPath}/admin/tables">
        <i class="bi bi-grid"></i> Tables
    </a>

    <a href="${pageContext.request.contextPath}/admin/reservations">
        <i class="bi bi-calendar-check"></i> Reservations
    </a>

    <a href="${pageContext.request.contextPath}/logout">
        <i class="bi bi-box-arrow-right"></i> Logout
    </a>
</div>

<!-- CONTENT -->
<div class="content">

    <!-- MOBILE BUTTON -->
    <div class="menu-btn" onclick="toggleMenu()">
        ☰
    </div>

    <!-- LOAD PAGE -->
<%--    <jsp:include page="<%=pageFile%>" />--%>
    <jsp:include page="${page}" />

</div>

<script>
    function toggleMenu(){
        document.getElementById("sidebar")
            .classList.toggle("active");
    }
</script>

</body>
</html>