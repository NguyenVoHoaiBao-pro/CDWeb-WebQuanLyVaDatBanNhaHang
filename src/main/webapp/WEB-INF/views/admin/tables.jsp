<%--<%@ page contentType="text/html;charset=UTF-8" %>--%>
<%--<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>--%>

<%--<%--%>
<%--    String ctx = request.getContextPath();--%>

<%--    List<RestaurantTable> list =--%>
<%--            (List<RestaurantTable>) request.getAttribute("list");--%>

<%--    String success = request.getParameter("success");--%>
<%--%>--%>

<%--<!DOCTYPE html>--%>
<%--<html lang="vi">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1">--%>

<%--    <title>Đặt Bàn VIP</title>--%>

<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>

<%--    <style>--%>

<%--        body{--%>
<%--            background:#f8fafc;--%>
<%--            font-family:Segoe UI;--%>
<%--        }--%>

<%--        .hero{--%>
<%--            height:350px;--%>
<%--            background:--%>
<%--                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),--%>
<%--                    url('https://images.unsplash.com/photo-1552566626-52f8b828add9') center/cover;--%>
<%--            display:flex;--%>
<%--            align-items:center;--%>
<%--            justify-content:center;--%>
<%--            text-align:center;--%>
<%--            color:white;--%>
<%--        }--%>

<%--        .hero h1{--%>
<%--            font-size:58px;--%>
<%--            font-weight:900;--%>
<%--        }--%>

<%--        .hero p{--%>
<%--            font-size:20px;--%>
<%--        }--%>

<%--        .table-card{--%>
<%--            border:none;--%>
<%--            border-radius:22px;--%>
<%--            overflow:hidden;--%>
<%--            box-shadow:0 15px 35px rgba(0,0,0,.10);--%>
<%--            transition:.35s;--%>
<%--            background:white;--%>
<%--            height:100%;--%>
<%--        }--%>

<%--        .table-card:hover{--%>
<%--            transform:translateY(-10px);--%>
<%--        }--%>

<%--        .status{--%>
<%--            padding:8px 18px;--%>
<%--            border-radius:30px;--%>
<%--            font-weight:700;--%>
<%--            font-size:14px;--%>
<%--            display:inline-block;--%>
<%--        }--%>

<%--        .AVAILABLE{--%>
<%--            background:#dcfce7;--%>
<%--            color:#166534;--%>
<%--        }--%>

<%--        .RESERVED{--%>
<%--            background:#dbeafe;--%>
<%--            color:#1d4ed8;--%>
<%--        }--%>

<%--        .OCCUPIED{--%>
<%--            background:#fee2e2;--%>
<%--            color:#b91c1c;--%>
<%--        }--%>

<%--        .form-box{--%>
<%--            background:white;--%>
<%--            padding:30px;--%>
<%--            border-radius:22px;--%>
<%--            box-shadow:0 15px 35px rgba(0,0,0,.08);--%>
<%--        }--%>

<%--        .section-title{--%>
<%--            font-size:42px;--%>
<%--            font-weight:900;--%>
<%--        }--%>

<%--    </style>--%>
<%--</head>--%>

<%--<body>--%>

<%--<!-- HERO -->--%>

<%--<section class="hero">--%>
<%--    <div>--%>
<%--        <h1>🍽 Đặt Bàn Ngay</h1>--%>
<%--        <p>Không gian sang trọng - Chỗ ngồi đẹp - Đặt nhanh trong 1 phút</p>--%>
<%--    </div>--%>
<%--</section>--%>

<%--<div class="container py-5">--%>

<%--    <% if(success != null){ %>--%>

<%--    <div class="alert alert-success text-center">--%>
<%--        🎉 Đặt bàn thành công! Nhà hàng đã nhận yêu cầu của bạn.--%>
<%--    </div>--%>

<%--    <% } %>--%>

<%--    <h2 class="section-title text-center mb-4">Danh Sách Bàn</h2>--%>

<%--    <div class="row g-4">--%>

