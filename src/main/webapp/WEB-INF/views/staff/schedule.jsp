<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.*" %>
<%@ page import="vn.edu.hcmuaf.fit.util.DateUtil" %>
<%
    String ctx = request.getContextPath();
    String selectedDate = (String) request.getAttribute("selectedDate");
    Integer tableId = (Integer) request.getAttribute("tableId");
    List<RestaurantTable> tables = (List<RestaurantTable>) request.getAttribute("tables");
    List<Reservation> bookings = (List<Reservation>) request.getAttribute("bookings");
    RestaurantTable table = (RestaurantTable) request.getAttribute("table");
    String scheduleJson = (String) request.getAttribute("scheduleJson");
    if (tables == null) tables = new ArrayList<>();
    if (bookings == null) bookings = new ArrayList<>();
    if (scheduleJson == null) scheduleJson = "[]";
%>
<div class="staff-topbar">
    <div>
        <h1><i class="bi bi-calendar-week"></i> Tra cứu lịch bàn</h1>
        <p class="text-muted small mb-0">Ngày <%= DateUtil.formatDate(selectedDate) %></p>
    </div>
    <form class="dash-filter glass-card p-2 px-3" method="get" action="<%= ctx %>/staff/schedule">
        <input type="date" name="date" class="form-control form-control-sm" value="<%= selectedDate %>">
        <select name="tableId" class="form-select form-select-sm">
            <option value="">— Tất cả bàn —</option>
            <% for (RestaurantTable t : tables) { %>
            <option value="<%= t.getId() %>" <%= tableId != null && tableId == t.getId() ? "selected" : "" %>><%= t.getName() %></option>
            <% } %>
        </select>
        <button type="submit" class="btn btn-primary-custom btn-sm">Xem</button>
    </form>
</div>

<div class="row g-3">
    <div class="col-lg-5">
        <div class="staff-card">
            <h6>Đặt bàn — <%= DateUtil.formatDate(selectedDate) %></h6>
            <div class="table-responsive" style="max-height:480px;">
                <table class="table table-sm table-hover">
                    <thead><tr><th>Giờ</th><th>Bàn</th><th>Khách</th><th></th></tr></thead>
                    <tbody>
                    <% if (bookings.isEmpty()) { %>
                    <tr><td colspan="4" class="text-muted text-center">Không có lịch</td></tr>
                    <% } else {
                        for (Reservation r : bookings) {
                            String g = r.getGuestName();
                            if (g == null || g.isEmpty()) g = r.getCustomerUsername();
                    %>
                    <tr>
                        <td class="small"><%= DateUtil.formatDateTimeRange(r.getReservationStartTime(), r.getReservationEndTime()) %></td>
                        <td><%= r.getTableName() != null ? r.getTableName() : r.getTableId() %></td>
                        <td><%= g %></td>
                        <td><a href="<%= ctx %>/staff/reservation/<%= r.getId() %>" class="btn btn-sm btn-outline-custom">Sửa</a></td>
                    </tr>
                    <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% if (tableId != null && table != null) { %>
    <div class="col-lg-7">
        <div class="staff-card">
            <h6>Lịch khung giờ — <%= table.getName() %></h6>
            <div id="bookingCalendar" class="booking-calendar"
                 data-table-id="<%= tableId %>"
                 data-ctx="<%= ctx %>"
                 data-schedule='<%= scheduleJson.replace("'", "&#39;") %>'></div>
            <p class="small text-muted mt-2 mb-0">Ô xám = đã đặt · Ô vàng nhạt = dọn bàn</p>
        </div>
    </div>
    <% } %>
</div>

<% if (tableId != null) { %>
<script src="<%= ctx %>/js/reservation-rules.js"></script>
<script src="<%= ctx %>/js/booking-calendar.js"></script>
<% } %>
