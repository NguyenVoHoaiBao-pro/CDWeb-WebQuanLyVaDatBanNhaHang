<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Kết quả thanh toán");
%>
<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1><i class="bi bi-shield-exclamation"></i> Kết quả thanh toán</h1>
    </div>
</section>

<div class="container py-5 text-center">
    <div class="box glass-card p-5 d-inline-block" style="max-width: 600px;">
        <i class="bi bi-x-circle text-danger display-1 mb-4"></i>
        <h2 class="mb-4">Thanh toán thất bại</h2>
        <p class="lead mb-4"><%= request.getAttribute("error") %></p>
        
        <div class="d-grid gap-2">
            <a href="<%= ctx %>/tables" class="btn btn-primary-custom btn-lg">Quay lại trang đặt bàn</a>
            <a href="<%= ctx %>/profile" class="btn btn-outline-custom">Xem lịch sử đặt bàn</a>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
