<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Đặt bàn — Nhà Hàng Của Chúng Ta");
    Integer tableId = (Integer) request.getAttribute("tableId");
%>

<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>📅 Đặt bàn</h1>
        <p>Hoàn tất thông tin để giữ chỗ cho bạn</p>
    </div>
</section>

<div class="container py-5">
    <div class="table-booking-steps mb-4">
        <span class="step done"><i class="bi bi-check-circle-fill"></i> Chọn bàn</span>
        <span class="step active"><i class="bi bi-2-circle-fill"></i> Thông tin</span>
        <span class="step"><i class="bi bi-3-circle"></i> Gọi món</span>
    </div>

    <div class="booking-form-card">
        <div class="glass-card p-4 p-md-5">
            <div class="form-icon"><i class="bi bi-calendar-event"></i></div>
            <h2 class="text-center fw-bold mb-1">Xác nhận đặt bàn</h2>
            <p class="text-center text-muted mb-4">Vui lòng điền thời gian và số khách</p>

            <c:if test="${error != null}">
                <div class="alert alert-danger text-center">
                    <i class="bi bi-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <% if (tableId == null) { %>
            <div class="alert alert-danger text-center">
                Không tìm thấy bàn. Vui lòng chọn lại.
            </div>
            <div class="text-center mt-3">
                <a href="<%= ctx %>/tables" class="btn btn-primary-custom">
                    <i class="bi bi-arrow-left"></i> Quay lại chọn bàn
                </a>
            </div>
            <% } else { %>

            <form action="<%= ctx %>/book-table" method="post">
                <input type="hidden" name="tableId" value="<%= tableId %>"/>

                <div class="mb-3">
                    <label class="form-label">Bàn đã chọn</label>
                    <input type="text" class="form-control" value="Bàn #<%= tableId %>" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">Thời gian đến</label>
                    <input type="datetime-local"
                           name="reservationTime"
                           class="form-control"
                           required>
                    <small class="text-muted">Định dạng: ngày và giờ (tối đa 7 ngày trước)</small>
                </div>

                <div class="mb-4">
                    <label class="form-label">Số người</label>
                    <input type="number"
                           name="numberOfPeople"
                           class="form-control"
                           min="1"
                           placeholder="VD: 4"
                           required>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 btn-lg">
                    <i class="bi bi-check-circle"></i> Xác nhận đặt bàn
                </button>
            </form>

            <% } %>

            <div class="text-center mt-4">
                <a href="<%= ctx %>/tables" class="text-muted">
                    <i class="bi bi-arrow-left"></i> Quay lại chọn bàn
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
