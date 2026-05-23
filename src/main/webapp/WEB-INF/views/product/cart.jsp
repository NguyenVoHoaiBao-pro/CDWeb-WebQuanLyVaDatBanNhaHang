<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Giỏ hàng — Nhà Hàng Của Chúng Ta");
    List<Product> list = (List<Product>) request.getAttribute("list");
    if (list == null) list = new ArrayList<Product>();
    double total = 0;
%>

<jsp:include page="../layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>🛒 Giỏ hàng</h1>
        <p>Quản lý món ăn đã chọn</p>
    </div>
</section>

<div class="container py-5">

    <%
        String error = (String) request.getAttribute("error");
        if (error == null && "checkout".equals(request.getParameter("error"))) {
            error = "Không thể thanh toán — giỏ hàng trống hoặc đặt bàn không hợp lệ.";
        }
        if (error != null) {
    %>
    <div class="alert alert-warning text-center glass-card mb-4"><%= error %></div>
    <% } %>

    <%
        Integer reservationId = (Integer) request.getAttribute("reservationId");
        if (reservationId != null) {
    %>
    <div class="alert alert-info glass-card mb-4">
        <i class="bi bi-calendar-check"></i> Đặt bàn #<%= reservationId %>
    </div>
    <% } %>

    <div class="d-flex justify-content-end mb-4">
        <a href="<%= ctx %>/menu" class="btn btn-outline-custom btn-sm">
            <i class="bi bi-arrow-left"></i> Tiếp tục gọi món
        </a>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="cart-box glass-card">
                <%
                    if (list.isEmpty()) {
                        if (request.getAttribute("error") != null) {
                %>
                <div class="text-center py-5">
                    <i class="bi bi-table display-4 text-muted"></i>
                    <h4 class="mt-3">Bạn chưa đặt bàn</h4>
                    <a href="<%= ctx %>/tables" class="btn btn-primary-custom mt-3">Chọn bàn ngay</a>
                </div>
                <%
                        } else {
                %>
                <div class="text-center py-5">
                    <i class="bi bi-cart-x display-4 text-muted"></i>
                    <h4 class="mt-3">Chưa có món nào</h4>
                    <a href="<%= ctx %>/menu" class="btn btn-primary-custom mt-3">Chọn món ngay</a>
                </div>
                <%
                        }
                    } else {
                %>

                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead>
                        <tr>
                            <th>Món ăn</th>
                            <th width="140">SL</th>
                            <th width="150">Thành tiền</th>
                            <th width="60"></th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            for (Product p : list) {
                                double sub = p.getPrice() * p.getQuantity();
                                total += sub;
                        %>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                <%
                                    String cartImg = p.getImage();
                                    if (cartImg != null && !cartImg.startsWith("http")) {
                                        cartImg = ctx + "/" + cartImg;
                                    }
                                %>
                                <img src="<%= cartImg %>" class="cart-img" alt=""
                                     onerror="this.src='<%= ctx %>/images/default.jpg'">
                                    <div>
                                        <div class="fw-bold"><%= p.getName() %></div>
                                        <div class="price" style="font-size:0.95rem;"><%= String.format("%,.0f", p.getPrice()) %> đ</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <a href="<%= ctx %>/cart/decrease/<%= p.getId() %>" class="btn qty-btn">−</a>
                                    <span class="fw-bold px-2"><%= p.getQuantity() %></span>
                                    <a href="<%= ctx %>/cart/increase/<%= p.getId() %>" class="btn qty-btn">+</a>
                                </div>
                            </td>
                            <td class="fw-bold" style="color:var(--success);">
                                <%= String.format("%,.0f", sub) %> đ
                            </td>
                            <td>
                                <a href="<%= ctx %>/cart/remove/<%= p.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Xóa món này?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="total-box glass-card sticky-top" style="top:100px;">
                <h4 class="mb-4"><i class="bi bi-receipt"></i> Thanh toán</h4>

                <div class="d-flex justify-content-between mb-3 text-muted">
                    <span>Tạm tính:</span>
                    <span><%= String.format("%,.0f", total) %> đ</span>
                </div>

                <hr style="border-color:var(--border-glass);">

                <div class="d-flex justify-content-between fs-5 fw-bold mb-4">
                    <span>Tổng cộng:</span>
                    <span class="price"><%= String.format("%,.0f", total) %> đ</span>
                </div>

                <a href="<%= ctx %>/checkout"
                   class="btn btn-primary-custom w-100 mb-2">
                    <i class="bi bi-calendar-check"></i> Đặt bàn & Thanh toán
                </a>

                <a href="<%= ctx %>/cart/clear" class="btn btn-outline-light w-100 btn-sm">
                    Xóa toàn bộ
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
