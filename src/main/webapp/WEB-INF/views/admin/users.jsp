<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.User" %>

<%
    List<User> list = (List<User>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Users</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body{
            background:#f5f6fa;
        }

        .sidebar{
            width:240px;
            height:100vh;
            position:fixed;
            left:0;
            top:0;
            background:#111827;
            padding-top:20px;
        }

        .sidebar a{
            display:block;
            color:white;
            padding:14px 20px;
            text-decoration:none;
        }

        .sidebar a:hover{
            background:#1f2937;
        }

        .content{
            margin-left:240px;
            padding:30px;
        }

        table{
            background:white;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h4 class="text-white text-center mb-4">🍽 ADMIN</h4>

    <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products">Products</a>
    <a href="${pageContext.request.contextPath}/admin/users">Users</a>
    <a href="${pageContext.request.contextPath}/admin/tables">Tables</a>
    <a href="${pageContext.request.contextPath}/admin/reservations">Reservations</a>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<div class="content">

    <h2 class="mb-4">Manage Users</h2>

    <table class="table table-bordered table-hover text-center align-middle">

        <tr class="table-dark">
            <th>ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th width="220">Action</th>
        </tr>

        <% for(User u : list){ %>

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

                <a class="btn btn-warning btn-sm"
                   href="${pageContext.request.contextPath}/admin/change-role/<%=u.getId()%>">
                    Change Role
                </a>

                <a class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this user?')"
                   href="${pageContext.request.contextPath}/admin/delete-user/<%=u.getId()%>">
                    Delete
                </a>

            </td>
        </tr>

        <% } %>

    </table>

</div>

</body>
</html>