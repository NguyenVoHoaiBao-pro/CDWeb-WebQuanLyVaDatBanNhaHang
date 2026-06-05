<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Xác thực tài khoản");
    Boolean needBooking = (Boolean) request.getAttribute("needBooking");
    if (needBooking == null) needBooking = "1".equals(request.getParameter("need"));
%>
<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1><i class="bi bi-shield-lock"></i> Xác thực tài khoản</h1>
        <p>Vui lòng nhập mã xác thực đã được gửi tới email của bạn</p>
    </div>
</section>

<div class="container py-5" style="max-width:500px;">
    <% if (needBooking) { %>
    <div class="alert alert-info glass-card">Bạn cần hoàn thành xác thực trước khi tiếp tục.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("message") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("message") %></div>
    <% } %>
    <% if ("1".equals(request.getParameter("resend"))) { %>
    <div class="alert alert-success">Mã xác thực mới đã được gửi!</div>
    <% } %>

    <form method="post" action="<%= ctx %>/verify-identity" class="box glass-card p-4">
        <div class="mb-4">
            <label for="code" class="form-label fw-bold">Mã xác thực (6 chữ số)</label>
            <input type="text" name="code" id="code" class="form-control form-control-lg text-center" 
                   placeholder="000000" maxlength="6" pattern="\d{6}" required autofocus>
            <div class="form-text mt-2 text-center">
                Kiểm tra hộp thư đến (hoặc thư rác) của bạn.
            </div>
        </div>

        <button type="submit" class="btn btn-primary-custom btn-lg w-100 mb-3">
            <i class="bi bi-check2-circle"></i> Xác nhận
        </button>
        
        <div class="text-center">
            <p class="mb-1">Không nhận được mã?</p>
            <a href="<%= ctx %>/resend-verification" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-clockwise"></i> Gửi lại mã
            </a>
        </div>

        <a href="<%= ctx %>/profile" class="btn btn-link text-muted w-100 mt-4">Quay lại hồ sơ</a>
    </form>
</div>

<jsp:include page="layout/footer.jsp"/>
