<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vn.edu.hcmuaf.fit.model.*" %>
<%@ page import="vn.edu.hcmuaf.fit.model.ReservationAnalytics" %>
<%@ page import="vn.edu.hcmuaf.fit.model.TableBookingStat" %>
<%@ page import="java.util.*" %>
<%!
    String fmtMoney(double v) {
        return String.format("%,.0f ₫", v);
    }
%>
<%
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    String chartJson = (String) request.getAttribute("chartJson");
    String ctx = request.getContextPath();

    if (stats == null) {
        stats = new DashboardStats();
    }
    if (chartJson == null) {
        chartJson = "{}";
    }

    double maxTopRev = 1;
    for (TopProductStat t : stats.getTopProducts()) {
        if (t.getRevenue() > maxTopRev) maxTopRev = t.getRevenue();
    }

    int selYear = stats.getYear();
    int selMonth = stats.getMonth();
%>

<div class="dash-header">
    <div>
        <h1><i class="bi bi-graph-up-arrow text-warning"></i> Bảng điều khiển</h1>
        <p class="dash-sub">
            Báo cáo kinh doanh <strong><%= stats.getMonthLabel() %></strong> — dữ liệu từ đơn hàng &amp; đặt bàn thực tế
        </p>
    </div>
    <form class="dash-filter glass-card p-2 px-3" method="get" action="<%= ctx %>/admin">
        <label class="form-label mb-0 small text-muted">Kỳ báo cáo</label>
        <select name="month" class="form-select form-select-sm">
            <% for (int m = 1; m <= 12; m++) { %>
            <option value="<%= m %>" <%= m == selMonth ? "selected" : "" %>>Tháng <%= m %></option>
            <% } %>
        </select>
        <select name="year" class="form-select form-select-sm">
            <% for (int y = selYear - 2; y <= selYear + 1; y++) { %>
            <option value="<%= y %>" <%= y == selYear ? "selected" : "" %>><%= y %></option>
            <% } %>
        </select>
        <button type="submit" class="btn btn-primary-custom btn-sm">
            <i class="bi bi-funnel"></i> Áp dụng
        </button>
    </form>
</div>

<!-- KPI doanh thu & bán hàng -->
<div class="kpi-grid">
    <div class="kpi-card highlight">
        <i class="bi bi-currency-dollar kpi-icon"></i>
        <div class="kpi-label">Tổng doanh thu tháng <%= selMonth %></div>
        <div class="kpi-value accent"><%= fmtMoney(stats.getRevenueMonth()) %></div>
        <div class="kpi-meta">
            <i class="bi bi-receipt"></i> <%= stats.getOrdersMonth() %> đơn hàng
        </div>
    </div>

    <div class="kpi-card">
        <i class="bi bi-calendar-day kpi-icon"></i>
        <div class="kpi-label">Doanh thu hôm nay</div>
        <div class="kpi-value"><%= fmtMoney(stats.getRevenueToday()) %></div>
        <div class="kpi-meta">
            <% if (stats.getGrowthPercent() >= 0) { %>
            <span class="kpi-trend up"><i class="bi bi-arrow-up-short"></i> <%= String.format("%.1f", stats.getGrowthPercent()) %>% so với hôm qua</span>
            <% } else { %>
            <span class="kpi-trend down"><i class="bi bi-arrow-down-short"></i> <%= String.format("%.1f", Math.abs(stats.getGrowthPercent())) %>% so với hôm qua</span>
            <% } %>
        </div>
    </div>

    <div class="kpi-card">
        <i class="bi bi-cart-check kpi-icon"></i>
        <div class="kpi-label">Đơn hàng hôm nay</div>
        <div class="kpi-value"><%= stats.getOrdersToday() %></div>
        <div class="kpi-meta"><i class="bi bi-clock"></i> Trong tháng <%= stats.getMonthLabel() %></div>
    </div>

    <div class="kpi-card">
        <i class="bi bi-pie-chart kpi-icon"></i>
        <div class="kpi-label">Giá trị đơn trung bình</div>
        <div class="kpi-value"><%= fmtMoney(stats.getAvgOrderValue()) %></div>
        <div class="kpi-meta"><i class="bi bi-calculator"></i> AOV = tổng thu / số đơn</div>
    </div>

    <div class="kpi-card">
        <i class="bi bi-wallet2 kpi-icon"></i>
        <div class="kpi-label">Đã thu (PAID)</div>
        <div class="kpi-value" style="color:#4ade80;"><%= fmtMoney(stats.getRevenuePaid()) %></div>
        <div class="kpi-meta">Đặt cọc / thanh toán trước</div>
    </div>

    <div class="kpi-card">
        <i class="bi bi-hourglass-split kpi-icon"></i>
        <div class="kpi-label">Chưa thu (UNPAID)</div>
        <div class="kpi-value" style="color:#fbbf24;"><%= fmtMoney(stats.getRevenueUnpaid()) %></div>
        <div class="kpi-meta">Trả sau khi ăn (COD)</div>
    </div>
