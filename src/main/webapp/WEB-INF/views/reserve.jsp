<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Đặt bàn — Nhà Hàng Của Chúng Ta");
%>

<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>📅 Đặt bàn</h1>
        <p>Điền thông tin đặt bàn (yêu cầu đăng nhập)</p>
    </div>
</section>

<div class="container py-5">
    <div class="booking-form-card">
        <div class="glass-card p-4 p-md-5">
            <c:if test="${error != null}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="<%= ctx %>/reserve" method="post">
                <div class="mb-3">
                    <label class="form-label">Mã bàn</label>
                    <input class="form-control" name="tableId" placeholder="Table ID" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thời gian</label>
                    <input type="datetime-local" class="form-control" name="time" required>
                </div>
                <div class="mb-4">
                    <label class="form-label">Số người</label>
                    <input class="form-control" name="people" type="number" min="1" placeholder="Số người" required>
                </div>
                <button type="submit" class="btn btn-primary-custom w-100">Đặt bàn</button>
            </form>

            <div class="text-center mt-4">
                <a href="<%= ctx %>/tables" class="text-muted">
                    <i class="bi bi-arrow-left"></i> Chọn bàn trên sơ đồ
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
