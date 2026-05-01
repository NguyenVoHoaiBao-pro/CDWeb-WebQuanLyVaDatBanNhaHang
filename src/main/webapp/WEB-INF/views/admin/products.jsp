<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    String ctx = request.getContextPath();

    List<Product> list =
            (List<Product>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Admin Products</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{
            background:#f8fafc;
            font-family:Segoe UI;
        }

        .top{
            height:260px;
            background:
                    linear-gradient(rgba(0,0,0,.55),rgba(0,0,0,.55)),
                    url('https://images.unsplash.com/photo-1504674900247-0877df9cc836') center/cover;
            display:flex;
            align-items:center;
            justify-content:center;
            color:white;
            text-align:center;
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
            margin-top:-55px;
            position:relative;
            z-index:9;
        }

        img.food{
            width:80px;
            height:60px;
            object-fit:cover;
            border-radius:10px;
        }

    </style>
</head>

<body>

<section class="top">
    <div>
        <h1>🍽 Quản Lý Món Ăn</h1>
        <p>Thêm / sửa / xóa món ăn</p>
    </div>
</section>

<div class="container pb-5">

    <div class="box">

        <div class="d-flex justify-content-between mb-4">

            <h2 class="fw-bold">Danh Sách Món</h2>

            <div>

                <a href="<%=ctx%>/admin/add-product"
                   class="btn btn-success">
                    + Thêm món
                </a>

                <a href="<%=ctx%>/admin"
                   class="btn btn-dark">
                    Dashboard
                </a>

            </div>

        </div>

        <table class="table table-bordered text-center align-middle">

            <tr class="table-dark">
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên</th>
                <th>Loại</th>
                <th>Giá</th>
                <th width="220">Thao tác</th>
            </tr>

            <%
                for(Product p : list){
            %>

            <tr>

                <td><%=p.getId()%></td>

                <td>
                    <img src="<%=p.getImage()%>" class="food">
                </td>

                <td><%=p.getName()%></td>

                <td><%=p.getCategory()%></td>

                <td><%=p.getPrice()%> đ</td>

                <td>

                    <a href="<%=ctx%>/admin/edit-product/<%=p.getId()%>"
                       class="btn btn-primary btn-sm">
                        Sửa
                    </a>

                    <a href="<%=ctx%>/admin/delete-product/<%=p.getId()%>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Xóa món này?')">
                        Xóa
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