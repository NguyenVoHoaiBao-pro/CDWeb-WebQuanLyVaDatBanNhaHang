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

    <title>Lịch Sử Đặt Bàn</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{
            background:#f8fafc;
            font-family:Segoe UI;
        }

        .hero{
            height:300px;
            background:
                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),
                    url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4') center/cover;
            display:flex;
            align-items:center;
            justify-content:center;
            text-align:center;
            color:white;
        }

        .hero h1{
            font-size:52px;
            font-weight:900;
        }

        .box{
            background:white;
            padding:30px;
            border-radius:24px;
            box-shadow:0 15px 35px rgba(0,0,0,.08);
        }

        .status{
            padding:8px 16px;
            border-radius:30px;
            font-weight:700;
            font-size:14px;
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

<section class="hero">
    <div>
        <h1>📅 Booking Của Tôi</h1>
        <p>Quản lý đơn đặt bàn nhanh chóng</p>
    </div>
</section>

<div class="container py-5">

    <div class="box">

        <div class="d-flex justify-content-between mb-4">

            <h2 class="fw-bold">Danh Sách Đặt Bàn</h2>

            <div>
                <a href="<%=ctx%>/tables" class="btn btn-warning">
                    + Đặt thêm
                </a>
            </div>

        </div>

        <table class="table table-bordered text-center align-middle">

            <tr class="table-dark">
                <th>ID</th>
                <th>Bàn</th>
                <th>Thời Gian</th>
                <th>Số Người</th>
                <th>Trạng Thái</th>
                <th width="180">Thao tác</th>
            </tr>

            <%
                for(Reservation r : list){
            %>

            <tr>

                <td><%=r.getId()%></td>

                <td>#<%=r.getTableId()%></td>

                <td><%=r.getReservationTime()%></td>

                <td><%=r.getNumberOfPeople()%></td>

                <td>
<span class="status <%=r.getStatus()%>">
<%=r.getStatus()%>
</span>
                </td>

                <td>

                    <% if("PENDING".equals(r.getStatus())){ %>

                    <a href="<%=ctx%>/cancel-booking/<%=r.getId()%>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn muốn hủy đặt bàn này?')">
                        Hủy bàn
                    </a>

                    <% } else { %>

                    <button class="btn btn-secondary btn-sm" disabled>
                        Không thể hủy
                    </button>

                    <% } %>

                </td>

            </tr>

            <%
                }
            %>

        </table>

        <% if(list.size()==0){ %>

        <div class="alert alert-info text-center mt-3">
            Bạn chưa có lịch đặt bàn nào.
        </div>

        <% } %>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>