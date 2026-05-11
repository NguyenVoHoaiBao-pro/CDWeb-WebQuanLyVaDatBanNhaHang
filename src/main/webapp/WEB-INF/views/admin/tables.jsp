
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>

<%
    List<RestaurantTable> list =
            (List<RestaurantTable>) request.getAttribute("list");
%>

<h2 class="mb-4 fw-bold">🪑 Manage Tables</h2>

<div class="card-box">

    <div class="d-flex justify-content-between mb-3">

        <a href="${pageContext.request.contextPath}/admin/add-table"
           class="btn btn-success">
            + Add Table
        </a>

    </div>

    <table class="table table-bordered table-hover text-center align-middle">

        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Capacity</th>
            <th>Status</th>
            <th width="250">Action</th>
        </tr>
        </thead>

        <tbody>

        <%
            if(list != null){
                for(RestaurantTable t : list){
        %>

        <tr>

            <td><%=t.getId()%></td>

            <td><%=t.getName()%></td>

            <td><%=t.getCapacity()%></td>

            <td>
            <span class="badge
                <%= "AVAILABLE".equals(t.getStatus()) ? "bg-success" :
                    "RESERVED".equals(t.getStatus()) ? "bg-warning text-dark" :
                    "bg-secondary" %>">
                <%=t.getStatus()%>
            </span>
            </td>

            <td>

                <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/AVAILABLE"
                   class="btn btn-success btn-sm">
                    Set Available
                </a>

                <a href="${pageContext.request.contextPath}/admin/change-table/<%=t.getId()%>/RESERVED"
                   class="btn btn-warning btn-sm">
                    Set Reserved
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
