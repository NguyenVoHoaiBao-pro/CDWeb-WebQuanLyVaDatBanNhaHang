<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>

<%
    String ctx = request.getContextPath();
    User u = (User) session.getAttribute("user");
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Nhà Hàng Của Chúng Ta";
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= pageTitle %></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>

<body class="site-body">

<nav class="navbar navbar-expand-lg navbar-dark luxury-nav fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<%= ctx %>/">
            <span>🍽</span> Nhà Hàng <span>Của Chúng Ta</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#menuNav" aria-label="Menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="menuNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%= ctx %>/" data-nav>Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= ctx %>/menu" data-nav>Thực đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= ctx %>/tables" data-nav>Đặt bàn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= ctx %>/my-booking" data-nav>Booking</a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <a href="<%= ctx %>/cart" class="btn btn-warning btn-nav">
                    <i class="bi bi-cart3"></i> Giỏ hàng
                </a>

                <% if (u == null) { %>
                <a href="<%= ctx %>/login" class="btn btn-outline-custom btn-nav btn-sm">Đăng nhập</a>
                <a href="<%= ctx %>/register" class="btn btn-primary-custom btn-nav btn-sm">Đăng ký</a>
                <% } else { %>
                <div class="user-badge d-none d-md-flex">
                    <i class="bi bi-person-circle me-1"></i> <%= u.getUsername() %>
                </div>
                <% if ("ADMIN".equals(u.getRole())) { %>
                <a href="<%= ctx %>/admin" class="btn btn-danger btn-nav btn-sm">Admin</a>
                <% } %>
                <a href="<%= ctx %>/logout" class="btn btn-outline-custom btn-nav btn-sm">Đăng xuất</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<div class="nav-spacer"></div>
