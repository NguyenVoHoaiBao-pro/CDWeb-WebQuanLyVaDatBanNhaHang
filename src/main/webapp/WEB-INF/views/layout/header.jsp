<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>

<%
    String ctx = request.getContextPath();
    User u = (User) session.getAttribute("user");
%>

<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Luxury Food</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body{
            padding-top:70px;
            background:#f8f9fa;
        }

        .navbar{
            backdrop-filter: blur(10px);
        }

        .navbar-brand{
            font-weight:bold;
            font-size:20px;
        }

        .nav-link{
            transition:0.3s;
        }

        .nav-link:hover{
            color:#ffc107 !important;
        }

        .btn-nav{
            border-radius:20px;
            padding:5px 12px;
        }

        .user-badge{
            background:#ffc107;
            padding:5px 12px;
            border-radius:20px;
            font-weight:bold;
        }
    </style>


</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow">
    <div class="container">

        ```
        <a class="navbar-brand" href="<%=ctx%>/">🍽 LUXURY FOOD</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="menuNav">

            <!-- MENU -->
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctx%>/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctx%>/menu">Thực đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctx%>/tables">Đặt bàn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%=ctx%>/my-booking">Booking</a>
                </li>
            </ul>

            <!-- RIGHT -->
            <div class="d-flex align-items-center gap-2">

                <% if(u==null){ %>

                <a href="<%=ctx%>/login" class="btn btn-outline-light btn-nav">Login</a>
                <a href="<%=ctx%>/register" class="btn btn-warning btn-nav">Register</a>

                <% } else { %>

                <div class="user-badge">👋 <%=u.getUsername()%></div>

                <% if("ADMIN".equals(u.getRole())){ %>
                <a href="<%=ctx%>/admin" class="btn btn-danger btn-nav">Admin</a>
                <% } %>

                <a href="<%=ctx%>/logout" class="btn btn-outline-light btn-nav">Logout</a>

                <% } %>

            </div>

        </div>
    </div>


</nav>
