<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<% List<RestaurantTable> list = (List<RestaurantTable>) request.getAttribute("list"); %>

<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
        <h1 class="admin-page-title mb-1"><i class="bi bi-grid"></i> Quản lý bàn</h1>
        <small class="text-muted">Tổng số bàn: <%= (list != null) ? list.size() : 0 %></small>
    </div>
    <a href="${pageContext.request.contextPath}/admin/add-table" class="btn btn-success">
        <i class="bi bi-plus-lg"></i> Thêm bàn mới
    </a>
</div>

<div class="card-box glass-card">
    <div class="table-responsive">
        <table id="tableTable" class="table table-bordered table-hover text-center align-middle">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên bàn</th>
                <th>Sức chứa</th>
                <th>Tầng</th>
                <th>Vận hành</th>
                <th width="300">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (list != null) {
                for (RestaurantTable t : list) { %>
            <tr>
                <td><%= t.getId() %></td>
                <td class="fw-bold"><%= t.getName() %></td>
                <td><%= t.getCapacity() %> người</td>
                <td>
                    <%
                        if (t.getFloorNumber() == 0) {
                            out.print("Tầng trệt");
                        } else {
                            out.print("Tầng " + t.getFloorNumber());
                        }
                    %>
                </td>
                <td>
                    <%
                        String st = t.getStatus();
                        String stLabel = "Hoạt động";
                        String stClass = "bg-success";
                        if ("MAINTENANCE".equals(st)) {
                            stLabel = "Bảo trì";
                            stClass = "bg-secondary";
                        } else if ("RESERVED".equals(st)) {
                            stLabel = "Legacy — nên đặt Hoạt động";
                            stClass = "bg-warning text-dark";
                        }
                    %>
                    <span class="badge <%= stClass %>"><%= stLabel %></span>
                    <div class="small text-muted mt-1">Lịch đặt: bảng reservations</div>
                </td>
                <td>
                    <div class="d-flex gap-2 justify-content-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/admin/change-table/<%= t.getId() %>/AVAILABLE"
                           class="btn btn-success btn-sm">Hoạt động</a>
                        <a href="${pageContext.request.contextPath}/admin/change-table/<%= t.getId() %>/MAINTENANCE"
                           class="btn btn-secondary btn-sm">Bảo trì</a>
                        <a href="${pageContext.request.contextPath}/admin/tables/delete/<%= t.getId() %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Bạn có chắc muốn xóa bàn này?')">
                            <i class="bi bi-trash"></i> Xóa
                        </a>
                    </div>
                </td>
            </tr>
            <% }
            } %>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function () {
    $('#tableTable').DataTable({
        language: { url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
        pageLength: 10,
        order: [[0, "asc"]]
    });
});
</script>
