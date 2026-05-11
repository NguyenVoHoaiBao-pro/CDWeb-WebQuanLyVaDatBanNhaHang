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
    <link rel="stylesheet"
          href="<%=ctx%>/css/style.css">
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark luxury-nav fixed-top">
    <div class="container">

        <a class="navbar-brand" href="<%=ctx%>/">🍽 LUXURY FOOD</a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#menuNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="menuNav">

            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/menu">Thực đơn</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/tables">Đặt bàn</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/my-booking">Booking</a></li>
            </ul>

            <div class="d-flex gap-2">

                <a href="<%=ctx%>/cart" class="btn btn-warning btn-nav">🛒 Cart</a>

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


<!-- FIX CONTENT BỊ CHE -->
<div style="height:80px;"></div>
