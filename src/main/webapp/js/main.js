
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
    document.querySelectorAll(".nav-link[data-nav]").forEach(function (link) {
      var href = link.getAttribute("href");
      if (href && path.indexOf(href.replace(/^\//, "")) !== -1) {
        link.classList.add("active");
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
