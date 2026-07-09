<!-- FILE: WEB-INF/views/product/success.jsp -->


<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="../layout/header.jsp"/>

<%
  Integer orderId =
          (Integer) session.getAttribute("orderId");

  String payment =
          (String) session.getAttribute("payment");

  if(orderId == null) orderId = 0;
  if(payment == null) payment = "COD";
%>

<style>
  .success-box{
    background: var(--bg-card);
    max-width:760px;
    margin:auto;
    padding:50px;
    border-radius:24px;
    box-shadow:0 15px 40px rgba(0,0,0,.4);
    text-align:center;
    border: 1px solid var(--border-glass);
    backdrop-filter: blur(16px);
  }

  .icon{
    font-size:72px;
  }

  .code{
    background: rgba(255,255,255,0.1);
    padding:14px 20px;
    border-radius:12px;
    display:inline-block;
    font-weight:700;
    color: var(--text);
    border: 1px solid var(--border-glass);
  }
</style>

<div class="container py-5">

  <div class="success-box">

    <div class="icon mb-3">✅</div>

    <h1 class="fw-bold mb-3" style="color: var(--text);">
      Đặt bàn thành công!
    </h1>

    <p class="mb-4" style="color: var(--text-muted);">
      Cảm ơn bạn đã đặt bàn tại nhà hàng của chúng tôi.
    </p>

    <div class="code mb-4">
      Mã đơn hàng: #<%=orderId%>
    </div>

    <div class="mb-4">

      <% if(payment != null && payment.startsWith("ONLINE_")){ %>

      <div class="alert alert-success">
        Đã thanh toán thành công qua <%= payment.replace("ONLINE_", "") %>.
      </div>

      <% } else if("DEPOSIT".equals(payment)){ %>

      <div class="alert alert-warning">
        Bạn đã chọn <b>Đặt cọc trước</b>.
        Vui lòng thanh toán tại quầy hoặc chuyển khoản.
      </div>

      <% } else { %>

      <div class="alert alert-success">
        Bạn đã chọn <b>Thanh toán sau khi dùng bữa</b>.
      </div>

      <% } %>

    </div>

    <div class="d-grid gap-3">

      <a href="<%=request.getContextPath()%>/menu"
         class="btn btn-primary-custom btn-lg">
        🍽 Tiếp tục gọi món
      </a>

      <a href="<%=request.getContextPath()%>/"
         class="btn btn-outline-custom">
        🏠 Về trang chủ
      </a>

    </div>

  </div>

</div>

<%
  session.removeAttribute("orderId");
  session.removeAttribute("payment");
%>

<jsp:include page="../layout/footer.jsp"/>