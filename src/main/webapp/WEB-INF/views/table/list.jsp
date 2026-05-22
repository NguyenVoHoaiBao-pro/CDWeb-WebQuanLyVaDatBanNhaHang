<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<RestaurantTable> groundTables =
            (List<RestaurantTable>) request.getAttribute("groundTables");

    List<RestaurantTable> floor1Tables =
            (List<RestaurantTable>) request.getAttribute("floor1Tables");

    List<RestaurantTable> floor2Tables =
            (List<RestaurantTable>) request.getAttribute("floor2Tables");

    if(groundTables == null) groundTables = new ArrayList<>();
    if(floor1Tables == null) floor1Tables = new ArrayList<>();
    if(floor2Tables == null) floor2Tables = new ArrayList<>();
%>

<style>

    body{
        background:#f5f7fb;
    }

    .page-title{
        font-size:42px;
        font-weight:800;
        color:#1e293b;
        margin-bottom:10px;
    }

    .page-desc{
        color:#64748b;
        font-size:17px;
        margin-bottom:50px;
    }

    .floor-section{
        margin-bottom:70px;
    }

    .floor-title{
        display:flex;
        align-items:center;
        gap:14px;
        margin-bottom:28px;
    }

    .floor-dot{
        width:22px;
        height:22px;
        border-radius:50%;
        flex-shrink:0;
    }

    .ground{
        background:linear-gradient(135deg,#22c55e,#86efac);
    }

    .floor1{
        background:linear-gradient(135deg,#2563eb,#60a5fa);
    }

    .floor2{
        background:linear-gradient(135deg,#7c3aed,#c4b5fd);
    }

    .floor-name{
        font-size:34px;
        font-weight:800;
        color:#0f172a;
        margin:0;
    }

    .table-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
        gap:28px;
    }

    .table-card{
        background:#fff;
        border-radius:28px;
        padding:28px;
        box-shadow:0 10px 30px rgba(0,0,0,.06);
        transition:.3s;
        border:1px solid #eef2f7;

        display:flex;
        flex-direction:column;
        justify-content:space-between;
        min-height:260px;
    }

    .table-card:hover{
        transform:translateY(-6px);
        box-shadow:0 18px 40px rgba(0,0,0,.10);
    }

    .table-top{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:12px;
        margin-bottom:22px;
    }

    .table-name{
        font-size:30px;
        font-weight:800;
        color:#0f172a;
        line-height:1.3;
        margin:0;
        word-break:break-word;
    }

    .table-info{
        display:flex;
        align-items:center;
        gap:10px;
        color:#475569;
        font-size:20px;
        margin-bottom:28px;
        font-weight:600;
    }

    .status-badge{
        padding:10px 18px;
        border-radius:999px;
        font-size:15px;
        font-weight:700;
        white-space:nowrap;
    }

    .status-available{
        background:#dcfce7;
        color:#166534;
    }

    .status-reserved{
        background:#fee2e2;
        color:#991b1b;
    }

    .book-btn{
        width:100%;
        border:none;
        border-radius:18px;
        padding:16px;
        font-size:19px;
        font-weight:700;
        transition:.3s;
    }

    .btn-available{
        background:#ef4444;
        color:white;
    }

    .btn-available:hover{
        background:#dc2626;
        transform:translateY(-2px);
    }

    .btn-disabled{
        background:#e2e8f0;
        color:#64748b;
        cursor:not-allowed;
    }

    .empty-box{
        background:white;
        padding:35px;
        border-radius:24px;
        text-align:center;
        color:#94a3b8;
        font-size:20px;
        font-weight:600;
        box-shadow:0 8px 24px rgba(0,0,0,.05);
    }

    @media(max-width:768px){

        .page-title{
            font-size:32px;
        }

        .floor-name{
            font-size:28px;
        }

        .table-name{
            font-size:24px;
        }

        .table-info{
            font-size:18px;
        }
    }

</style>

<div class="container py-5">

    <div class="text-center">

        <h1 class="page-title">
            🍽 Chọn Bàn Nhà Hàng
        </h1>

        <p class="page-desc">
            Không gian sang trọng — đặt bàn nhanh chóng và tiện lợi
        </p>

    </div>

    <!-- TẦNG TRỆT -->
    <div class="floor-section">

        <div class="floor-title">

            <div class="floor-dot ground"></div>

            <h2 class="floor-name">
                Tầng Trệt
            </h2>

        </div>

        <% if(groundTables.isEmpty()){ %>

        <div class="empty-box">
            Chưa có bàn ở tầng này
        </div>

        <% } else { %>

        <div class="table-grid">

            <% for(RestaurantTable t : groundTables){ %>

            <div class="table-card">

                <div>

                    <div class="table-top">

                        <h3 class="table-name">
                            <%=t.getName()%>
                        </h3>

                        <% if("AVAILABLE".equals(t.getStatus())){ %>

                        <div class="status-badge status-available">
                            Còn trống
                        </div>

                        <% } else { %>

                        <div class="status-badge status-reserved">
                            Đã đặt
                        </div>

                        <% } %>

                    </div>

                    <div class="table-info">
                        👥 <span><%=t.getCapacity()%> người</span>
                    </div>

                </div>

                <% if("AVAILABLE".equals(t.getStatus())){ %>

                <a href="<%=request.getContextPath()%>/table-booking?tableId=<%=t.getId()%>"
                   class="text-decoration-none">

                    <button class="book-btn btn-available">
                        Đặt bàn ngay
                    </button>

                </a>

                <% } else { %>

                <button class="book-btn btn-disabled">
                    Đã kín chỗ
                </button>

                <% } %>

            </div>

            <% } %>

        </div>

        <% } %>

    </div>

    <!-- TẦNG 1 -->
    <div class="floor-section">

        <div class="floor-title">

            <div class="floor-dot floor1"></div>

            <h2 class="floor-name">
                Tầng 1
            </h2>

        </div>

        <% if(floor1Tables.isEmpty()){ %>

        <div class="empty-box">
            Chưa có bàn ở tầng này
        </div>

        <% } else { %>

        <div class="table-grid">

            <% for(RestaurantTable t : floor1Tables){ %>

            <div class="table-card">

                <div>

                    <div class="table-top">

                        <h3 class="table-name">
                            <%=t.getName()%>
                        </h3>

                        <% if("AVAILABLE".equals(t.getStatus())){ %>

                        <div class="status-badge status-available">
                            Còn trống
                        </div>

                        <% } else { %>

                        <div class="status-badge status-reserved">
                            Đã đặt
                        </div>

                        <% } %>

                    </div>

                    <div class="table-info">
                        👥 <span><%=t.getCapacity()%> người</span>
                    </div>

                </div>

                <% if("AVAILABLE".equals(t.getStatus())){ %>

                <a href="<%=request.getContextPath()%>/table-booking?tableId=<%=t.getId()%>"
                   class="text-decoration-none">

                    <button class="book-btn btn-available">
                        Đặt bàn ngay
                    </button>

                </a>

                <% } else { %>

                <button class="book-btn btn-disabled">
                    Đã kín chỗ
                </button>

                <% } %>

            </div>

            <% } %>

        </div>

        <% } %>

    </div>

    <!-- TẦNG 2 -->
    <div class="floor-section">

        <div class="floor-title">

            <div class="floor-dot floor2"></div>

            <h2 class="floor-name">
                Tầng 2
            </h2>

        </div>

        <% if(floor2Tables.isEmpty()){ %>

        <div class="empty-box">
            Chưa có bàn ở tầng này
        </div>

        <% } else { %>

        <div class="table-grid">

            <% for(RestaurantTable t : floor2Tables){ %>

            <div class="table-card">

                <div>

                    <div class="table-top">

                        <h3 class="table-name">
                            <%=t.getName()%>
                        </h3>

                        <% if("AVAILABLE".equals(t.getStatus())){ %>

                        <div class="status-badge status-available">
                            Còn trống
                        </div>

                        <% } else { %>

                        <div class="status-badge status-reserved">
                            Đã đặt
                        </div>

                        <% } %>

                    </div>

                    <div class="table-info">
                        👥 <span><%=t.getCapacity()%> người</span>
                    </div>

                </div>

                <% if("AVAILABLE".equals(t.getStatus())){ %>

                <a href="<%=request.getContextPath()%>/table-booking?tableId=<%=t.getId()%>"
                   class="text-decoration-none">

                    <button class="book-btn btn-available">
                        Đặt bàn ngay
                    </button>

                </a>

                <% } else { %>

                <button class="book-btn btn-disabled">
                    Đã kín chỗ
                </button>

                <% } %>

            </div>

            <% } %>

        </div>

        <% } %>

    </div>

</div>

<jsp:include page="../layout/footer.jsp"/>
