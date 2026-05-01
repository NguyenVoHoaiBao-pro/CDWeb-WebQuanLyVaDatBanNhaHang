<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Reservation" %>

<%
    String ctx = request.getContextPath();

    List<Reservation> list =
            (List<Reservation>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Admin Booking</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{
            background:#f8fafc;
            font-family:Segoe UI;
        }

        .top{
            background:
                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),
                    url('https://images.unsplash.com/photo-1552566626-52f8b828add9') center/cover;
            height:260px;
            display:flex;
            align-items:center;
            justify-content:center;
            text-align:center;
            color:white;
        }

        .top h1{
            font-size:54px;
            font-weight:900;
        }

        .box{
            background:white;
            padding:30px;
            border-radius:24px;
            box-shadow:0 15px 35px rgba(0,0,0,.08);
            margin-top:-50px;
            position:relative;
            z-index:9;
        }

        .status{
            padding:8px 16px;
            border-radius:30px;
            font-size:14px;
            font-weight:700;
        }

        .PENDING{
            background:#fef3c7;
            color:#92400e;
        }

        .CONFIRMED{
            background:#dcfce7;
            color:#166534;
        }

        .CANCELLED{
            background:#fee2e2;
            color:#991b1b;
        }

        .DONE{
            background:#dbeafe;
            color:#1d4ed8;
        }

    </style>
</head>

<body>

<section class="top">
    <div>
        <h1>👑 Quản Lý Booking</h1>
        <p>Duyệt và quản lý đặt bàn khách hàng</p>
    </div>
</section>

<div class="container pb-5">

    <div class="box">

        <div class="d-flex justify-content-between mb-4">

            <h2 class="fw-bold">Danh Sách Booking</h2>

            <a href="<%=ctx%>/admin" class="btn btn-dark">
                Dashboard
            </a>

        </div>

        <table class="table table-bordered text-center align-middle">

            <tr class="table-dark">
                <th>ID</th>
                <th>User</th>
                <th>Bàn</th>
                <th>Thời Gian</th>
                <th>Số Người</th>
                <th>Trạng Thái</th>
                <th width="280">Thao tác</th>
            </tr>

            <%
                for(Reservation r : list){
            %>

            <tr>

                <td><%=r.getId()%></td>

                <td>#<%=r.getUserId()%></td>

                <td>#<%=r.getTableId()%></td>

                <td><%=r.getReservationTime()%></td>

                <td><%=r.getNumberOfPeople()%></td>

                <td>
<span class="status <%=r.getStatus()%>">
<%=r.getStatus()%>
</span>
                </td>

                <td>

                    <a href="<%=ctx%>/admin/reservation/<%=r.getId()%>/CONFIRMED"
                       class="btn btn-success btn-sm">
                        Duyệt
                    </a>

                    <a href="<%=ctx%>/admin/reservation/<%=r.getId()%>/DONE"
                       class="btn btn-primary btn-sm">
                        Hoàn tất
                    </a>

                    <a href="<%=ctx%>/admin/reservation/<%=r.getId()%>/CANCELLED"
                       class="btn btn-danger btn-sm">
                        Hủy
                    </a>

                </td>

            </tr>

            <%
                }
            %>

        </table>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>