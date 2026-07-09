<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="../layout/header.jsp"/>

<%
  Integer reservationId = (Integer) request.getAttribute("reservationId");
  String tableName = (String) request.getAttribute("tableName");
  if (reservationId == null) reservationId = 0;
  if (tableName == null) tableName = "Bàn ăn";
%>

<style>
  .success-box {
    background: var(--bg-card);
    max-width: 760px;
    margin: auto;
    padding: 50px;
    border-radius: 24px;
    box-shadow: 0 15px 40px rgba(0,0,0,.4);
    text-align: center;
    border: 1px solid var(--border-glass);
    backdrop-filter: blur(16px);
  }

  .icon {
    font-size: 72px;
  }

  .code {
    background: rgba(255,255,255,0.1);
    padding: 14px 20px;
    border-radius: 12px;
    display: inline-block;
    font-weight: 700;
    color: var(--text);
    border: 1px solid var(--border-glass);
  }
</style>

<div class="container py-5">
  <div class="success-box">
    <div class="icon mb-3">🔔</div>
    <h1 class="fw-bold mb-3" style="color: var(--text);">
      Đã gửi yêu cầu gọi món!
    </h1>
    <p class="mb-4" style="color: var(--text-muted);">
      Các món ăn bạn đã chọn đã được chuyển đến nhân viên tại quầy phục vụ của <strong><%= tableName %></strong>.
    </p>
    <div class="code mb-4">
      Mã đặt bàn: #<%= reservationId %>
    </div>
    <div class="mb-4">
      <div class="alert alert-success">
        Nhà bếp đang chuẩn bị món ăn cho bạn. Bạn có thể tiếp tục chọn thêm món mới bất kỳ lúc nào bằng cách sử dụng thực đơn.
      </div>
    </div>
    <div class="d-grid gap-3">
      <a href="<%= request.getContextPath() %>/menu" class="btn btn-primary-custom btn-lg">
        🍽 Tiếp tục chọn món
      </a>
      <a href="<%= request.getContextPath() %>/cart" class="btn btn-outline-custom">
        🛒 Xem giỏ hàng hiện tại
      </a>
    </div>
  </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
