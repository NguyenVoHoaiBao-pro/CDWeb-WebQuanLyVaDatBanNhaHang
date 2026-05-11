<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.User" %>

<%
    List<User> list = (List<User>) request.getAttribute("list");
%>

<h2 class="mb-4 fw-bold">👤 Manage Users</h2>

<div class="card-box">

    <table class="table table-bordered table-hover text-center align-middle">

        <thead>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th width="220">Action</th>
        </tr>
        </thead>

        <tbody>

        <%
            if(list != null){
                for(User u : list){
        %>

        <tr>

            <td><%=u.getId()%></td>

            <td><%=u.getUsername()%></td>

            <td><%=u.getFullName()%></td>

            <td><%=u.getEmail()%></td>

            <td>
            <span class="badge bg-primary">
                <%=u.getRole()%>
            </span>
            </td>

            <td>

                <a href="${pageContext.request.contextPath}/admin/change-role/<%=u.getId()%>"
                   class="btn btn-warning btn-sm">
                    Change Role
                </a>

                <a href="${pageContext.request.contextPath}/admin/delete-user/<%=u.getId()%>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this user?')">
                    Delete
                </a>

            </td>

        </tr>

        <%
                }
            }
        %>

        </tbody>

    </table>

</div>
