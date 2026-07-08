<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.*" %>
<%@ page import="vn.edu.hcmuaf.fit.util.DateUtil" %>
<%
    String ctx = request.getContextPath();
    List<Product> list = (List<Product>) request.getAttribute("list");
    if (list == null) list = new ArrayList<>();
    double total = request.getAttribute("total") != null ? (Double) request.getAttribute("total") : 0;
    Integer reservationId = (Integer) request.getAttribute("reservationId");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    RestaurantTable table = (RestaurantTable) request.getAttribute("table");
    String timeRange = reservation != null
            ? DateUtil.formatDateTimeRange(reservation.getReservationStartTime(), reservation.getReservationEndTime())
            : "";
    List<Reservation> activeCarts = (List<Reservation>) request.getAttribute("activeCarts");
    if (activeCarts == null) activeCarts = new ArrayList<>();
%>
<div class="staff-topbar staff-no-print">
    <div>
        <h1><i class="bi bi-cart3"></i> Giỏ hàng &amp; hóa đơn</h1>
        <p class="text-muted small mb-0">Thanh toán tại quầy — chỉ xuất bill / QR cho khách</p>
    </div>
    <a href="<%= ctx %>/staff/walk-in" class="btn btn-outline-info btn-sm"><i class="bi bi-plus-lg"></i> Đặt bàn mới</a>
</div>

<div class="row g-3 mb-4 staff-no-print">
    <div class="col-12">
        <div class="staff-card border-info" style="border-left: 4px solid var(--bs-info);">
            <h5 class="text-info mb-3"><i class="bi bi-bell-fill"></i> Bàn đang gọi món qua QR / Cần phục vụ</h5>
            <% if (activeCarts.isEmpty()) { %>
                <p class="text-muted mb-0 small"><i class="bi bi-info-circle"></i> Không có bàn nào đang có món trong giỏ.</p>
            <% } else { %>
                <div class="row g-2">
                <% for (Reservation r : activeCarts) { 
                    String sourceLabel = "QR_ORDER_SUBMITTED".equals(r.getBookingSource()) 
                        ? "<span class='badge bg-warning text-dark'><i class='bi bi-check-circle-fill'></i> Khách đã gửi Order</span>" 
                        : "<span class='badge bg-secondary'><i class='bi bi-pencil'></i> Khách đang chọn món</span>";
                %>
                    <div class="col-md-4 col-sm-6">
                        <div class="p-2 border border-secondary rounded bg-dark d-flex justify-content-between align-items-center">
                            <div>
                                <strong class="text-light"><%= r.getTableName() != null ? r.getTableName() : ("Bàn #" + r.getTableId()) %></strong>
                                <div class="small text-muted mt-1">Mã đặt: #<%= r.getId() %></div>
                                <div class="mt-1"><%= sourceLabel %></div>
                            </div>
                            <a href="<%= ctx %>/staff/cart/select/<%= r.getId() %>" class="btn btn-sm btn-info text-dark fw-bold">
                                <i class="bi bi-cart-check"></i> Xem giỏ
                            </a>
                        </div>
                    </div>
                <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>

<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-warning staff-card mb-3"><%= request.getAttribute("error") %></div>
<% } %>
<% if ("1".equals(request.getParameter("error"))) { %>
<div class="alert alert-danger staff-card mb-3">Không tạo được hóa đơn — kiểm tra giỏ hàng.</div>
<% } %>

<% if (reservationId == null) { %>
<div class="staff-card text-center py-5">
    <i class="bi bi-table display-4 text-info opacity-50"></i>
    <p class="mt-3 mb-3">Chưa có bàn đang phục vụ</p>
    <a href="<%= ctx %>/staff/walk-in" class="staff-btn-primary btn">Khách walk-in</a>
</div>
<% } else { %>

<div class="staff-card staff-card--accent mb-3">
    <div class="row g-2 small">
        <div class="col-md-4"><strong>Bàn:</strong> <%= table != null ? table.getName() : ("#" + reservation.getTableId()) %></div>
        <div class="col-md-5"><strong>Khung giờ:</strong> <%= timeRange %></div>
        <div class="col-md-3"><strong>Mã đặt:</strong> #<%= reservationId %></div>
    </div>
</div>

<div class="row g-3">
    <div class="col-lg-8">
        <div class="staff-card">
            <% if (list.isEmpty()) { %>
            <p class="text-muted text-center py-4">Chưa có món — <a href="<%= ctx %>/menu">chọn thực đơn</a></p>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle mb-0">
                    <thead>
                    <tr><th>Món</th><th width="120">SL</th><th class="text-end">Tiền</th><th></th></tr>
                    </thead>
                    <tbody>
                    <% for (Product p : list) {
                        double sub = p.getPrice() * p.getQuantity();
                    %>
                    <tr>
                        <td class="fw-semibold"><%= p.getName() %></td>
                        <td>
                            <a href="<%= ctx %>/cart/decrease/<%= p.getId() %>" class="btn btn-sm btn-outline-secondary">−</a>
                            <span class="mx-2"><%= p.getQuantity() %></span>
                            <a href="<%= ctx %>/cart/increase/<%= p.getId() %>" class="btn btn-sm btn-outline-secondary">+</a>
                        </td>
                        <td class="text-end text-info fw-bold"><%= String.format("%,.0f", sub) %> đ</td>
                        <td><a href="<%= ctx %>/cart/remove/<%= p.getId() %>" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
            <div class="mt-3">
                <a href="<%= ctx %>/menu" class="btn btn-outline-light btn-sm"><i class="bi bi-basket"></i> Thêm món</a>
                <a href="<%= ctx %>/cart/clear" class="btn btn-outline-danger btn-sm ms-2" onclick="return confirm('Xóa hết món?')">Xóa giỏ</a>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="staff-card staff-cart-summary">
            <h5 class="mb-3"><i class="bi bi-receipt-cutoff"></i> Tổng hóa đơn</h5>
            <div class="d-flex justify-content-between fs-4 fw-bold mb-3">
                <span>Tổng</span>
                <span class="text-info"><%= String.format("%,.0f", total) %> đ</span>
            </div>
            <p class="small text-muted mb-3">
                <i class="bi bi-info-circle"></i> Không chọn Momo/VNPay/COD — nhân viên in bill hoặc hiển thị mã QR sau khi hoàn tất.
            </p>
            <form method="post" action="<%= ctx %>/staff/order/complete">
                <label class="form-label small">Ghi chú (tùy chọn)</label>
                <textarea name="note" class="form-control form-control-sm mb-3" rows="2" placeholder="Ít cay, không hành..."></textarea>
                <button type="submit" class="staff-btn-primary btn w-100 mb-2" <%= list.isEmpty() ? "disabled" : "" %>>
                    <i class="bi bi-printer"></i> Hoàn tất &amp; xuất hóa đơn
                </button>
            </form>
        </div>
    </div>
</div>
<% } %>
