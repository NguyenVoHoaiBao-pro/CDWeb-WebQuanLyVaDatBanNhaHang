<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String ctx = request.getContextPath();

    Object totalUsers = request.getAttribute("totalUsers");
    Object totalProducts = request.getAttribute("totalProducts");
    Object totalTables = request.getAttribute("totalTables");
    Object totalReservations = request.getAttribute("totalReservations");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Admin Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{
            background:#f8fafc;
            font-family:Segoe UI;
        }

        .top{
            height:280px;
            background:
                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),
                    url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4') center/cover;
            display:flex;
            align-items:center;
            justify-content:center;
            text-align:center;
            color:white;
        }

        .top h1{
            font-size:56px;
            font-weight:900;
        }

        .panel{
            background:white;
            padding:28px;
            border-radius:24px;
            box-shadow:0 15px 35px rgba(0,0,0,.08);
            margin-top:-55px;
            position:relative;
            z-index:9;
        }

        .card-box{
            border:none;
            border-radius:24px;
            padding:30px;
            color:white;
            box-shadow:0 15px 35px rgba(0,0,0,.10);
            height:100%;
            transition:.3s;
        }

        .card-box:hover{
            transform:translateY(-8px);
        }

        .count{
            font-size:48px;
            font-weight:900;
        }

        .bg1{
            background:linear-gradient(135deg,#2563eb,#1d4ed8);
        }

        .bg2{
            background:linear-gradient(135deg,#16a34a,#15803d);
        }

        .bg3{
            background:linear-gradient(135deg,#ea580c,#c2410c);
        }

        .bg4{
            background:linear-gradient(135deg,#7c3aed,#6d28d9);
        }

        .quick a{
            border-radius:16px;
            padding:14px;
            font-weight:700;
        }

    </style>
</head>

<body>

<section class="top">
    <div>
        <h1>👑 ADMIN DASHBOARD</h1>
        <p>Quản trị hệ thống nhà hàng chuyên nghiệp</p>
    </div>
</section>

<div class="container pb-5">

    <div class="panel">

        <div class="row g-4 mb-4">

            <div class="col-lg-3 col-md-6">
                <div class="card-box bg1 text-center">
                    <div class="count"><%=totalUsers%></div>
                    <div>Người dùng</div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card-box bg2 text-center">
                    <div class="count"><%=totalProducts%></div>
                    <div>Món ăn</div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card-box bg3 text-center">
                    <div class="count"><%=totalTables%></div>
                    <div>Bàn ăn</div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card-box bg4 text-center">
                    <div class="count"><%=totalReservations%></div>
                    <div>Booking</div>
                </div>
            </div>

        </div>

        <h3 class="fw-bold mb-4">⚡ Quản Lý Nhanh</h3>

        <div class="row g-3 quick">

            <div class="col-md-3">
                <a href="<%=ctx%>/admin/products"
                   class="btn btn-primary w-100">
                    🍽 Quản lý món ăn
                </a>
            </div>

            <div class="col-md-3">
                <a href="<%=ctx%>/admin/users"
                   class="btn btn-success w-100">
                    👤 Quản lý user
                </a>
            </div>

            <div class="col-md-3">
                <a href="<%=ctx%>/admin/tables"
                   class="btn btn-warning w-100">
                    🪑 Quản lý bàn
                </a>
            </div>

            <div class="col-md-3">
                <a href="<%=ctx%>/admin/reservations"
                   class="btn btn-danger w-100">
                    📅 Quản lý booking
                </a>
            </div>

        </div>

        <hr class="my-5">

        <div class="row g-4">

            <div class="col-md-6">

                <div class="panel">

                    <h4 class="fw-bold">📌 Ghi chú hệ thống</h4>

                    <ul class="mt-3">
                        <li>User đặt bàn sẽ vào trạng thái PENDING</li>
                        <li>Admin xác nhận booking sẽ thành CONFIRMED</li>
                        <li>Khách dùng xong chuyển DONE</li>
                        <li>Có thể hủy bất kỳ booking nào</li>
                    </ul>

                </div>

            </div>

            <div class="col-md-6">

                <div class="panel">

                    <h4 class="fw-bold">🔥 Hôm nay</h4>

                    <p class="mt-3">Booking mới: <b>12</b></p>
                    <p>Khách online: <b>35</b></p>
                    <p>Món bán chạy: <b>Lẩu Thái</b></p>
                    <p>Doanh thu demo: <b>5.200.000đ</b></p>

                </div>

            </div>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>