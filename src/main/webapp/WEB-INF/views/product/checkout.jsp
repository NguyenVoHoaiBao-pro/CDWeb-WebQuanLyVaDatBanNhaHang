<!-- FILE: WEB-INF/views/product/checkout.jsp -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Product" %>
<%@ page import="vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<jsp:include page="../layout/header.jsp"/>

<%
    List<Product> cart =
            (List<Product>) request.getAttribute("list");
    List<RestaurantTable> tables =
            (List<RestaurantTable>) request.getAttribute("tables");

    if(cart == null) cart = new ArrayList<Product>();
    if(tables == null) tables = new ArrayList<RestaurantTable>();

    double total = 0;
    for(Product p : cart){
        total += p.getPrice() * p.getQuantity();
    }
%>

<div class="container py-5">

    <h2 class="fw-bold mb-4">📅 Đặt bàn & Thanh toán</h2>

    <div class="row g-4">

        <!-- LEFT -->
        <div class="col-lg-7">

            <div class="box">

                <form method="post"
                      action="<%=request.getContextPath()%>/checkout">

                    <div class="mb-3">

                        <label class="form-label">
                            Mã đặt bàn
                        </label>

                        <input type="text"
                               class="form-control"
                               value="#${reservation.id}"
                               readonly>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Bàn
                        </label>

                        <input type="text"
                               class="form-control"
                               value="Bàn #${reservation.tableId}"
                               readonly>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Thời gian đến
                        </label>

                        <input type="text"
                               class="form-control"
                               value="${reservation.reservationTime}"
                               readonly>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">
                            Số người
                        </label>

                        <input type="text"
                               class="form-control"
                               value="${reservation.numberOfPeople}"
                               readonly>

                    </div>

                    <div class="mb-3">
                        <label class="form-label">Thanh toán</label>

                        <select name="payment"
                                class="form-select">

                            <option value="COD">Trả sau khi ăn</option>
                            <option value="DEPOSIT">Đặt cọc trước</option>

                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ghi chú</label>
                        <textarea name="note"
                                  rows="4"
                                  class="form-control"></textarea>
                    </div>

                    <button class="btn btn-danger w-100 btn-lg">
                        Xác nhận đặt bàn
                    </button>

                </form>

            </div>

        </div>

        <!-- RIGHT -->
        <div class="col-lg-5">

            <div class="box">

                <h4 class="mb-4">🛒 Đơn hàng</h4>

                <% for(Product p : cart){ %>

                <div class="order-item d-flex justify-content-between">

                    <div>
                        <div class="fw-bold"><%=p.getName()%></div>
                        <small>x <%=p.getQuantity()%></small>
                    </div>

                    <div>
                        <%=String.format("%,.0f",
                                p.getPrice()*p.getQuantity())%> đ
                    </div>

                </div>

                <% } %>

                <hr>

                <div class="d-flex justify-content-between align-items-center">

                    <span>Tổng cộng:</span>

                    <span class="total">
<%=String.format("%,.0f",total)%> đ
</span>

                </div>

            </div>

        </div>

    </div>

</div>

<jsp:include page="../layout/footer.jsp"/>