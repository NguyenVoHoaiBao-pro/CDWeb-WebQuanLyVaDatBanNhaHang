(function () {
  "use strict";

  function ctxPath() {
    var meta = document.querySelector("meta[name='app-context']");
    if (meta) return meta.getAttribute("content") || "";
    var link = document.querySelector("link[href*='/css/style.css']");
    if (link) {
      var href = link.getAttribute("href");
      var idx = href.indexOf("/css/");
      if (idx > 0) return href.substring(0, idx);
    }
    return "";
  }

  function updateBadges(count) {
    document.querySelectorAll("[data-cart-count]").forEach(function (el) {
      el.textContent = count > 99 ? "99+" : String(count);
      el.classList.toggle("d-none", count <= 0);
    });
  }

  function refreshSummary() {
    var ctx = ctxPath();
    return fetch(ctx + "/cart/api/summary", {
      credentials: "same-origin",
      headers: { Accept: "application/json" },
    })
      .then(function (r) {
        return r.json();
      })
      .then(function (data) {
        if (data && data.success) {
          updateBadges(data.count || 0);
        }
        return data;
      })
      .catch(function () {
        return null;
      });
  }

  function flyToCart(sourceEl) {
    var cartTarget =
      document.getElementById("floatingCartBtn") ||
      document.querySelector("[data-cart-target]");

    if (!sourceEl || !cartTarget) return;

    var rect = sourceEl.getBoundingClientRect();
    var cartRect = cartTarget.getBoundingClientRect();

    var fly = document.createElement("div");
    fly.className = "cart-fly-item";
    fly.innerHTML = '<i class="bi bi-bag-fill"></i>';
    fly.style.left = rect.left + rect.width / 2 + "px";
    fly.style.top = rect.top + rect.height / 2 + "px";
    document.body.appendChild(fly);

    requestAnimationFrame(function () {
      fly.style.left = cartRect.left + cartRect.width / 2 + "px";
      fly.style.top = cartRect.top + cartRect.height / 2 + "px";
      fly.style.transform = "scale(0.3)";
      fly.style.opacity = "0.2";
    });

    setTimeout(function () {
      fly.remove();
      cartTarget.classList.add("cart-bump");
      setTimeout(function () {
        cartTarget.classList.remove("cart-bump");
      }, 400);
    }, 650);
  }

  function addToCart(productId, sourceEl) {
    var ctx = ctxPath();

    return fetch(ctx + "/cart/api/add/" + productId, {
      credentials: "same-origin",
      headers: { Accept: "application/json" },
    })
      .then(function (r) {
        return r.json();
      })
      .then(function (data) {
        if (!data) return;

        if (data.message === "not_logged_in") {
          window.location.href = ctx + "/login";
          return;
        }

        if (data.message === "no_reservation" || data.message === "reservation_expired") {
          window.location.href = ctx + "/tables";
          return;
        }

        if (data.success) {
          flyToCart(sourceEl);
          updateBadges(data.count || 0);
          showToast("Đã thêm vào giỏ hàng");
        }
      });
  }

  function showToast(msg) {
    var toast = document.getElementById("cartToast");
    if (!toast) {
      toast = document.createElement("div");
      toast.id = "cartToast";
      toast.className = "cart-toast";
      document.body.appendChild(toast);
    }
    toast.textContent = msg;
    toast.classList.add("show");
    clearTimeout(showToast._t);
    showToast._t = setTimeout(function () {
      toast.classList.remove("show");
    }, 2200);
  }

  function bindAddButtons() {
    document.addEventListener("click", function (e) {
      var btn = e.target.closest("[data-add-cart]");
      if (!btn) return;

      e.preventDefault();
      var id = btn.getAttribute("data-add-cart");
      if (!id) return;

      btn.disabled = true;
      addToCart(id, btn).finally(function () {
        btn.disabled = false;
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    bindAddButtons();
    refreshSummary();
  });

  window.restaurantCart = {
    refresh: refreshSummary,
    add: addToCart,
  };
})();
