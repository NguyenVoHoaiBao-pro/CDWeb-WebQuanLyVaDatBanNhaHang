<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>
<%@ page import="vn.edu.hcmuaf.fit.model.RestaurantTable" %>
<%@ page import="vn.edu.hcmuaf.fit.util.DateUtil" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thanh toán — Nhà Hàng Của Chúng Ta");
    List<Product> cart = (List<Product>) request.getAttribute("list");
    List<RestaurantTable> tables = (List<RestaurantTable>) request.getAttribute("tables");

    if (cart == null) cart = new ArrayList<Product>();
    if (tables == null) tables = new ArrayList<RestaurantTable>();

    double total = 0;
    for (Product p : cart) {
        total += p.getPrice() * p.getQuantity();
    }
%>

<jsp:include page="../layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>📅 Đặt bàn & Thanh toán</h1>
        <p>Xác nhận thông tin và hoàn tất đơn hàng</p>
    </div>
</section>

<div class="container py-5">
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="box glass-card">
                <h4 class="mb-4"><i class="bi bi-pencil-square"></i> Thông tin đặt bàn</h4>

                <form method="post" action="<%= ctx %>/checkout">
                    <div class="mb-3">
                        <label class="form-label">Mã đặt bàn</label>
                        <input type="text" class="form-control" value="#${reservation.id}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Bàn</label>
                        <input type="text" class="form-control" value="Bàn #${reservation.tableId}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Thời gian đến</label>
                        <%
                            vn.edu.hcmuaf.fit.model.Reservation res = (vn.edu.hcmuaf.fit.model.Reservation) request.getAttribute("reservation");
                            String timeShow = res != null ? DateUtil.formatDateTimeRange(
                                    res.getReservationStartTime(), res.getReservationEndTime()) : "";
                        %>
                        <input type="text" class="form-control" value="<%= timeShow %>" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Số người</label>
                        <input type="text" class="form-control" value="${reservation.numberOfPeople}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Thanh toán</label>
                        <select name="payment" class="form-select" id="paymentMethod">
                            <option value="COD">Trả sau khi ăn (tại quầy)</option>
                            <option value="DEPOSIT">Đặt cọc trước (tại quầy)</option>
                            <option value="SIMULATE_MOMO">MoMo — thanh toán giả lập</option>
                            <option value="SIMULATE_VNPAY">VNPay — thanh toán giả lập</option>
                        </select>
                        <small class="text-muted d-block mt-1">MoMo/VNPay chỉ mô phỏng giao diện, không trừ tiền thật.</small>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Ghi chú</label>
                        <textarea name="note" rows="4" class="form-control" placeholder="Ghi chú thêm cho nhà hàng..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary-custom w-100 btn-lg">
                        <i class="bi bi-check-circle"></i> Xác nhận đặt bàn
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="box glass-card sticky-top" style="top:100px;">
                <h4 class="mb-4"><i class="bi bi-bag-check"></i> Đơn hàng</h4>

                <% for (Product p : cart) { %>
                <div class="order-item d-flex justify-content-between align-items-start">
                    <div>
                        <div class="fw-bold"><%= p.getName() %></div>
                        <small class="text-muted">x <%= p.getQuantity() %></small>
                    </div>
                    <div class="fw-semibold">
                        <%= String.format("%,.0f", p.getPrice() * p.getQuantity()) %> đ
                    </div>
                </div>
                <% } %>

                <% if (cart.isEmpty()) { %>
                <p class="text-muted text-center py-3">Chưa có món trong giỏ</p>
                <% } %>

                <hr style="border-color:var(--border-glass);">

                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Tổng cộng:</span>
                    <span class="total"><%= String.format("%,.0f", total) %> đ</span>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
