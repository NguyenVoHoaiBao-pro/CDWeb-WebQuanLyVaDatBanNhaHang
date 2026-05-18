<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<%
  String ctx = request.getContextPath();
  Integer tableId = (Integer) request.getAttribute("tableId");
%>

<jsp:include page="layout/header.jsp"/>

<style>
  body{
    background:#f8f9fa;
  }

  .booking-box{
    background:#fff;
    padding:35px;
    border-radius:20px;
    box-shadow:0 10px 30px rgba(0,0,0,.08);
  }

  .title{
    font-weight:700;
    margin-bottom:20px;
  }

  .form-control{
    border-radius:10px;
    padding:10px;
  }

  .btn-book{
    border-radius:12px;
    padding:12px;
    font-weight:600;
  }
</style>

<div class="container py-5">

  <div class="row justify-content-center">

    <div class="col-lg-6">

      <div class="booking-box">

        <div class="text-center mb-4">
          <h2 class="title">📅 Đặt bàn</h2>
          <p class="text-muted">Hoàn tất thông tin để giữ chỗ</p>
        </div>
        <c:if test="${error != null}">
          <div class="alert alert-danger text-center">
              ${error}
          </div>
        </c:if>

        <% if(tableId == null){ %>

        <div class="alert alert-danger text-center">
          Không tìm thấy bàn!
        </div>

        <% } else { %>

        <form action="<%=ctx%>/book-table" method="post">

          <input type="hidden" name="tableId" value="<%=tableId%>"/>

          <!-- TABLE -->
          <div class="mb-3">
            <label class="form-label">Bàn đã chọn</label>
            <input type="text" class="form-control"
                   value="Bàn #<%=tableId%>" disabled>
          </div>

          <!-- TIME -->
          <div class="mb-3">
            <label class="form-label">Thời gian</label>
            <input type="datetime-local"
                   name="reservationTime"
                   class="form-control"
                   required>
          </div>

          <!-- PEOPLE -->
          <div class="mb-4">
            <label class="form-label">Số người</label>
            <input type="number"
                   name="numberOfPeople"
                   class="form-control"
                   min="1"
                   required>
          </div>

          <!-- BUTTON -->
          <button class="btn btn-danger w-100 btn-book">
            ✔ Xác nhận đặt bàn
          </button>

        </form>

        <% } %>

        <!-- BACK -->
        <div class="text-center mt-3">
          <a href="<%=ctx%>/tables" class="text-decoration-none">
            ← Quay lại chọn bàn
          </a>
        </div>

      </div>

    </div>

  </div>

</div>

<jsp:include page="layout/footer.jsp"/>