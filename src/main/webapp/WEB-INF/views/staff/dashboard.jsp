<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.*" %>
<%@ page import="vn.edu.hcmuaf.fit.util.DateUtil" %>
<%
    String ctx = request.getContextPath();
    String selectedDate = (String) request.getAttribute("selectedDate");
    List<Reservation> list = (List<Reservation>) request.getAttribute("reservations");
    if (list == null) list = new ArrayList<>();
%>
<div class="staff-topbar">
    <div>
        <h1><i class="bi bi-calendar-day"></i> Lịch vận hành</h1>
        <p class="text-muted small mb-0">Ngày <%= DateUtil.formatDate(selectedDate) %></p>
    </div>
    <form class="d-flex gap-2 align-items-end" method="get" action="<%= ctx %>/staff">
        <div>
            <label class="form-label small text-muted mb-0">Chọn ngày</label>
            <input type="date" name="date" class="form-control form-control-sm" value="<%= selectedDate %>">
        </div>
        <button type="submit" class="staff-btn-primary btn btn-sm">Xem</button>
    </form>
</div>

<div class="row g-3 mb-3">
    <div class="col-6 col-md-3">
        <a href="<%= ctx %>/staff/walk-in" class="staff-card d-block text-decoration-none text-light h-100">
            <i class="bi bi-plus-circle fs-3 text-info"></i>
            <div class="fw-bold mt-2">Walk-in</div>
            <small class="text-muted">Đặt bàn + gọi món</small>
        </a>
    </div>
    <div class="col-6 col-md-3">
        <a href="<%= ctx %>/staff/cart" class="staff-card d-block text-decoration-none text-light h-100">
            <i class="bi bi-receipt fs-3 text-success"></i>
            <div class="fw-bold mt-2">Giỏ / Bill</div>
            <small class="text-muted">Xuất hóa đơn</small>
        </a>
    </div>
    <div class="col-6 col-md-3">
        <a href="<%= ctx %>/staff/schedule" class="staff-card d-block text-decoration-none text-light h-100">
            <i class="bi bi-search fs-3 text-warning"></i>
            <div class="fw-bold mt-2">Tra cứu</div>
            <small class="text-muted">Theo bàn / ngày</small>
        </a>
    </div>
    <div class="col-6 col-md-3">
        <a href="<%= ctx %>/menu" class="staff-card d-block text-decoration-none text-light h-100">
            <i class="bi bi-basket fs-3"></i>
            <div class="fw-bold mt-2">Thực đơn</div>
            <small class="text-muted">Gọi món nhanh</small>
        </a>
    </div>
</div>

<div class="staff-card">
    <h5 class="mb-3"><i class="bi bi-list-ul"></i> Đặt bàn trong ngày</h5>
    <div class="table-responsive">
        <table class="table table-dark table-hover align-middle mb-0">
            <thead>
            <tr>
                <th>Khung giờ</th>
                <th>Bàn</th>
                <th>Khách</th>
                <th>SL</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <% if (list.isEmpty()) { %>
            <tr><td colspan="5" class="text-center text-muted py-4">Chưa có đặt bàn</td></tr>
            <% } else {
                for (Reservation r : list) {
                    String guest = r.getGuestName();
                    if (guest == null || guest.isEmpty()) {
                        guest = r.getCustomerUsername() != null ? r.getCustomerUsername() : ("#" + r.getUserId());
                    }
            %>
            <tr>
                <td class="small"><%= DateUtil.formatDateTimeRange(r.getReservationStartTime(), r.getReservationEndTime()) %></td>
                <td><%= r.getTableName() != null ? r.getTableName() : ("Bàn " + r.getTableId()) %></td>
                <td><%= guest %></td>
                <td><%= r.getNumberOfPeople() %></td>
                <td class="text-end">
                    <a href="<%= ctx %>/staff/reservation/<%= r.getId() %>" class="btn btn-sm btn-outline-info">Chi tiết</a>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </div>
</div>
