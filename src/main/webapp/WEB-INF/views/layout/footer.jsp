<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>

<footer class="site-footer">
    <div class="container">
        <div class="row align-items-center gy-4">
            <div class="col-md-4 text-center text-md-start">
                <div class="footer-brand mb-2">🍽 Nhà Hàng Của Chúng Ta</div>
                <p class="text-muted small mb-0">Ẩm thực đẳng cấp — trải nghiệm tinh tế</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <a href="<%= ctx %>/">Trang chủ</a>
                    <a href="<%= ctx %>/menu">Thực đơn</a>
                    <a href="<%= ctx %>/tables">Đặt bàn</a>
                    <a href="<%= ctx %>/cart">Giỏ hàng</a>
                </div>
            </div>
            <div class="col-md-4 text-center text-md-end text-muted small">
                © 2026 Nhà Hàng Của Chúng Ta
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%= ctx %>/js/main.js"></script>

</body>
</html>
