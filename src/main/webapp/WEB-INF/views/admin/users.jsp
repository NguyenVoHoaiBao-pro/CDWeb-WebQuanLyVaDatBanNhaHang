<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.User" %>
<%@ page import="vn.edu.hcmuaf.fit.util.UserRoles" %>

<% List<User> list = (List<User>) request.getAttribute("list"); %>

<h1 class="admin-page-title"><i class="bi bi-people"></i> Quản lý người dùng</h1>
<p class="text-muted small mb-3">Phân quyền: <strong>Khách (USER)</strong> · <strong>Nhân viên (STAFF)</strong> · <strong>Quản trị (ADMIN)</strong></p>

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
                <th width="320">Phân quyền</th>
            </tr>
            </thead>
            <tbody>
            <% if (list != null) {
                for (User u : list) {
                    String role = u.getRole();
                    String badgeClass = "bg-primary";
                    if (UserRoles.ADMIN.equals(role)) badgeClass = "bg-danger";
                    else if (UserRoles.STAFF.equals(role)) badgeClass = "bg-info text-dark";
            %>
            <tr>
                <td><%= u.getId() %></td>
                <td class="fw-semibold"><%= u.getUsername() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td>
                    <span class="badge <%= badgeClass %>"><%= UserRoles.label(role) %></span>
                </td>
                <td>
                    <div class="d-flex gap-1 justify-content-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/admin/set-role/<%= u.getId() %>/USER"
                           class="btn btn-outline-primary btn-sm">Khách</a>
                        <a href="${pageContext.request.contextPath}/admin/set-role/<%= u.getId() %>/STAFF"
                           class="btn btn-outline-info btn-sm">NV</a>
                        <a href="${pageContext.request.contextPath}/admin/set-role/<%= u.getId() %>/ADMIN"
                           class="btn btn-outline-danger btn-sm">Admin</a>
                        <a href="${pageContext.request.contextPath}/admin/delete-user/<%= u.getId() %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Xóa user này?')">
                            <i class="bi bi-trash"></i>
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
