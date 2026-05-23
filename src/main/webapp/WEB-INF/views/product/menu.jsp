<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thực đơn — Nhà Hàng Của Chúng Ta");
    List<Product> list = (List<Product>) request.getAttribute("list");
    if (list == null) list = new ArrayList<Product>();

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
    String category = (String) request.getAttribute("category");
    if (category == null) category = "";
%>

<jsp:include page="../layout/header.jsp"/>

<section class="page-hero">
    <div class="container">
        <h1>🍽 Thực đơn nhà hàng</h1>
        <p>Chọn món ngon cho bữa ăn tuyệt vời của bạn</p>
    </div>
</section>

<div class="container py-5">
    <div class="filter-box glass-card mb-5" id="menuFilterBox">
        <form id="menuSearchForm" action="<%= ctx %>/menu" method="get" data-ctx="<%= ctx %>">
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label" for="menuKeyword">Tìm kiếm</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-secondary text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               id="menuKeyword"
                               name="keyword"
                               class="form-control"
                               placeholder="Tìm món ăn..."
                               value="<%= keyword.replace("\"", "&quot;") %>"
                               autocomplete="off">
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="menuCategory">Danh mục</label>
                    <select id="menuCategory" name="category" class="form-select">
                        <option value="" <%= category.isEmpty() ? "selected" : "" %>>Tất cả danh mục</option>
                        <option value="MÓN KHAI VỊ" <%= "MÓN KHAI VỊ".equals(category) ? "selected" : "" %>>Món khai vị</option>
                        <option value="MÓN CHÍNH" <%= "MÓN CHÍNH".equals(category) ? "selected" : "" %>>Món chính</option>
                        <option value="MÓN NƯỚC" <%= "MÓN NƯỚC".equals(category) ? "selected" : "" %>>Món nước</option>
                        <option value="MÓN ĂN NHẸ" <%= "MÓN ĂN NHẸ".equals(category) ? "selected" : "" %>>Món ăn nhẹ</option>
                        <option value="MÓN TRÁNG MIÊNG & ĐỒ UỐNG" <%= "MÓN TRÁNG MIÊNG & ĐỒ UỐNG".equals(category) ? "selected" : "" %>>Tráng miệng</option>
                    </select>
                </div>
                <div class="col-md-3 d-grid gap-2">
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                    <button type="button" id="menuResetBtn" class="btn btn-outline-custom btn-sm">
                        <i class="bi bi-arrow-counterclockwise"></i> Xóa bộ lọc
                    </button>
                </div>
            </div>
        </form>
        <div id="menuLoading" class="menu-loading d-none" aria-live="polite">
            <span class="spinner-border spinner-border-sm text-warning" role="status"></span>
            <span class="ms-2 text-muted">Đang tìm món...</span>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold mb-0">Danh sách món ăn</h2>
            <small class="text-muted" id="menuResultCount"><%= list.size() %> món</small>
        </div>
        <a href="<%= ctx %>/cart" class="btn btn-primary-custom">
            <i class="bi bi-cart3"></i> Giỏ hàng
        </a>
    </div>

    <div class="row g-4" id="menuResults">
        <% if (list.isEmpty()) { %>
        <div class="col-12 text-center py-5 glass-card menu-empty-state">
            <i class="bi bi-emoji-frown display-4 text-muted"></i>
            <h4 class="mt-3">Không có món ăn phù hợp</h4>
        </div>
        <% } else {
            for (Product p : list) { %>
        <div class="col-custom-5 col-md-6 col-sm-12 menu-item-col">
            <div class="food-card glass-card">
                <%
                    String imgUrl = p.getImage();
                    if (imgUrl != null && !imgUrl.startsWith("http")) {
                        imgUrl = ctx + "/" + imgUrl;
                    }
                %>
                <img src="<%= imgUrl %>"
                     alt="<%= p.getName() %>"
                     onerror="this.src='<%= ctx %>/images/default.jpg'">
                <div class="card-body d-flex flex-column">
                    <div class="badge-cat mb-2"><%= p.getCategory() %></div>
                    <h5 class="fw-bold"><%= p.getName() %></h5>
                    <p class="desc"><%= p.getDescription() %></p>
                    <div class="mt-auto">
                        <div class="price mb-3"><%= String.format("%,.0f", p.getPrice()) %> đ</div>
                        <div class="d-grid gap-2">
                            <a href="<%= ctx %>/product/<%= p.getId() %>" class="btn btn-dark btn-sm">Xem chi tiết</a>
                            <a href="<%= ctx %>/cart/add/<%= p.getId() %>" class="btn btn-primary-custom btn-sm">
                                <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% }} %>
    </div>
</div>

<script src="<%= ctx %>/js/menu-search.js"></script>
<script>
  window.menuReveal = function () {
    if (!("IntersectionObserver" in window)) return;
    document.querySelectorAll("#menuResults .food-card").forEach(function (el) {
      el.style.opacity = "0";
      el.style.transform = "translateY(30px)";
      el.style.transition = "opacity 0.5s ease, transform 0.5s ease";
      var obs = new IntersectionObserver(function (entries, o) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.style.opacity = "1";
            entry.target.style.transform = "translateY(0)";
            o.unobserve(entry.target);
          }
        });
      }, { threshold: 0.1 });
      obs.observe(el);
    });
  };
  document.addEventListener("DOMContentLoaded", window.menuReveal);
</script>

<jsp:include page="../layout/footer.jsp"/>
