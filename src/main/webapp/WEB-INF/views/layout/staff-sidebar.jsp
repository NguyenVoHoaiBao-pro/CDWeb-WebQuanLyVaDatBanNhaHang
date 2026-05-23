<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<div class="admin-sidebar staff-sidebar" id="adminSidebar">
    <h4><i class="bi bi-person-workspace"></i> Nhân viên</h4>
    <a href="<%= ctx %>/staff" data-admin-nav="/staff">
        <i class="bi bi-calendar-day"></i> Lịch hôm nay
    </a>
    <a href="<%= ctx %>/staff/schedule" data-admin-nav="/staff/schedule">
        <i class="bi bi-calendar-week"></i> Tra cứu bàn / ngày
    </a>
    <a href="<%= ctx %>/staff/walk-in" data-admin-nav="/staff/walk-in">
        <i class="bi bi-plus-circle"></i> Khách walk-in
    </a>
    <a href="<%= ctx %>/menu" data-admin-nav>
        <i class="bi bi-basket"></i> Thực đơn / gọi món
    </a>
    <a href="<%= ctx %>/staff/cart" data-admin-nav="/staff/cart">
        <i class="bi bi-cart3"></i> Giỏ &amp; hóa đơn
    </a>
    <a href="<%= ctx %>/" data-admin-nav>
        <i class="bi bi-house"></i> Trang chủ
    </a>
    <a href="<%= ctx %>/logout">
        <i class="bi bi-box-arrow-right"></i> Đăng xuất
    </a>
</div>
<button type="button" class="admin-menu-btn" onclick="toggleAdminMenu()" aria-label="Menu">
    <i class="bi bi-list"></i>
</button>
