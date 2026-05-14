
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Reservation" %>

<%
    List<Reservation> list =
            (List<Reservation>) request.getAttribute("list");
%>

<h2 class="mb-4 fw-bold">📅 Manage Reservations</h2>

<div class="card-box">

    <table class="table table-bordered table-hover text-center align-middle">

        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Table</th>
            <th>Time</th>
            <th>People</th>
            <th>Status</th>
            <th width="300">Action</th>
        </tr>
        </thead>

        <tbody>

        <%
            if(list != null){
                for(Reservation r : list){
        %>

        <tr>

            <td><%=r.getId()%></td>

            <td>#<%=r.getUserId()%></td>

            <td>#<%=r.getTableId()%></td>

            <td><%=r.getReservationTime()%></td>

            <td><%=r.getNumberOfPeople()%></td>

            <td>
            <span class="badge
                <%= "PENDING".equals(r.getStatus()) ? "bg-warning text-dark" :
                    "CONFIRMED".equals(r.getStatus()) ? "bg-success" :
                    "DONE".equals(r.getStatus()) ? "bg-primary" :
                    "bg-danger" %>">
                <%=r.getStatus()%>
            </span>
            </td>

            <td>

                <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/CONFIRMED"
                   class="btn btn-success btn-sm">
                    Confirm
                </a>

                <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/DONE"
                   class="btn btn-primary btn-sm">
                    Done
                </a>

                <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/CANCELLED"
                   class="btn btn-danger btn-sm">
                    Cancel
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
