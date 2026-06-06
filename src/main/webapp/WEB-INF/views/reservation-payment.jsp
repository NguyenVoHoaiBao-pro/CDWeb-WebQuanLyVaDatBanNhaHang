<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Reservation" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thanh toán cọc đặt bàn");
    Reservation r = (Reservation) request.getAttribute("reservation");
    Double fee = (Double) request.getAttribute("fee");
%>
<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1><i class="bi bi-credit-card"></i> Thanh toán cọc đặt bàn</h1>
        <p>Vui lòng thanh toán 50% phí đặt bàn để xác nhận lịch đặt của bạn</p>
    </div>
</section>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="box glass-card p-4">
                <h4 class="mb-4 text-center">Thông tin đặt bàn #<%= r.getId() %></h4>
                
                <div class="mb-3 d-flex justify-content-between">
                    <span class="text-muted">Bàn:</span>
                    <span class="fw-bold"><%= r.getTableName() %></span>
                </div>
                <div class="mb-3 d-flex justify-content-between">
                    <span class="text-muted">Thời gian:</span>
                    <span class="fw-bold"><%= r.getReservationStartTime() %></span>
                </div>
                <div class="mb-3 d-flex justify-content-between">
                    <span class="text-muted">Số người:</span>
                    <span class="fw-bold"><%= r.getNumberOfPeople() %> người</span>
                </div>
                
                <hr class="my-4">
                
                <div class="mb-2 d-flex justify-content-between">
                    <span>Tổng phí đặt bàn:</span>
                    <span><fmt:formatNumber value="<%= r.getTotalPrice() %>" type="currency" currencySymbol="₫"/></span>
                </div>
                <div class="mb-4 d-flex justify-content-between align-items-center">
                    <span class="fs-5 fw-bold">Tiền cọc (50%):</span>
                    <span class="fs-4 text-primary fw-bold"><fmt:formatNumber value="<%= fee %>" type="currency" currencySymbol="₫"/></span>
                </div>
                
                <div class="alert alert-warning mb-4">
                    <small><i class="bi bi-info-circle"></i> Lưu ý: Tiền cọc sẽ không được hoàn lại nếu quý khách không đến đúng giờ hoặc hủy lịch quá muộn.</small>
                </div>

                <form action="<%= ctx %>/reservation/vnpay-pay" method="post">
                    <input type="hidden" name="id" value="<%= r.getId() %>">
                    <button type="submit" class="btn btn-primary-custom btn-lg w-100 mb-3">
                        <i class="bi bi-wallet2"></i> Thanh toán qua VNPay
                    </button>
                </form>
                
                <a href="<%= ctx %>/tables" class="btn btn-link text-muted w-100">Hủy và quay lại</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
