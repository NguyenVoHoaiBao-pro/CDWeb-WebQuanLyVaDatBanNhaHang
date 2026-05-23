<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.RestaurantTable" %>
<%@ page import="vn.edu.hcmuaf.fit.model.User" %>
<%@ page import="vn.edu.hcmuaf.fit.util.AuthUtil" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Chọn bàn — Nhà Hàng Của Chúng Ta");

    List<RestaurantTable> groundTables = (List<RestaurantTable>) request.getAttribute("groundTables");
    List<RestaurantTable> floor1Tables = (List<RestaurantTable>) request.getAttribute("floor1Tables");
    List<RestaurantTable> floor2Tables = (List<RestaurantTable>) request.getAttribute("floor2Tables");

    if (groundTables == null) groundTables = new ArrayList<>();
    if (floor1Tables == null) floor1Tables = new ArrayList<>();
    if (floor2Tables == null) floor2Tables = new ArrayList<>();

    User sessionUser = (User) session.getAttribute("user");
    boolean verified = AuthUtil.isIdentityVerified(sessionUser);
%>

<jsp:include page="../layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>🍽 Chọn bàn nhà hàng</h1>
        <p>Mỗi bàn có lịch riêng theo khung giờ 2 giờ — nhiều khách có thể đặt cùng bàn ở thời điểm khác nhau</p>
    </div>
</section>

<div class="container py-5">
    <% if (sessionUser != null && !verified) { %>
    <div class="alert alert-warning glass-card mb-4">
        <i class="bi bi-shield-exclamation"></i>
        Bạn cần <a href="<%= ctx %>/verify-identity?need=1" class="alert-link">xác thực danh tính</a>
        trước khi đặt bàn và gọi món.
    </div>
    <% } %>

    <div class="table-booking-steps">
        <span class="step active"><i class="bi bi-1-circle-fill"></i> Chọn bàn</span>
        <span class="step"><i class="bi bi-2-circle"></i> Chọn khung giờ</span>
        <span class="step"><i class="bi bi-3-circle"></i> Gọi món</span>
    </div>

    <%-- Tầng trệt --%>
    <div class="floor-section">
        <div class="floor-title">
            <div class="floor-dot ground"></div>
            <h2 class="floor-name">Tầng trệt</h2>
        </div>
        <% if (groundTables.isEmpty()) { %>
        <div class="table-empty-floor glass-card">Chưa có bàn ở tầng này</div>
        <% } else { %>
        <div class="table-grid">
            <% for (RestaurantTable t : groundTables) {
                boolean maintenance = "MAINTENANCE".equals(t.getStatus());
                String bookHref = (sessionUser == null || verified)
                        ? ctx + "/table-booking?tableId=" + t.getId()
                        : ctx + "/verify-identity?need=1";
            %>
            <div class="table-card glass-card">
                <div>
                    <div class="table-card-top">
                        <h3 class="table-card-name"><%= t.getName() %></h3>
                        <span class="status-badge-table available">
                            <%= maintenance ? "Tạm bảo trì" : "Đặt theo lịch" %>
                        </span>
                    </div>
                    <div class="table-card-meta">
                        <i class="bi bi-people"></i>
                        <span><%= t.getCapacity() %> người</span>
                    </div>
                </div>
                <% if (!maintenance) { %>
                <a href="<%= bookHref %>" class="text-decoration-none">
                    <button type="button" class="book-table-btn available">
                        <i class="bi bi-calendar-week"></i> Chọn khung giờ
                    </button>
                </a>
                <% } else { %>
                <button type="button" class="book-table-btn disabled" disabled>Tạm ngưng</button>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <%-- Tầng 1 --%>
    <div class="floor-section">
        <div class="floor-title">
            <div class="floor-dot floor1"></div>
            <h2 class="floor-name">Tầng 1</h2>
        </div>
        <% if (floor1Tables.isEmpty()) { %>
        <div class="table-empty-floor glass-card">Chưa có bàn ở tầng này</div>
        <% } else { %>
        <div class="table-grid">
            <% for (RestaurantTable t : floor1Tables) {
                boolean maintenance = "MAINTENANCE".equals(t.getStatus());
                String bookHref = (sessionUser == null || verified)
                        ? ctx + "/table-booking?tableId=" + t.getId()
                        : ctx + "/verify-identity?need=1";
            %>
            <div class="table-card glass-card">
                <div>
                    <div class="table-card-top">
                        <h3 class="table-card-name"><%= t.getName() %></h3>
                        <span class="status-badge-table available">
                            <%= maintenance ? "Tạm bảo trì" : "Đặt theo lịch" %>
                        </span>
                    </div>
                    <div class="table-card-meta">
                        <i class="bi bi-people"></i>
                        <span><%= t.getCapacity() %> người</span>
                    </div>
                </div>
                <% if (!maintenance) { %>
                <a href="<%= bookHref %>" class="text-decoration-none">
                    <button type="button" class="book-table-btn available">
                        <i class="bi bi-calendar-week"></i> Chọn khung giờ
                    </button>
                </a>
                <% } else { %>
                <button type="button" class="book-table-btn disabled" disabled>Tạm ngưng</button>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <%-- Tầng 2 --%>
    <div class="floor-section">
        <div class="floor-title">
            <div class="floor-dot floor2"></div>
            <h2 class="floor-name">Tầng 2</h2>
        </div>
        <% if (floor2Tables.isEmpty()) { %>
        <div class="table-empty-floor glass-card">Chưa có bàn ở tầng này</div>
        <% } else { %>
        <div class="table-grid">
            <% for (RestaurantTable t : floor2Tables) {
                boolean maintenance = "MAINTENANCE".equals(t.getStatus());
                String bookHref = (sessionUser == null || verified)
                        ? ctx + "/table-booking?tableId=" + t.getId()
                        : ctx + "/verify-identity?need=1";
            %>
            <div class="table-card glass-card">
                <div>
                    <div class="table-card-top">
                        <h3 class="table-card-name"><%= t.getName() %></h3>
                        <span class="status-badge-table available">
                            <%= maintenance ? "Tạm bảo trì" : "Đặt theo lịch" %>
                        </span>
                    </div>
                    <div class="table-card-meta">
                        <i class="bi bi-people"></i>
                        <span><%= t.getCapacity() %> người</span>
                    </div>
                </div>
                <% if (!maintenance) { %>
                <a href="<%= bookHref %>" class="text-decoration-none">
                    <button type="button" class="book-table-btn available">
                        <i class="bi bi-calendar-week"></i> Chọn khung giờ
                    </button>
                </a>
                <% } else { %>
                <button type="button" class="book-table-btn disabled" disabled>Tạm ngưng</button>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
