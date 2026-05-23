<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="vn.edu.hcmuaf.fit.model.RestaurantTable" %>



<%

    String ctx = request.getContextPath();

    request.setAttribute("pageTitle", "Đặt bàn — Nhà Hàng Của Chúng Ta");

    Integer tableId = (Integer) request.getAttribute("tableId");

    RestaurantTable table = (RestaurantTable) request.getAttribute("table");

    String scheduleJson = (String) request.getAttribute("scheduleJson");

    if (scheduleJson == null) scheduleJson = "[]";

%>



<jsp:include page="layout/header.jsp"/>



<section class="page-hero">

    <div class="container">

        <h1>📅 Đặt bàn</h1>

        <p>Mỗi khung giờ 2 giờ — chọn tối đa 3 khung liên tiếp; khung thứ 4 tự động dành cho dọn bàn</p>

    </div>

</section>



<div class="container py-5">

    <div class="table-booking-steps mb-4">

        <span class="step done"><i class="bi bi-check-circle-fill"></i> Chọn bàn</span>

        <span class="step active"><i class="bi bi-2-circle-fill"></i> Thông tin</span>

        <span class="step"><i class="bi bi-3-circle"></i> Gọi món</span>

    </div>



    <c:if test="${error != null}">

        <div class="alert alert-danger text-center mb-4">

            <i class="bi bi-exclamation-triangle"></i> ${error}

        </div>

    </c:if>



    <% if (tableId == null) { %>

    <div class="booking-form-card">

        <div class="glass-card p-4 text-center">

            <p class="text-muted mb-3">Không tìm thấy bàn. Vui lòng chọn lại.</p>

            <a href="<%= ctx %>/tables" class="btn btn-primary-custom">

                <i class="bi bi-arrow-left"></i> Quay lại chọn bàn

            </a>

        </div>

    </div>

    <% } else { %>



    <div class="row g-4">

        <div class="col-lg-4">

            <div class="glass-card p-4 booking-table-info">

                <h3 class="fw-bold mb-3"><i class="bi bi-grid-3x3-gap"></i> Thông tin bàn</h3>

                <% if (table != null) { %>

                <p class="mb-2"><strong><%= table.getName() %></strong></p>

                <p class="text-muted mb-2">

                    <i class="bi bi-people"></i> Sức chứa: <strong><%= table.getCapacity() %></strong> người

                </p>

                <% } else { %>

                <p class="mb-2"><strong>Bàn #<%= tableId %></strong></p>

                <% } %>

                <ul class="small text-muted mb-3 ps-3">

                    <li>1 khung giờ = <strong>2 giờ</strong> (VD: 08:00–10:00)</li>

                    <li>Chọn <strong>1 đến 3 khung giờ</strong> liên tiếp (tối đa 6 giờ ngồi)</li>

                    <li><strong>Khung thứ 4</strong> = dọn bàn (tự động, không cần chọn)</li>

                </ul>

                <div class="booking-legend-vertical">

                    <span><span class="legend-dot available"></span> Trống</span>

                    <span><span class="legend-dot booked"></span> Đã đặt</span>

                    <span><span class="legend-dot cleaning"></span> Khung dọn bàn</span>

                    <span><span class="legend-dot past"></span> Đã qua</span>

                </div>

            </div>

        </div>



        <div class="col-lg-8">

            <div class="glass-card p-4 p-md-5 booking-calendar-wrap">

                <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">

                    <h2 class="fw-bold mb-0"><i class="bi bi-calendar3"></i> Lịch đặt bàn</h2>

                    <button type="button" class="btn btn-outline-custom btn-sm" id="btnResetSelection">

                        <i class="bi bi-arrow-counterclockwise"></i> Chọn lại

                    </button>

                </div>



                <p id="selectionHint" class="text-muted small mb-3">

                    Nhấn khung giờ đầu, rồi khung cuối (tối đa 3 khung, mỗi khung 2 giờ).

                </p>



                <div id="bookingCalendar"

                     class="booking-calendar"

                     data-table-id="<%= tableId %>"

                     data-ctx="<%= ctx %>"

                     data-schedule='<%= scheduleJson.replace("'", "&#39;") %>'>

                </div>



                <form action="<%= ctx %>/book-table" method="post" id="bookingForm" class="mt-4">

                    <input type="hidden" name="tableId" value="<%= tableId %>"/>

                    <input type="hidden" name="reservationTime" id="reservationTime" required/>

                    <input type="hidden" name="reservationEndTime" id="reservationEndTime" required/>



                    <div class="row g-3">

                        <div class="col-md-6">

                            <label class="form-label">Khung giờ đã chọn</label>

                            <input type="text" id="selectedSlotDisplay" class="form-control" readonly

                                   placeholder="VD: 08:00 → 16:00">

                        </div>

                        <div class="col-md-6">

                            <label class="form-label">Số người</label>

                            <input type="number"

                                   name="numberOfPeople"

                                   class="form-control"

                                   min="1"

                                   <% if (table != null) { %>max="<%= table.getCapacity() %>"<% } %>

                                   placeholder="VD: 4"

                                   required>

                        </div>

                    </div>



                    <button type="submit" class="btn btn-primary-custom w-100 btn-lg mt-4" id="btnConfirmBooking" disabled>

                        <i class="bi bi-check-circle"></i> Xác nhận đặt bàn

                    </button>

                </form>

            </div>

        </div>

    </div>



    <div class="text-center mt-4">

        <a href="<%= ctx %>/tables" class="text-muted">

            <i class="bi bi-arrow-left"></i> Quay lại chọn bàn

        </a>

    </div>



    <% } %>

</div>



<script id="reservationRulesData" type="application/json"><%= request.getAttribute("rulesJson") != null ? request.getAttribute("rulesJson") : "{}" %></script>
<script src="<%= ctx %>/js/reservation-rules.js"></script>
<script src="<%= ctx %>/js/booking-calendar.js"></script>



<jsp:include page="layout/footer.jsp"/>

