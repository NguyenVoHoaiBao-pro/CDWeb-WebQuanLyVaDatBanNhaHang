<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>

<div class="admin-sidebar" id="adminSidebar">
    <h4><i class="bi bi-shop"></i> Admin Panel</h4>

    <a href="<%= ctx %>/admin" data-admin-nav="/admin">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="<%= ctx %>/admin/products" data-admin-nav="/admin/products">
        <i class="bi bi-basket"></i> Sản phẩm
    </a>
    <a href="<%= ctx %>/admin/users" data-admin-nav="/admin/users">
        <i class="bi bi-people"></i> Người dùng
    </a>
    <a href="<%= ctx %>/admin/tables" data-admin-nav="/admin/tables">
        <i class="bi bi-grid"></i> Quản lý bàn
    </a>
    <a href="<%= ctx %>/admin/reservations" data-admin-nav="/admin/reservations">
        <i class="bi bi-calendar-check"></i> Đặt bàn
    </a>
    <a href="<%= ctx %>/staff" data-admin-nav="/staff">
        <i class="bi bi-person-workspace"></i> Khu vực nhân viên
    </a>
    <a href="<%= ctx %>/" data-admin-nav>
        <i class="bi bi-house"></i> Về trang chủ
    </a>
    <a href="<%= ctx %>/logout">
        <i class="bi bi-box-arrow-right"></i> Đăng xuất
    </a>
</div>

<button type="button" class="admin-menu-btn" onclick="toggleAdminMenu()" aria-label="Menu">
    <i class="bi bi-list"></i>
</button>
