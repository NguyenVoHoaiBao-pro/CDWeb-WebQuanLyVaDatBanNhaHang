<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Object totalUsers = request.getAttribute("totalUsers");
    Object totalProducts = request.getAttribute("totalProducts");
    Object totalTables = request.getAttribute("totalTables");
    Object totalReservations = request.getAttribute("totalReservations");
%>

<style>

    .card-stat {
        border-radius: 16px;
        padding: 20px;
        background: white;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        transition: 0.3s;
        height: 100%;
    }

    .card-stat:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
    }

    .stat-icon {
        font-size: 28px;
        margin-bottom: 10px;
    }

    .stat-number {
        font-size: 28px;
        font-weight: bold;
    }

    .quick-btn {
        border-radius: 12px;
        padding: 12px;
        font-weight: 600;
        transition: 0.25s;
    }

    .quick-btn:hover {
        transform: scale(1.05);
    }

</style>

<h2 class="fw-bold mb-4">📊 Dashboard</h2>

<div class="row g-3">

    <!-- USERS -->
    <div class="col-6 col-md-3">
        <div class="card-stat text-center">
            <div class="stat-icon text-primary">👤</div>
            <div>Người dùng</div>
            <div class="stat-number text-primary"><%=totalUsers%>
            </div>
        </div>
    </div>

    <!-- PRODUCTS -->
    <div class="col-6 col-md-3">
        <div class="card-stat text-center">
            <div class="stat-icon text-success">🍽</div>
            <div>Sản phẩm</div>
            <div class="stat-number text-success"><%=totalProducts%>
            </div>
        </div>
    </div>

    <!-- TABLES -->
    <div class="col-6 col-md-3">
        <div class="card-stat text-center">
            <div class="stat-icon text-warning">🪑</div>
            <div>Bàn</div>
            <div class="stat-number text-warning"><%=totalTables%>
            </div>
        </div>
    </div>

    <!-- RESERVATIONS -->
    <div class="col-6 col-md-3">
        <div class="card-stat text-center">
            <div class="stat-icon text-danger">📅</div>
            <div>Bàn đã đặt</div>
            <div class="stat-number text-danger"><%=totalReservations%>
            </div>
        </div>
    </div>

</div>

<hr class="my-4">

<h4 class="fw-bold mb-3">⚡ Phím tắt</h4>

<div class="row g-3">

    <div class="col-6 col-md-3">
        <a href="${pageContext.request.contextPath}/admin/users"
           class="btn btn-success w-100 quick-btn">
            👤 Quản lý người dùng
        </a>
    </div>

    <div class="col-6 col-md-3">
        <a href="${pageContext.request.contextPath}/admin/products"
           class="btn btn-primary w-100 quick-btn">
            🍽 Quản lý sản phẩm
        </a>
    </div>
    <div class="col-6 col-md-3">
        <a href="${pageContext.request.contextPath}/admin/tables"
           class="btn btn-warning w-100 quick-btn">
            🪑 Quản lý bàn đã đặt
        </a>
    </div>

    <div class="col-6 col-md-3">
        <a href="${pageContext.request.contextPath}/admin/reservations"
           class="btn btn-danger w-100 quick-btn">
            📅 Quản lý đặt bàn
        </a>
    </div>

</div>