<%--<form action="${pageContext.request.contextPath}/admin/add-product" method="post">--%>

<%--    <input name="name" placeholder="Tên món" class="form-control mb-2">--%>
<%--    <input name="price" placeholder="Giá" class="form-control mb-2">--%>
<%--    <input name="category" placeholder="Danh mục" class="form-control mb-2">--%>
<%--    <input name="image" placeholder="Link ảnh" class="form-control mb-2">--%>

<%--    <textarea name="description" placeholder="Mô tả" class="form-control mb-2"></textarea>--%>

<%--    <button class="btn btn-success">Thêm</button>--%>


<%--</form>--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body{
            background:#f5f6fa;
        }

        .sidebar{
            width:240px;
            height:100vh;
            position:fixed;
            left:0;
            top:0;
            background:#111827;
            padding-top:20px;
        }

        .sidebar a{
            display:block;
            color:white;
            padding:14px 20px;
            text-decoration:none;
        }

        .sidebar a:hover{
            background:#1f2937;
        }

        .content{
            margin-left:240px;
            padding:30px;
        }

        .box{
            background:white;
            border-radius:14px;
            padding:25px;
            box-shadow:0 8px 18px rgba(0,0,0,.08);
            max-width:700px;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h4 class="text-white text-center mb-4">🍽 ADMIN</h4>

    <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products">Products</a>
    <a href="${pageContext.request.contextPath}/admin/users">Users</a>
    <a href="${pageContext.request.contextPath}/admin/tables">Tables</a>
    <a href="${pageContext.request.contextPath}/admin/reservations">Reservations</a>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="content">

    <h2 class="mb-4">Add New Product</h2>

    <div class="box">

        <form action="${pageContext.request.contextPath}/admin/add-product"
              method="post">

            <label class="mb-1">Product Name</label>
            <input class="form-control mb-3"
                   name="name"
                   required>

            <label class="mb-1">Price</label>
            <input type="number"
                   class="form-control mb-3"
                   name="price"
                   required>

            <label class="mb-1">Category</label>
            <input class="form-control mb-3"
                   name="category"
                   required>

            <label class="mb-1">Image URL</label>
            <input class="form-control mb-3"
                   name="image"
                   required>

            <label class="mb-1">Description</label>
            <textarea class="form-control mb-4"
                      rows="4"
                      name="description"></textarea>

            <button class="btn btn-success">
                Save Product
            </button>

            <a class="btn btn-secondary"
               href="${pageContext.request.contextPath}/admin/products">
                Back
            </a>

        </form>

    </div>

</div>

</body>
</html>