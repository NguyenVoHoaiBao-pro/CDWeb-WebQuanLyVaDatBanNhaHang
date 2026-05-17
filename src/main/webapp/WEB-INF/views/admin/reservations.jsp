<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Reservation" %>

        <% List<Reservation> list =
            (List<Reservation>) request.getAttribute("list");
                %>

                <h2 class="mb-4 fw-bold">📅 Quản lý đặt bàn</h2>

                <div class="card-box">

                    <table id="resTable" class="table table-bordered table-hover text-center align-middle">

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Bàn</th>
                                <th>Thời gian đặt</th>
                                <th>Số người</th>
                                <th>Trạng thái</th>
                                <th width="300">Action</th>
                            </tr>
                        </thead>

                        <tbody>

                            <% if(list !=null){ for(Reservation r : list){ %>

                                <tr>

                                    <td>
                                        <%=r.getId()%>
                                    </td>

                                    <td>#<%=r.getUserId()%>
                                    </td>

                                    <td>#<%=r.getTableId()%>
                                    </td>

                                    <td>
                                        <%=r.getReservationTime()%>
                                    </td>

                                    <td>
                                        <%=r.getNumberOfPeople()%>
                                    </td>

                                    <td>
                                        <span class="badge
                <%= "PENDING".equals(r.getStatus()) ? "bg-warning text-dark" : 
                    "CONFIRMED".equals(r.getStatus()) ? "bg-success" : 
                    "DONE".equals(r.getStatus()) ? "bg-primary" : "bg-danger" %>">
                                            <%= "PENDING".equals(r.getStatus()) ? "Chờ xác nhận" :
                                                "CONFIRMED".equals(r.getStatus()) ? "Đã xác nhận" :
                                                "DONE".equals(r.getStatus()) ? "Hoàn thành" : "Đã hủy" %>
                                        </span>
                                    </td>


                                    <td>

                                        <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/CONFIRMED"
                                            class="btn btn-success btn-sm">
                                            Xác nhận
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/DONE"
                                            class="btn btn-primary btn-sm">
                                            Hoàn thành
                                        </a>

                                        <a href="${pageContext.request.contextPath}/admin/reservation/<%=r.getId()%>/CANCELLED"
                                            class="btn btn-danger btn-sm">
                                            Hủy
                                        </a>

                                    </td>

                                </tr>

                                <% } } %>

                        </tbody>

                    </table>

                </div>

                <script>
                    $(document).ready(function () {
                        $('#resTable').DataTable({
                            "language": {
                                "url": "https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                            },
                            "pageLength": 10,
                            "order": [[0, "desc"]]
                        });
                    });
                </script>