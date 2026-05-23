<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>
<%
    String ctx = request.getContextPath();
    Integer tableId = (Integer) request.getAttribute("tableId");
    RestaurantTable table = (RestaurantTable) request.getAttribute("table");
    List<RestaurantTable> tables = (List<RestaurantTable>) request.getAttribute("tables");
    String scheduleJson = (String) request.getAttribute("scheduleJson");
    String rulesJson = (String) request.getAttribute("rulesJson");
    if (scheduleJson == null) scheduleJson = "[]";
    if (rulesJson == null) rulesJson = "{}";
    if (tables == null) tables = new ArrayList<>();
%>
<div class="staff-topbar">
    <div>
        <h1 class="admin-page-title mb-1"><i class="bi bi-plus-circle"></i> Khách walk-in</h1>
        <p class="text-muted mb-0">Chọn bàn, khung giờ, gọi món ngay tại quầy</p>
    </div>
</div>

<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-danger"><%= request.getAttribute("error") %></div>
<% } %>

<div class="row g-3">
    <div class="col-lg-3">
        <div class="staff-card">
            <h6>Chọn bàn</h6>
            <div class="list-group list-group-flush">
                <% for (RestaurantTable t : tables) { %>
                <a href="<%= ctx %>/staff/walk-in?tableId=<%= t.getId() %>"
                   class="list-group-item list-group-item-action bg-transparent text-light border-secondary <%= tableId != null && tableId == t.getId() ? "active" : "" %>">
                    <%= t.getName() %> <small class="text-muted">(<%= t.getCapacity() %> ng)</small>
                </a>
                <% } %>
            </div>
        </div>
    </div>

    <% if (tableId != null) { %>
    <div class="col-lg-9">
        <form method="post" action="<%= ctx %>/staff/walk-in/book" id="bookingForm">
            <input type="hidden" name="tableId" value="<%= tableId %>">
            <input type="hidden" name="reservationTime" id="reservationTime">
            <input type="hidden" name="reservationEndTime" id="reservationEndTime">

            <div class="glass-card p-3 mb-3">
                <div class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">Tên khách (tùy chọn)</label>
                        <input type="text" name="guestName" class="form-control" placeholder="Anh/chị...">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Số người</label>
                        <input type="number" name="numberOfPeople" class="form-control" min="1" max="20" value="2" required>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label">Khung đã chọn</label>
                        <input type="text" id="selectedSlotDisplay" class="form-control" readonly placeholder="Chọn trên lịch">
                    </div>
                </div>
            </div>

            <div class="staff-card">
                <p id="selectionHint" class="small text-muted">Nhấn khung giờ đầu, rồi khung cuối (tối đa 3 khung liên tiếp).</p>
                <div id="bookingCalendar" class="booking-calendar"
                     data-table-id="<%= tableId %>"
                     data-ctx="<%= ctx %>"
                     data-schedule='<%= scheduleJson.replace("'", "&#39;") %>'></div>
                <button type="submit" class="btn btn-primary-custom mt-3" id="btnConfirmBooking" disabled>
                    Xác nhận &amp; gọi món
                </button>
            </div>
        </form>
    </div>
    <% } else { %>
    <div class="col-lg-9">
        <div class="glass-card p-5 text-center text-muted">Chọn bàn bên trái để mở lịch khung giờ</div>
    </div>
    <% } %>
</div>

<script type="application/json" id="reservationRulesData"><%= rulesJson %></script>
<script src="<%= ctx %>/js/reservation-rules.js"></script>
<script src="<%= ctx %>/js/booking-calendar.js"></script>
