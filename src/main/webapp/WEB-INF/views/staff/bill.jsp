<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.*" %>
<%@ page import="vn.edu.hcmuaf.fit.util.DateUtil" %>
<%
    String ctx = request.getContextPath();
    Order order = (Order) request.getAttribute("order");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    RestaurantTable table = (RestaurantTable) request.getAttribute("table");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    String billCode = (String) request.getAttribute("billCode");
    String qrUrl = (String) request.getAttribute("qrUrl");
    String timeRange = (String) request.getAttribute("timeRange");
    if (details == null) details = new ArrayList<>();
    double total = order != null ? order.getTotal() : 0;
    String guest = reservation != null && reservation.getGuestName() != null && !reservation.getGuestName().isEmpty()
            ? reservation.getGuestName() : "Khách tại quầy";
%>
<div class="staff-no-print staff-topbar mb-3">
    <div>
        <h1><i class="bi bi-receipt"></i> Hóa đơn</h1>
        <p class="text-muted small mb-0">In hoặc gửi QR cho khách</p>
    </div>
    <div class="staff-action-bar mb-0">
        <button type="button" class="staff-btn-print btn" onclick="window.print()">
            <i class="bi bi-printer-fill"></i> In hóa đơn
        </button>
        <a href="<%= ctx %>/staff" class="btn btn-outline-light btn-sm">Về lịch</a>
        <a href="<%= ctx %>/staff/walk-in" class="btn btn-outline-info btn-sm">Đơn mới</a>
    </div>
</div>

<div class="staff-bill-page">
    <div class="staff-bill-paper" id="billPrintArea">
        <div class="staff-bill-header">
            <h2>🍽 NHÀ HÀNG CỦA CHÚNG TA</h2>
            <div style="font-size:0.85rem;opacity:0.95;margin-top:4px;">Hóa đơn tạm tính</div>
        </div>
        <div class="staff-bill-body">
            <p><strong>Mã HĐ:</strong> <%= billCode %></p>
            <p><strong>Ngày in:</strong> <%= DateUtil.formatNow() %></p>
            <p><strong>Bàn:</strong> <%= table != null ? table.getName() : "—" %></p>
            <p><strong>Khách:</strong> <%= guest %></p>
            <p><strong>Khung giờ:</strong> <%= timeRange != null ? timeRange : "—" %></p>
            <hr/>
            <table class="table table-sm mb-0">
                <thead><tr><th>Món</th><th class="text-center">SL</th><th class="text-end">Tiền</th></tr></thead>
                <tbody>
                <% for (OrderDetail d : details) {
                    double line = d.getPrice() * d.getQuantity();
                %>
                <tr>
                    <td><%= d.getProductName() %></td>
                    <td class="text-center"><%= d.getQuantity() %></td>
                    <td class="text-end"><%= String.format("%,.0f", line) %> đ</td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <hr/>
            <div class="d-flex justify-content-between fs-5 fw-bold">
                <span>TỔNG CỘNG</span>
                <span><%= String.format("%,.0f", total) %> đ</span>
            </div>
            <p class="small text-muted mt-2 mb-0">Thanh toán tại quầy. Cảm ơn quý khách!</p>
        </div>
        <div class="staff-bill-qr">
            <img src="<%= qrUrl %>" alt="QR <%= billCode %>" width="140" height="140">
            <div class="qr-label">Quét mã tra cứu hóa đơn<br><strong><%= billCode %></strong></div>
        </div>
    </div>
</div>
