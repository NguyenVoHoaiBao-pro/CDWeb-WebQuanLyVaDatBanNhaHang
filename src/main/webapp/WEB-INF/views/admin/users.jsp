<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.User" %>

<% List<User> list = (List<User>) request.getAttribute("list"); %>

<h1 class="admin-page-title"><i class="bi bi-people"></i> Quản lý người dùng</h1>

<div class="card-box glass-card">
    <div class="table-responsive">
        <table id="userTable" class="table table-bordered table-hover text-center align-middle">
            <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>Quyền</th>
                <th width="220">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (list != null) {
                for (User u : list) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td class="fw-semibold"><%= u.getUsername() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td>
                    <span class="badge <%= "ADMIN".equals(u.getRole()) ? "bg-danger" : "bg-primary" %>">
                        <%= u.getRole() %>
                    </span>
                </td>
                <td>
                    <div class="d-flex gap-2 justify-content-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/admin/change-role/<%= u.getId() %>"
                           class="btn btn-warning btn-sm">
                            <i class="bi bi-arrow-repeat"></i> Đổi quyền
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/delete-user/<%= u.getId() %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Xóa user này?')">
                            <i class="bi bi-trash"></i> Xóa
                        </a>
                    </div>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
    </div>
</div>

<script>
$(document).ready(function () {
    $('#userTable').DataTable({
        language: { url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
        pageLength: 10,
        order: [[0, "asc"]]
    });
});
</script>
