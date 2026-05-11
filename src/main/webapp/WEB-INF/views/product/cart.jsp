<!-- FILE: WEB-INF/views/product/cart.jsp -->
<!-- TẠO FILE MỚI -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<Product> list =
            (List<Product>) request.getAttribute("list");

    if(list == null){
        list = new ArrayList<Product>();
    }

    double total = 0;
%>

<div class="container py-5">

    <h2 class="fw-bold mb-3">🛒 Giỏ hàng của bạn</h2>

    <%
        String error = (String) request.getAttribute("error");
        if(error != null){
    %>
    <div class="alert alert-warning text-center">
        <%=error%>
    </div>
    <%
        }
    %>

    <%
        Integer reservationId = (Integer) request.getAttribute("reservationId");
        if(reservationId != null){
    %>
    <div class="alert alert-info">
        🍽️ Bàn #<%=reservationId%>
    </div>
    <%
        }
    %>

    <div class="d-flex justify-content-end mb-4">
        <a href="<%=request.getContextPath()%>/menu"
           class="btn btn-outline-dark">
            ← Tiếp tục gọi món
        </a>
    </div>

    <div class="row g-4">

        <!-- LEFT -->
        <div class="col-lg-8">

            <div class="cart-box">

                <%
                    if(list.isEmpty()){
                        if(request.getAttribute("error") != null){
                %>

                <div class="text-center py-5">
                    <h4>Bạn chưa đặt bàn</h4>
                    <a href="<%=request.getContextPath()%>/tables"
                       class="btn btn-primary mt-3">
                        Chọn bàn ngay
                    </a>
                </div>

                <%
                } else {
                %>

                <div class="text-center py-5">
                    <h4>Chưa có món nào</h4>
                    <a href="<%=request.getContextPath()%>/menu"
                       class="btn btn-danger mt-3">
                        Chọn món ngay
                    </a>
                </div>

                <%
                    }
                } else {
                %>

                <table class="table align-middle">

                    <thead>
                    <tr>
                        <th>Món ăn</th>
                        <th width="140">SL</th>
                        <th width="150">Thành tiền</th>
                        <th width="80"></th>
                    </tr>
                    </thead>

                    <tbody>

                    <%
                        for(Product p : list){

                            double sub = p.getPrice() * p.getQuantity();
                            total += sub;
                    %>

                    <tr>

                        <td>
                            <div class="d-flex align-items-center gap-3">

                                <img src="<%=p.getImage()%>"
                                     class="cart-img"
                                     onerror="this.src='<%=request.getContextPath()%>/images/default.jpg'">

                                <div>
                                    <div class="fw-bold"><%=p.getName()%></div>
                                    <div class="text-danger">
                                        <%=String.format("%,.0f",p.getPrice())%> đ
                                    </div>
                                </div>

                            </div>
                        </td>

                        <td>

                            <div class="d-flex align-items-center gap-2">

                                <a href="<%=request.getContextPath()%>/cart/decrease/<%=p.getId()%>"
                                   class="btn btn-light qty-btn">-</a>

                                <span class="fw-bold"><%=p.getQuantity()%></span>

                                <a href="<%=request.getContextPath()%>/cart/increase/<%=p.getId()%>"
                                   class="btn btn-light qty-btn">+</a>

                            </div>

                        </td>

                        <td class="fw-bold text-success">
                            <%=String.format("%,.0f",sub)%> đ
                        </td>

                        <td>

                            <a href="<%=request.getContextPath()%>/cart/remove/<%=p.getId()%>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Xóa món này?')">
                                ✕
                            </a>

                        </td>

                    </tr>

                    <% } %>

                    </tbody>
                </table>

                <% } %>

            </div>
        </div>

        <!-- RIGHT -->
        <div class="col-lg-4">

            <div class="total-box">

                <h4 class="mb-4">Thanh toán</h4>

                <div class="d-flex justify-content-between mb-3">
                    <span>Tạm tính:</span>
                    <span><%=String.format("%,.0f",total)%> đ</span>
                </div>

                <div class="d-flex justify-content-between mb-3">
                    <span>Phí phục vụ:</span>
                    <span>0 đ</span>
                </div>

                <hr>

                <div class="d-flex justify-content-between fs-5 fw-bold mb-4">
                    <span>Tổng cộng:</span>
                    <span><%=String.format("%,.0f",total)%> đ</span>
                </div>

                <a href="<%=request.getContextPath()%>/checkout?reservationId=<%=reservationId%>"
                   class="btn btn-danger w-100 mb-2">
                    📅 Đặt bàn & Thanh toán
                </a>

                <a href="<%=request.getContextPath()%>/cart/clear"
                   class="btn btn-outline-light w-100">
                    Xóa toàn bộ
                </a>

            </div>

        </div>

    </div>

</div>

<jsp:include page="../layout/footer.jsp"/>