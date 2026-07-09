<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,vn.edu.hcmuaf.fit.model.Product" %>

<%
    String ctx = request.getContextPath();
    request.setAttribute("pageTitle", "Thực đơn Khách vãng lai — Nhà Hàng Của Chúng Ta");
    List<Product> list = (List<Product>) request.getAttribute("list");
    if (list == null) list = new ArrayList<Product>();

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
    String category = (String) request.getAttribute("category");
    if (category == null) category = "";
%>

<jsp:include page="../layout/header.jsp"/>

<section class="page-hero" style="background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url('<%= ctx %>/images/hero-bg.jpg'); background-size: cover; padding: 60px 0;">
    <div class="container text-center">
        <h1 class="display-4 fw-bold text-white">🍽 Thực đơn tại bàn</h1>
        <p class="lead text-light">Chào mừng quý khách! Vui lòng chọn món và thêm vào giỏ hàng.</p>
    </div>
</section>

<div class="container py-5">
    <div class="filter-box glass-card mb-5" id="menuFilterBox">
        <form id="menuSearchForm" action="<%= ctx %>/menu-guest" method="get" data-ctx="<%= ctx %>">
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label" for="menuKeyword">Tìm kiếm món ăn</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-secondary text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               id="menuKeyword"
                               name="keyword"
                               class="form-control"
                               placeholder="Tên món ăn..."
                               value="<%= keyword.replace("\"", "&quot;") %>"
                               autocomplete="off">
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label" for="menuCategory">Danh mục</label>
                    <div class="custom-dropdown" style="position: relative; z-index: 10000;">
                        <input type="hidden" id="menuCategory" name="category" value="<%= category %>">
                        <button type="button" class="custom-dropdown-btn w-100 text-start p-2 rounded" style="background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: #f1f5f9;">
                            <span id="menuCategoryDisplay"><%= category.isEmpty() ? "Tất cả danh mục" : category %></span>
                            <i class="bi bi-chevron-down float-end"></i>
                        </button>
                        <div class="custom-dropdown-menu d-none" style="position: absolute; top: 100%; left: 0; right: 0; background: #1a1a26; border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; margin-top: 4px; z-index: 10001; box-shadow: 0 8px 32px rgba(0,0,0,0.4); max-height: 300px; overflow-y: auto;">
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="">Tất cả danh mục</div>
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="MÓN KHAI VỊ">Món khai vị</div>
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="MÓN CHÍNH">Món chính</div>
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="MÓN NƯỚC">Món nước</div>
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="MÓN ĂN NHẸ">Món ăn nhẹ</div>
                            <div class="dropdown-option p-2" style="cursor: pointer; color: #f1f5f9; padding: 0.6rem 1rem;" data-value="MÓN TRÁNG MIÊNG & ĐỒ UỐNG">Tráng miệng</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 d-grid gap-2">
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold mb-0 text-white">Danh sách món ăn</h2>
            <small class="text-muted" id="menuResultCount"><%= list.size() %> món có sẵn</small>
        </div>
        <a href="<%= ctx %>/cart" class="btn btn-warning position-relative px-4" data-cart-target>
            <i class="bi bi-cart3"></i> Xem giỏ hàng
            <span class="cart-nav-badge d-none" data-cart-count>0</span>
        </a>
    </div>

    <div class="row g-4" id="menuResults">
        <% if (list.isEmpty()) { %>
        <div class="col-12 text-center py-5 glass-card">
            <i class="bi bi-emoji-frown display-4 text-muted"></i>
            <h4 class="mt-3 text-white">Không tìm thấy món ăn nào</h4>
        </div>
        <% } else {
            for (Product p : list) { %>
        <div class="col-lg-3 col-md-4 col-sm-6 menu-item-col">
            <div class="food-card glass-card h-100 d-flex flex-column">
                <%
                    String imgUrl = p.getImage();
                    if (imgUrl != null && !imgUrl.startsWith("http")) {
                        imgUrl = ctx + "/" + imgUrl;
                    }
                %>
                <div class="card-img-container" style="height: 180px; overflow: hidden; border-radius: 12px 12px 0 0;">
                    <img src="<%= imgUrl %>"
                         class="w-100 h-100 object-fit-cover"
                         alt="<%= p.getName() %>"
                         onerror="this.src='<%= ctx %>/images/default.jpg'">
                </div>
                <div class="card-body d-flex flex-column p-3">
                    <div class="badge-cat mb-2 text-primary small fw-bold"><%= p.getCategory() %></div>
                    <h5 class="fw-bold text-white mb-2"><%= p.getName() %></h5>
                    <p class="desc text-muted small mb-3" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;"><%= p.getDescription() %></p>
                    <div class="mt-auto">
                        <div class="price mb-3 fs-5 fw-bold text-warning"><%= String.format("%,.0f", p.getPrice()) %> đ</div>
                        <div class="d-grid gap-2">
                            <button type="button"
                                    class="btn btn-primary-custom btn-sm"
                                    data-add-cart="<%= p.getId() %>">
                                <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                            </button>
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
  // Custom dropdown handler
  document.addEventListener("DOMContentLoaded", function() {
    var dropdownBtn = document.querySelector(".custom-dropdown-btn");
    var dropdownMenu = document.querySelector(".custom-dropdown-menu");
    var dropdownOptions = document.querySelectorAll(".dropdown-option");
    var categoryInput = document.getElementById("menuCategory");
    var categoryDisplay = document.getElementById("menuCategoryDisplay");

    if (!dropdownBtn || !dropdownMenu) return;

    dropdownBtn.addEventListener("click", function(e) {
      e.stopPropagation();
      dropdownMenu.classList.toggle("d-none");
    });

    document.addEventListener("click", function(e) {
      if (!dropdownBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
        dropdownMenu.classList.add("d-none");
      }
    });

    dropdownOptions.forEach(function(option) {
      option.addEventListener("click", function(e) {
        e.stopPropagation();
        var value = this.getAttribute("data-value");
        var text = this.textContent;

        categoryInput.value = value;
        categoryDisplay.textContent = text;
        dropdownMenu.classList.add("d-none");

        var form = document.getElementById("menuSearchForm");
        if (form) {
          form.submit();
        }
      });
    });
  });
</script>

<jsp:include page="../layout/footer.jsp"/>
