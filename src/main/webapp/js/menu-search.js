
(function () {
  "use strict";

  var DEBOUNCE_MS = 400;

  function escapeHtml(str) {
    if (str == null) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function formatPrice(price) {
    return Number(price).toLocaleString("vi-VN") + " đ";
  }

  function resolveImage(ctx, image) {
    if (!image) return ctx + "/images/default.jpg";
    if (image.indexOf("http") === 0) return image;
    if (image.indexOf("/") === 0) return ctx + image;
    return ctx + "/" + image;
  }

  function buildCard(ctx, p) {
    var img = resolveImage(ctx, p.image);
    var name = escapeHtml(p.name);
    var cat = escapeHtml(p.category);
    var desc = escapeHtml(p.description);
    var price = formatPrice(p.price);

    return (
      '<div class="col-custom-5 col-md-6 col-sm-12 menu-item-col">' +
      '  <div class="food-card glass-card">' +
      '    <img src="' + escapeHtml(img) + '" alt="' + name + '" onerror="this.src=\'' + ctx + "/images/default.jpg'\">" +
      '    <div class="card-body d-flex flex-column">' +
      '      <div class="badge-cat mb-2">' + cat + "</div>" +
      "      <h5 class=\"fw-bold\">" + name + "</h5>" +
      '      <p class="desc">' + desc + "</p>" +
      '      <div class="mt-auto">' +
      '        <div class="price mb-3">' + price + "</div>" +
      '        <div class="d-grid gap-2">' +
      '          <a href="' + ctx + "/product/" + p.id + '" class="btn btn-dark btn-sm">Xem chi tiết</a>' +
      '          <button type="button" class="btn btn-primary-custom btn-sm" data-add-cart="' + p.id + '">' +
      '            <i class="bi bi-cart-plus"></i> Thêm vào giỏ</button>' +
      "        </div>" +
      "      </div>" +
      "    </div>" +
      "  </div>" +
      "</div>"
    );
  }

  function renderEmpty() {
    return (
      '<div class="col-12 text-center py-5 glass-card menu-empty-state">' +
      '  <i class="bi bi-emoji-frown display-4 text-muted"></i>' +
      '  <h4 class="mt-3">Không có món ăn phù hợp</h4>' +
      "</div>"
    );
  }

  function renderProducts(ctx, products) {
    if (!products || products.length === 0) {
      return renderEmpty();
    }
    return products.map(function (p) {
      return buildCard(ctx, p);
    }).join("");
  }

  function init() {
    var form = document.getElementById("menuSearchForm");
    var grid = document.getElementById("menuResults");
    var keywordInput = document.getElementById("menuKeyword");
    var categorySelect = document.getElementById("menuCategory");
    var loadingEl = document.getElementById("menuLoading");
    var countEl = document.getElementById("menuResultCount");

    if (!form || !grid) return;

    var ctx = form.getAttribute("data-ctx") || "";
    var apiUrl = ctx + "/api/menu";
    var debounceTimer = null;
    var activeController = null;

    function setLoading(show) {
      if (loadingEl) loadingEl.classList.toggle("d-none", !show);
      if (form) form.classList.toggle("is-loading", show);
    }

    function updateCount(n) {
      if (!countEl) return;
      countEl.textContent = n + " món";
    }

    function fetchMenu() {
      var keyword = keywordInput ? keywordInput.value.trim() : "";
      var category = categorySelect ? categorySelect.value : "";

      var params = new URLSearchParams();
      if (keyword) params.set("keyword", keyword);
      if (category) params.set("category", category);

      var url = apiUrl + (params.toString() ? "?" + params.toString() : "");

      if (activeController) activeController.abort();
      activeController = new AbortController();

      setLoading(true);

      fetch(url, { signal: activeController.signal, headers: { Accept: "application/json" } })
        .then(function (res) {
          if (!res.ok) throw new Error("HTTP " + res.status);
          return res.json();
        })
        .then(function (data) {
          grid.innerHTML = renderProducts(ctx, data);
          updateCount(data.length);

          if (window.menuReveal) window.menuReveal();
        })
        .catch(function (err) {
          if (err.name === "AbortError") return;
          grid.innerHTML =
            '<div class="col-12"><div class="alert alert-danger glass-card text-center">' +
            '<i class="bi bi-wifi-off"></i> Không tải được dữ liệu. Vui lòng thử lại.</div></div>';
        })
        .finally(function () {
          setLoading(false);
          activeController = null;
        });
    }

    function scheduleSearch() {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(fetchMenu, DEBOUNCE_MS);
    }

    form.addEventListener("submit", function (e) {
      e.preventDefault();
      clearTimeout(debounceTimer);
      fetchMenu();
    });

    if (keywordInput) {
      keywordInput.addEventListener("input", scheduleSearch);
    }

    if (categorySelect) {
      categorySelect.addEventListener("change", function () {
        clearTimeout(debounceTimer);
        fetchMenu();
      });
    }

    var resetBtn = document.getElementById("menuResetBtn");
    if (resetBtn) {
      resetBtn.addEventListener("click", function () {
        if (keywordInput) keywordInput.value = "";
        if (categorySelect) categorySelect.value = "";
        fetchMenu();
      });
    }
  }

  document.addEventListener("DOMContentLoaded", init);
})();
