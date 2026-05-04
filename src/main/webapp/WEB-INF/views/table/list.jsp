<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<RestaurantTable> list = (List<RestaurantTable>) request.getAttribute("list");
    if(list == null) list = new ArrayList<>();
%>

<style>
    .table-card{
        border-radius:18px;
        padding:20px;
        background:#fff;
        box-shadow:0 10px 25px rgba(0,0,0,.08);
        text-align:center;
        transition:.3s;
    }

    .table-card:hover{
        transform:translateY(-5px);
    }

    .status{
        font-weight:700;
        padding:5px 12px;
        border-radius:20px;
    }

    .available{
        background:#d1fae5;
        color:#065f46;
    }

    .reserved{
        background:#fee2e2;
        color:#991b1b;
    }
</style>

<div class="container py-5">

    <h1 class="text-center mb-5">🍽 Danh Sách Bàn</h1>

    <div class="row g-4">

        <% if(list.isEmpty()){ %>

        <div class="text-center">
            <h4>Không có bàn nào</h4>
        </div>

        <% } else {
            for(RestaurantTable t : list){
        %>

        <div class="col-md-4">

            <div class="table-card">

                <h4><%=t.getName()%></h4>

                <p>Sức chứa: <b><%=t.getCapacity()%></b> người</p>

                <p>
                    Trạng thái:
                    <% if("AVAILABLE".equals(t.getStatus())){ %>
                    <span class="status available">Còn trống</span>
                    <% } else { %>
                    <span class="status reserved">Đã đặt</span>
                    <% } %>
                </p>

                <% if("AVAILABLE".equals(t.getStatus())){ %>
                <a href="<%=request.getContextPath()%>/table-booking?tableId=<%=t.getId()%>"
                   class="btn btn-success">
                    Đặt bàn
                </a>
                <% } else { %>
                <button class="btn btn-secondary" disabled>
                    Hết chỗ
                </button>
                <% } %>

            </div>

        </div>

        <% }} %>

    </div>

</div>

<jsp:include page="../layout/footer.jsp"/>