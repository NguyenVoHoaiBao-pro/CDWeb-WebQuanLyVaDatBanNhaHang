<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Reservation" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Booking của tôi — Nhà Hàng Của Chúng Ta");

    List<Reservation> list = (List<Reservation>) request.getAttribute("list");
    if (list == null) list = new ArrayList<Reservation>();
%>

<jsp:include page="layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>📅 Booking của tôi</h1>
        <p>Quản lý lịch đặt bàn và thao tác nhanh</p>
    </div>
</section>

<div class="container py-5">
    <div class="booking-list-card glass-card p-4 p-md-5">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <h2 class="fw-bold mb-0"><i class="bi bi-journal-bookmark"></i> Lịch sử đặt bàn</h2>
            <a href="<%= ctx %>/tables" class="btn btn-primary-custom">
                <i class="bi bi-plus-lg"></i> Đặt thêm
            </a>
        </div>

        <% if (list.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-calendar-x display-4 text-muted"></i>
            <p class="text-muted mt-3 mb-4">Bạn chưa có lịch đặt bàn nào.</p>
            <a href="<%= ctx %>/tables" class="btn btn-primary-custom">Đặt bàn ngay</a>
        </div>
        <% } else { %>

        <div class="table-responsive">
            <table class="table table-bordered text-center align-middle mb-0">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Bàn</th>
                    <th>Thời gian</th>
                    <th>Số người</th>
                    <th>Trạng thái</th>
                    <th>Thanh toán</th>
                    <th width="200">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Reservation r : list) {
                        String statusLabel = r.getStatus();
                        if ("PENDING".equals(r.getStatus())) statusLabel = "Chờ xác nhận";
                        else if ("CONFIRMED".equals(r.getStatus())) statusLabel = "Đã xác nhận";
                        else if ("CANCELLED".equals(r.getStatus())) statusLabel = "Đã hủy";
                        else if ("DONE".equals(r.getStatus()) || "COMPLETED".equals(r.getStatus())) statusLabel = "Hoàn thành";
                        else if ("WAITING_PAYMENT".equals(r.getStatus())) statusLabel = "Chờ thanh toán";
                %>
                <tr>
                    <td>#<%= r.getId() %></td>
                    <td><i class="bi bi-grid"></i> Bàn #<%= r.getTableId() %></td>
                    <td>
                        <%= r.getReservationStartTime() != null ? r.getReservationStartTime() : r.getReservationTime() %>
                        <% if (r.getReservationEndTime() != null) { %>
                        <br><small class="text-muted">→ <%= r.getReservationEndTime() %></small>
                        <% } %>
                    </td>
                    <td><%= r.getNumberOfPeople() %></td>
                    <td>
                        <span class="booking-status <%= r.getStatus() %>"><%= statusLabel %></span>
                    </td>
                    <td>
                        <% if (r.getTotalPrice() > 0) { %>
                            <% if (r.getPaidAmount() >= r.getTotalPrice() * 0.5) { %>
                                <span class="badge bg-success">Đã cọc</span>
                            <% } else { %>
                                <span class="badge bg-warning text-dark">Chưa cọc</span>
                                <br>
                                <a href="<%= ctx %>/reservation/payment?id=<%= r.getId() %>" class="btn btn-link btn-sm p-0 mt-1">Thanh toán ngay</a>
                            <% } %>
                        <% } else { %>
                            <span class="text-muted">N/A</span>
                        <% } %>
                    </td>
                    <td>
                        <% if ("PENDING".equals(r.getStatus())) { %>
                        <div class="d-flex gap-2 justify-content-center flex-wrap">
                            <a href="<%= ctx %>/edit-booking/<%= r.getId() %>"
                               class="btn btn-warning btn-sm">
                                <i class="bi bi-pencil"></i> Sửa
                            </a>
                            <a href="<%= ctx %>/cancel-booking/<%= r.getId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn muốn hủy đặt bàn này?')">
                                <i class="bi bi-x-circle"></i> Hủy
                            </a>
                        </div>
                        <% } else { %>
                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                            Không thể sửa
                        </button>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="layout/footer.jsp"/>
