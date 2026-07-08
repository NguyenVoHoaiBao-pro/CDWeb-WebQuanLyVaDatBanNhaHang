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
    <meta name="app-context" content="<%= ctx %>">
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
                    <a class="nav-link" href="<%= ctx %>/my-booking" data-nav>Lịch đặt</a>
                </li>
                <% if (u != null && !u.isGuest()) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= ctx %>/profile" data-nav>Hồ sơ</a>
                </li>
                <% } %>
            </ul>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <a href="<%= ctx %>/cart" class="btn btn-warning btn-nav position-relative" data-cart-target>
                    <i class="bi bi-cart3"></i> Giỏ hàng
                    <span class="cart-nav-badge d-none" data-cart-count>0</span>
                </a>

                <% if (u == null) { %>
                <a href="<%= ctx %>/login" class="btn btn-outline-custom btn-nav btn-sm">Đăng nhập</a>
                <a href="<%= ctx %>/register" class="btn btn-primary-custom btn-nav btn-sm">Đăng ký</a>
                <% } else { %>
                <% if (u.isGuest()) { %>
                <div class="user-badge d-none d-md-flex text-decoration-none text-light" style="cursor: default;">
                    <i class="bi bi-person-circle me-1"></i> <%= u.getFullName() %>
                </div>
                <% } else { %>
                <a href="<%= ctx %>/profile" class="user-badge d-none d-md-flex text-decoration-none">
                    <i class="bi bi-person-circle me-1"></i> <%= u.getUsername() %>
                    <% if (!vn.edu.hcmuaf.fit.util.AuthUtil.isIdentityVerified(u)) { %>
                    <span class="badge bg-warning text-dark ms-1" title="Chưa xác thực">!</span>
                    <% } %>
                </a>
                <% } %>
                <% if (vn.edu.hcmuaf.fit.util.UserRoles.isStaffRole(u.getRole())) { %>
                <a href="<%= ctx %>/staff" class="btn btn-info btn-nav btn-sm text-dark">Nhân viên</a>
                <% } %>
                <% if (vn.edu.hcmuaf.fit.util.UserRoles.isAdminRole(u.getRole())) { %>
                <a href="<%= ctx %>/admin" class="btn btn-danger btn-nav btn-sm">Admin</a>
                <% } %>
                <a href="<%= ctx %>/logout" class="btn btn-outline-custom btn-nav btn-sm">Đăng xuất</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<div class="nav-spacer"></div>

<a href="<%= ctx %>/cart" id="floatingCartBtn" class="floating-cart-btn" aria-label="Giỏ hàng" title="Giỏ hàng">
    <i class="bi bi-cart3"></i>
    <span class="floating-cart-badge d-none" data-cart-count>0</span>
</a>
