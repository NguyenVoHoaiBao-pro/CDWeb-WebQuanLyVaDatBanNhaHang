<%@ page contentType="text/html;charset=UTF-8" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Admin</title>

        <!-- BOOTSTRAP -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <!-- ICON -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- DATATABLES -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <style>
            .dataTables_length select.form-select {
                padding: 5px 35px 5px 10px !important;
                border-radius: 10px !important;
                display: inline-block !important;
                width: auto !important;
                height: auto !important;
            }

            .dataTables_filter input.form-control {
                padding: 5px 15px !important;
                border-radius: 10px !important;
                width: 250px !important;
                display: inline-block !important;
            }

            /* styling để tránh table bị cắt góc */
            .table-responsive,
            .card-box {
                border-radius: 12px !important;
                overflow: visible !important;
            }

            .card-box {
                background: #fff;
                padding: 20px;
                box-shadow: var(--shadow);
                margin-bottom: 20px;
            }

            table.dataTable {
                border-collapse: separate !important;
                border-spacing: 0 !important;
                border-radius: 8px !important;
                overflow: hidden !important;
                border: 1px solid #dee2e6 !important;
            }
        </style>

    </head>



    <body>

        <!-- SIDEBAR -->
        <div class="sidebar" id="sidebar">
            <h4>🍽 ADMIN</h4>

            <a href="${pageContext.request.contextPath}/admin">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-basket"></i> Quản lý sản phẩm
            </a>

            <a href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-people"></i> Quản lý người dùng
            </a>

            <a href="${pageContext.request.contextPath}/admin/tables">
                <i class="bi bi-grid"></i> Quản lý bàn
            </a>

            <a href="${pageContext.request.contextPath}/admin/reservations">
                <i class="bi bi-calendar-check"></i> Quản lý đặt bàn
            </a>

            <a href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- MOBILE BUTTON -->
            <div class="menu-btn" onclick="toggleMenu()">
                ☰
            </div>

            <!-- LOAD PAGE -->
            <%-- <jsp:include page="<%=pageFile%>" />--%>
            <jsp:include page="${page}" />

        </div>

        <script>
            function toggleMenu() {
                document.getElementById("sidebar")
                    .classList.toggle("active");
            }
        </script>

    </body>

    </html>