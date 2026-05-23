<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product,vn.edu.hcmuaf.fit.model.Reservation" %>
<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thanh toán giả lập");
    String method = (String) request.getAttribute("method");
    if (method == null) method = "MOMO";
    Double totalObj = (Double) request.getAttribute("total");
    double total = totalObj != null ? totalObj : 0;
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Product> cart = (List<Product>) request.getAttribute("cart");
    if (cart == null) cart = new ArrayList<>();
    String brand = "MOMO".equals(method) ? "MoMo" : ("VNPAY".equals(method) ? "VNPay" : method);
%>
<jsp:include page="layout/header.jsp"/>

<div class="container py-5" style="max-width:480px;">
    <div class="box glass-card text-center">
        <div class="mb-3" style="font-size:3rem;">
            <%= "MOMO".equals(method) ? "💜" : "🔵" %>
        </div>
        <h2>Thanh toán <%= brand %> (giả lập)</h2>
        <p class="text-muted">Đây là màn hình mô phỏng — không trừ tiền thật</p>

        <div class="my-4 p-3 rounded" style="background:rgba(255,255,255,0.06);">
            <div class="small text-muted">Số tiền</div>
            <div class="fs-2 fw-bold text-warning"><%= String.format("%,.0f", total) %> đ</div>
            <% if (reservation != null) { %>
            <div class="small text-muted mt-2">Đặt bàn #<%= reservation.getId() %> — Bàn <%= reservation.getTableId() %></div>
            <% } %>
        </div>

        <form method="post" action="<%= ctx %>/payment/simulate/confirm">
            <button type="submit" class="btn btn-primary-custom btn-lg w-100 mb-2">
                <i class="bi bi-check-circle"></i> Xác nhận đã thanh toán
            </button>
        </form>
        <a href="<%= ctx %>/checkout" class="btn btn-outline-custom w-100">Quay lại</a>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
