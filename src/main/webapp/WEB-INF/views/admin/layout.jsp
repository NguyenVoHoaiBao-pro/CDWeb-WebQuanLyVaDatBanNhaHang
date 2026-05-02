<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String pageFile = (String) request.getAttribute("page");
    if(pageFile == null) pageFile = "dashboard.jsp";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Admin</title>

    <!-- BOOTSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ICON -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>

        body{
            background:#f1f5f9;
            font-family: 'Segoe UI', sans-serif;
        }

        /* SIDEBAR */
        .sidebar{
            width:250px;
            height:100vh;
            position:fixed;
            left:0;
            top:0;
            background:#0f172a;
            padding-top:20px;
            transition:.3s;
            z-index:1000;
        }

        .sidebar h4{
            color:#fff;
            text-align:center;
            margin-bottom:30px;
        }

        .sidebar a{
            display:flex;
            align-items:center;
            gap:10px;
            color:#cbd5f5;
            padding:14px 20px;
            text-decoration:none;
            transition:.2s;
        }

        .sidebar a:hover{
            background:#1e293b;
            color:#fff;
            transform:translateX(5px);
        }

        /* CONTENT */
        .content{
            margin-left:250px;
            padding:30px;
            transition:.3s;
        }

        /* MOBILE */
        @media(max-width:768px){

            .sidebar{
                left:-250px;
            }

            .sidebar.active{
                left:0;
            }

            .content{
                margin-left:0;
                padding:20px;
            }

            .menu-btn{
                display:block;
            }
        }

        .menu-btn{
            display:none;
            font-size:24px;
            cursor:pointer;
            margin-bottom:15px;
        }

        /* CARD */
        .card-box{
            border:none;
            border-radius:18px;
            padding:20px;
            background:white;
            box-shadow:0 10px 25px rgba(0,0,0,.08);
            transition:.3s;
        }

        .card-box:hover{
            transform:translateY(-5px);
        }

        /* FORM */
        .form-control{
            border-radius:10px;
            padding:10px;
        }

        .btn{
            border-radius:10px;
        }

        /* TABLE */
        table{
            border-radius:12px;
            overflow:hidden;
        }

    </style>
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
    <jsp:include page="<%=pageFile%>" />

</div>

<script>
    function toggleMenu(){
        document.getElementById("sidebar").classList.toggle("active");
    }
</script>

</body>
</html>