<%--        <%--%>
<%--            for(RestaurantTable t : list){--%>
<%--        %>--%>

<%--        <div class="col-lg-4 col-md-6">--%>

<%--            <div class="table-card p-4 text-center">--%>

<%--                <h3 class="fw-bold"><%=t.getName()%></h3>--%>

<%--                <p class="text-muted">--%>
<%--                    👥 Sức chứa: <%=t.getCapacity()%> người--%>
<%--                </p>--%>

<%--                <div class="mb-3">--%>
<%--<span class="status <%=t.getStatus()%>">--%>
<%--<%=t.getStatus()%>--%>
<%--</span>--%>
<%--                </div>--%>

<%--                <% if("AVAILABLE".equals(t.getStatus())){ %>--%>

<%--                <button class="btn btn-warning px-4"--%>
<%--                        data-bs-toggle="modal"--%>
<%--                        data-bs-target="#bookModal<%=t.getId()%>">--%>
<%--                    Đặt Ngay--%>
<%--                </button>--%>

<%--                <% } else { %>--%>

<%--                <button class="btn btn-secondary px-4" disabled>--%>
<%--                    Không khả dụng--%>
<%--                </button>--%>

<%--                <% } %>--%>

<%--            </div>--%>

<%--        </div>--%>

<%--        <!-- MODAL -->--%>

<%--        <div class="modal fade" id="bookModal<%=t.getId()%>">--%>
<%--            <div class="modal-dialog">--%>
<%--                <div class="modal-content">--%>

<%--                    <div class="modal-header">--%>
<%--                        <h5 class="modal-title">--%>
<%--                            Đặt <%=t.getName()%>--%>
<%--                        </h5>--%>

<%--                        <button class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--                    </div>--%>

<%--                    <div class="modal-body">--%>

<%--                        <form action="<%=ctx%>/book-table" method="post">--%>

<%--                            <input type="hidden"--%>
<%--                                   name="tableId"--%>
<%--                                   value="<%=t.getId()%>">--%>

<%--                            <label class="mb-1">Thời gian đến</label>--%>

<%--                            <input type="datetime-local"--%>
<%--                                   name="reservationTime"--%>
<%--                                   class="form-control mb-3"--%>
<%--                                   required>--%>

<%--                            <label class="mb-1">Số người</label>--%>

<%--                            <input type="number"--%>
<%--                                   name="numberOfPeople"--%>
<%--                                   min="1"--%>
<%--                                   max="<%=t.getCapacity()%>"--%>
<%--                                   class="form-control mb-4"--%>
<%--                                   required>--%>

<%--                            <button class="btn btn-success w-100">--%>
<%--                                Xác Nhận Đặt Bàn--%>
<%--                            </button>--%>

<%--                        </form>--%>

<%--                    </div>--%>

<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <%--%>
<%--            }--%>
<%--        %>--%>

<%--    </div>--%>

<%--</div>--%>

<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>

<%--</body>--%>
<%--</html>--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<%
    List<RestaurantTable> list =
            (List<RestaurantTable>) request.getAttribute("list");
%>

<h2 class="mb-4 fw-bold">🪑 Manage Tables</h2>

<div class="card-box">

    ```
    <div class="d-flex justify-content-between mb-3">

        <a href="${pageContext.request.contextPath}/admin/add-table"
           class="btn btn-success">
            + Add Table
        </a>

    </div>

    <table class="table table-bordered table-hover text-center align-middle">

        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Capacity</th>
            <th>Status</th>
            <th width="250">Action</th>
        </tr>
        </thead>

        <tbody>

        <%
            if(list != null){
                for(RestaurantTable t : list){
        %>

        <tr>

            <td><%=t.getId()%></td>

            <td><%=t.getName()%></td>

            <td><%=t.getCapacity()%></td>

            <td>
            <span class="badge
                <%= "AVAILABLE".equals(t.getStatus()) ? "bg-success" :
                    "RESERVED".equals(t.getStatus()) ? "bg-warning text-dark" :
                    "bg-secondary" %>">
                <%=t.getStatus()%>
            </span>
            </td>

            <td>

                <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/AVAILABLE"
                   class="btn btn-success btn-sm">
                    Set Available
                </a>

                <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/RESERVED"
                   class="btn btn-warning btn-sm">
                    Set Reserved
                </a>

            </td>

        </tr>

        <%
                }
            }
        %>

        </tbody>

    </table>
    ```

</div>
