<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thông tin cá nhân");
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    Boolean verified = (Boolean) request.getAttribute("verified");
    if (verified == null && user != null) {
        verified = vn.edu.hcmuaf.fit.util.AuthUtil.isIdentityVerified(user);
    }
    if (verified == null) verified = false;
    String saved = request.getParameter("saved");
    String verifiedParam = request.getParameter("verified");
%>
<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1><i class="bi bi-person-badge"></i> Thông tin cá nhân</h1>
        <p>Quản lý tài khoản và trạng thái xác thực</p>
    </div>
</section>

<div class="container py-5">
    <div class="row g-4">
        <div class="col-lg-7">
            <% if ("1".equals(saved)) { %>
            <div class="alert alert-success">Đã lưu thông tin.</div>
            <% } %>
            <% if ("1".equals(verifiedParam)) { %>
            <div class="alert alert-success">Xác thực danh tính thành công! Bạn có thể đặt bàn và gọi món.</div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <div class="box glass-card">
                <h4 class="mb-4">Hồ sơ</h4>
                <form method="post" action="<%= ctx %>/profile/update">
                    <div class="mb-3">
                        <label class="form-label">Tên đăng nhập</label>
                        <input type="text" class="form-control" value="<%= user != null ? user.getUsername() : "" %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ tên</label>
                        <input type="text" name="fullName" class="form-control" required
                               value="<%= user != null && user.getFullName() != null ? user.getFullName() : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control"
                               value="<%= user != null && user.getEmail() != null ? user.getEmail() : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Vai trò</label>
                        <input type="text" class="form-control" value="<%= user != null ? user.getRole() : "" %>" readonly>
                    </div>
                    <button type="submit" class="btn btn-primary-custom">Lưu thông tin</button>
                </form>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="box glass-card">
                <h4 class="mb-3"><i class="bi bi-shield-check"></i> Xác thực danh tính</h4>
                <% if (verified) { %>
                <p class="text-success mb-2"><i class="bi bi-check-circle-fill"></i> Đã xác thực</p>
                <% if (user != null && user.getIdentityVerifiedAt() != null) { %>
                <small class="text-muted">Lúc: <%= user.getIdentityVerifiedAt() %></small>
                <% } %>
                <% } else { %>
                <p class="text-warning">Chưa xác thực — bắt buộc trước khi đặt bàn / gọi món.</p>
                <a href="<%= ctx %>/verify-identity" class="btn btn-warning w-100 mt-2">
                    <i class="bi bi-patch-check"></i> Xác thực qua Email
                </a>
                <% } %>
            </div>

            <div class="box glass-card mt-4">
                <h5 class="mb-3">Lối tắt</h5>
                <a href="<%= ctx %>/tables" class="btn btn-outline-custom w-100 mb-2">Đặt bàn</a>
                <a href="<%= ctx %>/my-booking" class="btn btn-outline-custom w-100 mb-2">Lịch đặt của tôi</a>
                <a href="<%= ctx %>/menu" class="btn btn-outline-custom w-100">Thực đơn</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
