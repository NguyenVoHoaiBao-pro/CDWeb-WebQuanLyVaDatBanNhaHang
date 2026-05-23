<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Reservation" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Sửa booking — Nhà Hàng Của Chúng Ta");
    Reservation booking = (Reservation) request.getAttribute("booking");

    String datetimeValue = "";
    if (booking != null && booking.getReservationTime() != null) {
        datetimeValue = booking.getReservationTime().trim().replace(" ", "T");
        if (datetimeValue.length() > 16) {
            datetimeValue = datetimeValue.substring(0, 16);
        }
    }
%>

<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>✏️ Sửa đặt bàn</h1>
        <p>Cập nhật thời gian hoặc số khách cho booking đang chờ</p>
    </div>
</section>

<div class="container py-5">
    <c:choose>
        <c:when test="${booking == null}">
            <div class="glass-card text-center p-5">
                <i class="bi bi-exclamation-circle display-4 text-muted"></i>
                <h4 class="mt-3">Không tìm thấy booking hoặc không thể chỉnh sửa</h4>
                <a href="<%= ctx %>/my-booking" class="btn btn-primary-custom mt-3">
                    Quay lại danh sách
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="booking-form-card">
                <div class="glass-card p-4 p-md-5">
                    <div class="form-icon"><i class="bi bi-pencil-square"></i></div>
                    <h2 class="text-center fw-bold mb-4">Chỉnh sửa booking #${booking.id}</h2>

                    <form action="<%= ctx %>/edit-booking" method="post">
                        <input type="hidden" name="id" value="${booking.id}"/>

                        <div class="mb-3">
                            <label class="form-label">Bàn</label>
                            <input type="text" class="form-control" value="Bàn #${booking.tableId}" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Thời gian đến</label>
                            <input type="datetime-local"
                                   name="reservationTime"
                                   class="form-control"
                                   value="<%= datetimeValue %>"
                                   required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Số người</label>
                            <input type="number"
                                   name="numberOfPeople"
                                   class="form-control"
                                   min="1"
                                   value="${booking.numberOfPeople}"
                                   required>
                        </div>

                        <button type="submit" class="btn btn-primary-custom w-100 btn-lg">
                            <i class="bi bi-check-circle"></i> Lưu thay đổi
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <a href="<%= ctx %>/my-booking" class="text-muted">
                            <i class="bi bi-arrow-left"></i> Quay lại booking của tôi
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="layout/footer.jsp"/>
