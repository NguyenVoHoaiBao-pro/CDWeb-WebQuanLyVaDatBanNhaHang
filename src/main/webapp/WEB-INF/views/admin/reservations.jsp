<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Reservation" %>
<%@ page import="vn.edu.hcmuaf.fit.model.Order" %>
<%@ page import="vn.edu.hcmuaf.fit.dao.ReservationDAO" %>

<%
    List<Reservation> list = (List<Reservation>) request.getAttribute("list");
    if (list == null) list = new ArrayList<>();

    Map<Integer, Order> orderMap = (Map<Integer, Order>) request.getAttribute("orderMap");
    if (orderMap == null) orderMap = new HashMap<>();

    ReservationDAO foodDAO = new ReservationDAO();
%>

<h1 class="admin-page-title"><i class="bi bi-calendar-check"></i> Quản lý đặt bàn</h1>

<div class="card-box glass-card">
    <div class="table-responsive">
        <table id="resTable" class="table table-bordered table-hover text-center align-middle">
            <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Bàn</th>
                <th>Thời gian đặt</th>
                <th>Số người</th>
                <th>Món đã đặt</th>
                <th>Trạng thái</th>
                <th width="320">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (Reservation r : list) {
                    List<String> foods = foodDAO.getFoodsByReservation(r.getId());
                    Order order = orderMap.get(r.getId());
            %>
            <tr>
                <td><%= r.getId() %></td>
                <td>#<%= r.getUserId() %></td>
                <td>Bàn #<%= r.getTableId() %></td>
                <td class="text-start small">
                    <%= r.getReservationStartTime() != null ? r.getReservationStartTime() : r.getReservationTime() %>
                    <% if (r.getReservationEndTime() != null) { %>
                    <br><span class="text-muted">→ <%= r.getReservationEndTime() %></span>
                    <% } %>
                </td>
                <td><%= r.getNumberOfPeople() %></td>
                <td class="text-start">
                    <%
                        if (foods.isEmpty()) {
                    %>
                    <span class="text-muted">Chưa gọi món</span>
                    <%
                    } else {
                        for (String f : foods) {
                    %>
                    <div class="mb-1"><i class="bi bi-egg-fried"></i> <%= f %></div>
                    <%
                        }
                    }
                    %>
                </td>
                <td>
                    <%
                        String badge = "bg-danger";
                        String text = "Đã hủy";

                        if ("PENDING".equals(r.getStatus())) {
                            badge = "bg-warning text-dark";
                            text = "Chờ xác nhận";
                        }
                        if ("CONFIRMED".equals(r.getStatus())) {
                            badge = "bg-success";
                            text = "Đã xác nhận";
                        }
                        if ("DONE".equals(r.getStatus()) || "COMPLETED".equals(r.getStatus())) {
                            badge = "bg-primary";
                            text = "Hoàn thành";
                        }
                        if ("WAITING_PAYMENT".equals(r.getStatus())) {
                            badge = "bg-info text-dark";
                            text = "Chờ thanh toán";
                        }
                    %>
                    <span class="badge <%= badge %>"><%= text %></span>
                </td>
                <td>
                    <div class="d-flex flex-wrap gap-2 justify-content-center">
                        <a href="${pageContext.request.contextPath}/admin/reservation/<%= r.getId() %>/CONFIRMED"
                           class="btn btn-success btn-sm">Xác nhận</a>
                        <a href="${pageContext.request.contextPath}/admin/reservation/<%= r.getId() %>/DONE"
                           class="btn btn-primary btn-sm">Hoàn thành</a>
                        <a href="${pageContext.request.contextPath}/admin/reservation/<%= r.getId() %>/CANCELLED"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Hủy đặt bàn này?')">Hủy</a>
                        <a href="${pageContext.request.contextPath}/admin/bill/<%= r.getId() %>"
                           class="btn btn-dark btn-sm">
                            <i class="bi bi-receipt"></i> Bill
                        </a>
                    </div>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function () {
    $('#resTable').DataTable({
        language: { url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
        pageLength: 10,
        order: [[0, "desc"]]
    });
});
</script>
