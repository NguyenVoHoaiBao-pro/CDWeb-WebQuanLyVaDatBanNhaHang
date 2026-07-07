
(function () {
  "use strict";

  function initNavbarScroll() {
    var nav = document.querySelector(".luxury-nav");
    if (!nav) return;
    window.addEventListener("scroll", function () {
      if (window.scrollY > 50) {
        nav.classList.add("scrolled");
      } else {
        nav.classList.remove("scrolled");
      }
    });
  }

  function initCounters() {
    document.querySelectorAll(".counter").forEach(function (counter) {
      var target = +counter.dataset.target;
      var current = 0;
      var step = Math.max(1, Math.ceil(target / 80));

      function update() {
        current += step;
        if (current < target) {
          counter.innerText = current;
          setTimeout(update, 20);
        } else {
          counter.innerText = target;
        }
      }
      update();
    });
  }

  function initBackToTop() {
    var topBtn = document.getElementById("toTop");
    if (!topBtn) return;

    window.addEventListener("scroll", function () {
      topBtn.style.display = window.scrollY > 400 ? "block" : "none";
    });

    topBtn.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

  function initReveal() {
    if (!("IntersectionObserver" in window)) return;

    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.style.opacity = "1";
            entry.target.style.transform = "translateY(0)";
          }
        });
      },
      { threshold: 0.1 }
    );

    document
      .querySelectorAll(".product-card, .food-card, .feature, .review, .glass-card")
      .forEach(function (el) {
        el.style.opacity = "0";
        el.style.transform = "translateY(40px)";
        el.style.transition = "opacity 0.7s ease, transform 0.7s ease";
        observer.observe(el);
      });
  }

  function initActiveNav() {
    var path = window.location.pathname;
    if (path.length > 1 && path.endsWith("/")) {
      path = path.slice(0, -1);
    }

    document.querySelectorAll(".nav-link[data-nav]").forEach(function (link) {
      var href = link.pathname;
      if (href.length > 1 && href.endsWith("/")) {
        href = href.slice(0, -1);
      }

      var originalHref = link.getAttribute("href");
      var isHome = originalHref.endsWith("/");
      var isActive = false;

      if (isHome) {
        isActive = path === href;
      } else {
        isActive = path === href || path.startsWith(href + "/");
      }

      if (isActive) {
        link.classList.add("active");
      } else {
        link.classList.remove("active");
      }
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initNavbarScroll();
    initCounters();
    initBackToTop();
    initReveal();
    initActiveNav();
  });
})();