</div>

<!-- Biểu đồ -->
<div class="row g-3 mb-3 align-items-stretch">
    <div class="col-lg-8">
        <div class="dash-panel">
            <div class="dash-panel-title">
                <span><i class="bi bi-graph-up me-2"></i>Doanh thu theo ngày — Tháng <%= selMonth %>/<%= selYear %></span>
                <span class="badge bg-dark border border-secondary">Line chart</span>
            </div>
            <% if (stats.getRevenueMonth() <= 0 && stats.getOrdersMonth() == 0) { %>
            <div class="dash-empty-chart">
                <div>
                    <i class="bi bi-bar-chart display-4 d-block mb-2 opacity-50"></i>
                    Chưa có dữ liệu bán hàng trong kỳ này.<br>
                    <small>Đơn hàng sẽ hiển thị sau khi khách checkout.</small>
                </div>
            </div>
            <% } else { %>
            <div class="chart-wrap">
                <canvas id="revenueLineChart"></canvas>
            </div>
            <% } %>
        </div>
    </div>
    <div class="col-lg-4 dash-charts-sidebar">
        <div class="dash-panel">
            <div class="dash-panel-title">
                <span><i class="bi bi-credit-card me-2"></i>Thanh toán</span>
            </div>
            <div class="chart-wrap sm">
                <canvas id="paymentDoughnutChart"></canvas>
            </div>
        </div>
        <div class="dash-panel">
            <div class="dash-panel-title">
                <span><i class="bi bi-calendar-check me-2"></i>Trạng thái đặt bàn</span>
            </div>
            <div class="chart-wrap sm">
                <canvas id="reservationBarChart"></canvas>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3 align-items-stretch">
    <div class="col-lg-5">
        <div class="dash-panel dash-panel--scroll h-100">
            <div class="dash-panel-title">
                <span><i class="bi bi-trophy me-2"></i>Top món bán chạy</span>
                <span class="text-muted small">Tháng <%= selMonth %></span>
            </div>
            <% if (stats.getTopProducts().isEmpty()) { %>
            <div class="dash-empty-chart" style="height:160px;">
                <span class="text-muted">Chưa có dữ liệu món bán</span>
            </div>
            <% } else {
                int rank = 0;
                for (TopProductStat t : stats.getTopProducts()) {
                    rank++;
                    String rankClass = rank == 1 ? "gold" : rank == 2 ? "silver" : rank == 3 ? "bronze" : "";
                    int pct = (int) Math.round((t.getRevenue() / maxTopRev) * 100);
            %>
            <div class="top-product-item">
                <div class="top-rank <%= rankClass %>"><%= rank %></div>
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-start gap-2">
                        <strong><%= t.getName() %></strong>
                        <span class="text-warning fw-bold small"><%= fmtMoney(t.getRevenue()) %></span>
                    </div>
                    <small class="text-muted"><%= t.getQuantity() %> phần đã bán</small>
                    <div class="top-bar">
                        <div class="top-bar-fill" style="width:<%= pct %>%;"></div>
                    </div>
                </div>
            </div>
            <% }} %>
            <% if (!stats.getTopProducts().isEmpty()) { %>
            <div class="chart-wrap sm mt-3">
                <canvas id="topProductsChart"></canvas>
            </div>
            <% } %>
        </div>
    </div>
    <div class="col-lg-7">
        <div class="dash-panel h-100">
            <div class="dash-panel-title">
                <span><i class="bi bi-table me-2"></i>Chi tiết doanh thu từng ngày</span>
            </div>
            <div class="table-responsive" style="max-height:360px;">
                <table class="table table-sm table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th>Ngày</th>
                        <th class="text-end">Số đơn</th>
                        <th class="text-end">Doanh thu</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        double cum = 0;
                        for (DailyRevenue d : stats.getDailyRevenue()) {
                            cum += d.getRevenue();
                    %>
                    <tr class="<%= d.getRevenue() > 0 ? "" : "text-muted opacity-50" %>">
                        <td><strong>Ngày <%= d.getDay() %>/<%= selMonth %></strong></td>
                        <td class="text-end"><%= d.getOrderCount() %></td>
                        <td class="text-end fw-semibold" style="color:var(--orange-light);">
                            <%= fmtMoney(d.getRevenue()) %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                    <tfoot>
                    <tr class="border-top border-secondary">
                        <th>Tổng tháng</th>
                        <th class="text-end"><%= stats.getOrdersMonth() %></th>
                        <th class="text-end text-warning"><%= fmtMoney(stats.getRevenueMonth()) %></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<%
    ReservationAnalytics resAnalytics = stats.getReservationAnalytics();
    if (resAnalytics == null) resAnalytics = new ReservationAnalytics();
%>
<p class="text-muted small text-uppercase fw-semibold mb-2 mt-4" style="letter-spacing:0.08em;">Đặt bàn &amp; vận hành hôm nay</p>
<div class="kpi-grid mb-3">
    <div class="kpi-card">
        <i class="bi bi-calendar-plus kpi-icon"></i>
        <div class="kpi-label">Đặt bàn hôm nay</div>
        <div class="kpi-value"><%= resAnalytics.getReservationsToday() %></div>
    </div>
    <div class="kpi-card">
        <i class="bi bi-lightning kpi-icon"></i>
        <div class="kpi-label">Đang active</div>
        <div class="kpi-value" style="color:#4ade80;"><%= resAnalytics.getActiveReservations() %></div>
    </div>
    <div class="kpi-card">
        <i class="bi bi-x-circle kpi-icon"></i>
        <div class="kpi-label">Hủy hôm nay</div>
        <div class="kpi-value"><%= resAnalytics.getCancelledToday() %></div>
    </div>
    <div class="kpi-card">
        <i class="bi bi-check2-circle kpi-icon"></i>
        <div class="kpi-label">Hoàn thành hôm nay</div>
        <div class="kpi-value"><%= resAnalytics.getCompletedToday() %></div>
    </div>
    <div class="kpi-card highlight">
        <i class="bi bi-percent kpi-icon"></i>
        <div class="kpi-label">Công suất bàn hôm nay</div>
        <div class="kpi-value accent"><%= String.format("%.0f", resAnalytics.getTableUtilizationPercent()) %>%</div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-lg-6">
        <div class="dash-panel h-100">
            <div class="dash-panel-title"><span><i class="bi bi-clock-history me-2"></i>Giờ đặt bàn cao điểm (30 ngày)</span></div>
            <div class="chart-wrap sm"><canvas id="busyHoursChart"></canvas></div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="dash-panel h-100">
            <div class="dash-panel-title"><span><i class="bi bi-grid me-2"></i>Bàn được đặt nhiều nhất</span></div>
            <% if (resAnalytics.getTopTables().isEmpty()) { %>
            <p class="text-muted small p-3 mb-0">Chưa có dữ liệu.</p>
            <% } else { %>
            <ul class="list-group list-group-flush admin-top-tables">
                <% for (TableBookingStat tb : resAnalytics.getTopTables()) { %>
                <li class="list-group-item bg-transparent d-flex justify-content-between text-light border-secondary">
                    <span><%= tb.getTableName() != null ? tb.getTableName() : ("Bàn #" + tb.getTableId()) %></span>
                    <span class="badge bg-warning text-dark"><%= tb.getBookingCount() %> lượt</span>
                </li>
                <% } %>
            </ul>
            <% } %>
        </div>
    </div>
</div>

<!-- Thống kê hệ thống (nhỏ gọn) -->
<p class="text-muted small text-uppercase fw-semibold mb-2 mt-2" style="letter-spacing:0.08em;">Tổng quan hệ thống</p>
<div class="sys-stat-row">
    <div class="sys-stat">
        <div class="num"><%= stats.getTotalUsers() %></div>
        <div class="lbl"><i class="bi bi-people"></i> Người dùng</div>
    </div>
    <div class="sys-stat">
        <div class="num"><%= stats.getTotalProducts() %></div>
        <div class="lbl"><i class="bi bi-basket"></i> Món ăn</div>
    </div>
    <div class="sys-stat">
        <div class="num"><%= stats.getTotalTables() %></div>
        <div class="lbl"><i class="bi bi-grid"></i> Bàn</div>
    </div>
    <div class="sys-stat">
        <div class="num"><%= stats.getTotalReservations() %></div>
        <div class="lbl"><i class="bi bi-calendar"></i> Đặt bàn</div>
    </div>
    <div class="sys-stat">
        <div class="num"><%= stats.getTotalOrders() %></div>
        <div class="lbl"><i class="bi bi-bag"></i> Tổng đơn</div>
    </div>
</div>

<!-- Phím tắt (dưới cùng) -->
<div class="dash-shortcuts">
    <h4><i class="bi bi-lightning-charge text-warning"></i> Phím tắt quản trị</h4>
    <div class="row g-3">
        <div class="col-6 col-md-3">
            <a href="<%= ctx %>/admin/reservations" class="shortcut-card">
                <i class="bi bi-calendar-check"></i>
                <span>Quản lý đặt bàn</span>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="<%= ctx %>/admin/products" class="shortcut-card">
                <i class="bi bi-basket"></i>
                <span>Quản lý món ăn</span>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="<%= ctx %>/admin/users" class="shortcut-card">
                <i class="bi bi-people"></i>
                <span>Người dùng</span>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="<%= ctx %>/admin/tables" class="shortcut-card">
                <i class="bi bi-grid-3x3-gap"></i>
                <span>Quản lý bàn</span>
            </a>
        </div>
    </div>
</div>

<script id="dashboardChartData" type="application/json"><%= chartJson %></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script src="<%= ctx %>/js/admin-dashboard.js"></script>
