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
        <a href="<%= ctx %>/cart" class="btn btn-primary-custom position-relative" data-cart-target>
            <i class="bi bi-cart3"></i> Giỏ hàng
            <span class="cart-nav-badge d-none" data-cart-count>0</span>
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

    // Toggle dropdown
    dropdownBtn.addEventListener("click", function(e) {
      e.stopPropagation();
      dropdownMenu.classList.toggle("d-none");
    });

    // Close dropdown when clicking outside
    document.addEventListener("click", function(e) {
      if (!dropdownBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
        dropdownMenu.classList.add("d-none");
      }
    });

    // Handle option selection
    dropdownOptions.forEach(function(option) {
      option.addEventListener("click", function(e) {
        e.stopPropagation();
        var value = this.getAttribute("data-value");
        var text = this.textContent;

        categoryInput.value = value;
        categoryDisplay.textContent = text;
        dropdownMenu.classList.add("d-none");

        // Trigger form submission
        var form = document.getElementById("menuSearchForm");
        if (form) {
          form.dispatchEvent(new Event("submit"));
        }
      });

      // Hover effect
      option.addEventListener("mouseenter", function() {
        this.style.background = "rgba(255, 107, 53, 0.2)";
        this.style.color = "#ff8c5a";
      });
      option.addEventListener("mouseleave", function() {
        this.style.background = "transparent";
        this.style.color = "#f1f5f9";
      });
    });

    // Set initial state
    var initialValue = categoryInput.value;
    if (initialValue) {
      dropdownOptions.forEach(function(option) {
        if (option.getAttribute("data-value") === initialValue) {
          categoryDisplay.textContent = option.textContent;
        }
      });
    }
  });

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
