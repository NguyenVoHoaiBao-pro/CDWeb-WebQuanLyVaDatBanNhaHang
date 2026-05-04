<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Reservation" %>

<jsp:include page="layout/header.jsp"/>

<%
    String ctx = request.getContextPath();

    List<Reservation> list =
            (List<Reservation>) request.getAttribute("list");

    if(list == null){
        list = new ArrayList<Reservation>();
    }
%>

<style>
    body{
        background:#f8f9fa;
    }

    .box{
        background:#fff;
        border-radius:20px;
        padding:30px;
        box-shadow:0 10px 30px rgba(0,0,0,.08);
    }
</style>

<div class="container py-5">

    <div class="box">

        <div class="d-flex justify-content-between align-items-center mb-4">

            <h3 class="fw-bold">📅 Booking Của Tôi</h3>

            <a href="<%=ctx%>/tables" class="btn btn-warning">
                + Đặt thêm
            </a>

        </div>

        <% if(list.isEmpty()){ %>

        <div class="alert alert-info text-center">
            Bạn chưa có lịch đặt bàn nào.
        </div>

        <% } else { %>

        <table class="table table-bordered text-center align-middle">

            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Bàn</th>
                <th>Thời Gian</th>
                <th>Số Người</th>
                <th>Trạng Thái</th>
                <th width="180">Thao tác</th>
            </tr>
            </thead>

            <tbody>

            <%
                for(Reservation r : list){
            %>

            <tr>
                <td><%=r.getId()%></td>
                <td>#<%=r.getTableId()%></td>
                <td><%=r.getReservationTime()%></td>
                <td><%=r.getNumberOfPeople()%></td>

                <td>
                    <span class="badge bg-info">
                        <%=r.getStatus()%>
                    </span>
                </td>

                <td>
                    <% if("PENDING".equals(r.getStatus())){ %>

                    <a href="<%=ctx%>/cancel-booking/<%=r.getId()%>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Bạn muốn hủy đặt bàn này?')">
                        Hủy
                    </a>

                    <% } else { %>

                    <button class="btn btn-secondary btn-sm" disabled>
                        Không thể hủy
                    </button>

                    <% } %>
                </td>
            </tr>

            <% } %>

            </tbody>
        </table>

        <% } %>

    </div>

</div>

<jsp:include page="layout/footer.jsp"/>