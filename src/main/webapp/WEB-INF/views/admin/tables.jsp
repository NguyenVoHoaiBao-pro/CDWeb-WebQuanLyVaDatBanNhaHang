<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<% List<RestaurantTable> list = (List<RestaurantTable>) request.getAttribute("list"); %>

<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
    <div>
        <h2 class="fw-bold mb-1">🪑 Quản lý bàn</h2>
        <small class="text-muted">
            Tổng số bàn: <%= (list != null) ? list.size() : 0 %>
        </small>
    </div>

    <a href="${pageContext.request.contextPath}/admin/add-table" class="btn btn-success">
        + Thêm bàn mới
    </a>
</div>

<div class="card-box">
    <table id="tableTable" class="table table-bordered table-hover text-center align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên bàn</th>
                <th>Sức chứa</th>
                <th>Trạng thái</th>
                <th width="250">Thao tác</th>
            </tr>
        </thead>

        <tbody>
            <% if (list != null) {
                for (RestaurantTable t : list) { %>
            <tr>
                <td><%=t.getId()%></td>
                <td><%=t.getName()%></td>
                <td><%=t.getCapacity()%> người</td>
                <td>
                    <span class="badge 
                        <%= "AVAILABLE".equals(t.getStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                        <%= "AVAILABLE".equals(t.getStatus()) ? "Còn trống" : "Đã đặt" %>
                    </span>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/AVAILABLE"
                       class="btn btn-success btn-sm">
                        Set còn trống
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/RESERVED"
                       class="btn btn-warning btn-sm">
                        Set đã đặt
                    </a>
                </td>
            </tr>
            <% }
            } %>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function() {
        $('#tableTable').DataTable({
            "language": {
                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
            },
            "pageLength": 10,
            "order": [[0, "asc"]]
        });
    });
</script>