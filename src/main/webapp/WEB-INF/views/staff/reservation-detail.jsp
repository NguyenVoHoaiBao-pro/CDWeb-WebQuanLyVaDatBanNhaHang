<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.*,vn.edu.hcmuaf.fit.util.ReservationRules,vn.edu.hcmuaf.fit.util.DateUtil" %>
<%
    String ctx = request.getContextPath();
    Reservation r = (Reservation) request.getAttribute("reservation");
    RestaurantTable table = (RestaurantTable) request.getAttribute("table");
    List<String> foods = (List<String>) request.getAttribute("foods");
    Integer maxSlots = (Integer) request.getAttribute("maxSlots");
    if (foods == null) foods = new ArrayList<>();
    if (maxSlots == null) maxSlots = ReservationRules.MAX_BOOKING_SLOTS;

    int bookedSlots = 1;
    if (r != null) {
        java.time.LocalDateTime start = ReservationRules.parseDateTime(r.getReservationStartTime());
        java.time.LocalDateTime end = ReservationRules.parseDateTime(r.getReservationEndTime());
        if (start != null && end != null) {
            bookedSlots = Math.max(1, ReservationRules.countBookingSlots(start, end));
        }
    }
%>
<% if (r == null) { %>
<p class="text-danger">Không tìm thấy đặt bàn.</p>
<% } else { %>

<% if ("1".equals(request.getParameter("adjusted"))) { %>
<div class="alert alert-success">Đã điều chỉnh khung giờ — các khung dư được giải phóng để dọn bàn / đặt mới.</div>
<% } %>
<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-danger"><%= request.getAttribute("error") %></div>
<% } %>

<div class="dash-header">
    <div>
        <h1 class="admin-page-title mb-1">Đặt bàn #<%= r.getId() %></h1>
        <p class="text-muted mb-0">
            <%= table != null ? table.getName() : ("Bàn #" + r.getTableId()) %>
            — <%= DateUtil.formatDateTimeRange(r.getReservationStartTime(), r.getReservationEndTime()) %>
        </p>
    </div>
    <a href="<%= ctx %>/staff" class="btn btn-outline-custom btn-sm">← Danh sách</a>
</div>

<div class="row g-3">
    <div class="col-lg-6">
        <div class="glass-card p-4">
            <h5>Thông tin</h5>
            <p class="mb-1"><strong>Khách:</strong> <%= r.getGuestName() != null ? r.getGuestName() : r.getCustomerUsername() %></p>
            <p class="mb-1"><strong>Số người:</strong> <%= r.getNumberOfPeople() %></p>
            <p class="mb-1"><strong>Trạng thái:</strong> <%= r.getStatus() %></p>
            <p class="mb-1"><strong>Đã đặt:</strong> <%= bookedSlots %> khung giờ (<%= bookedSlots * 2 %> giờ)</p>
            <% if (r.getStaffAdjustedAt() != null) { %>
            <p class="mb-0 small text-warning"><i class="bi bi-pencil"></i> NV đã chỉnh lúc <%= r.getStaffAdjustedAt() %></p>
            <% } %>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="glass-card p-4">
            <h5><i class="bi bi-scissors"></i> Rút ngắn giữ bàn</h5>
            <p class="small text-muted">
                VD: khách đặt 3 khung (6h) nhưng chỉ ngồi 1 khung (2h) — chọn <strong>1 khung đã dùng</strong>
                để mở khung 2–3 cho dọn / đặt khác.
            </p>
            <form method="post" action="<%= ctx %>/staff/reservation/<%= r.getId() %>/adjust-slots">
                <label class="form-label">Số khung giờ khách thực tế dùng</label>
                <select name="usedSlots" class="form-select mb-3">
                    <% for (int i = 1; i <= bookedSlots; i++) { %>
                    <option value="<%= i %>"><%= i %> khung (<%= i * 2 %> giờ)</option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-warning w-100" onclick="return confirm('Xác nhận điều chỉnh khung giờ?');">
                    Cập nhật &amp; giải phóng khung dư
                </button>
            </form>
        </div>
    </div>
</div>

<div class="glass-card p-4 mt-3">
    <h5>Món đã gọi</h5>
    <% if (foods.isEmpty()) { %>
    <p class="text-muted mb-2">Chưa có món.</p>
    <a href="<%= ctx %>/menu" class="btn btn-primary-custom btn-sm" onclick="sessionStorage.setItem('staffRes','<%= r.getId() %>');">Gọi món</a>
    <% } else {
        for (String f : foods) { %>
    <div><i class="bi bi-dot"></i> <%= f %></div>
    <% }} %>
</div>

<% } %>
