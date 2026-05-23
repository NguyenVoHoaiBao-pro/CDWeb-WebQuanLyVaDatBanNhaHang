
(function () {
  "use strict";

  window.toggleAdminMenu = function () {
    var sidebar = document.getElementById("adminSidebar");
    var backdrop = document.getElementById("adminSidebarBackdrop");
    if (sidebar) sidebar.classList.toggle("active");
    if (backdrop) backdrop.classList.toggle("active");
  };

  function highlightActiveSidebar() {
    var path = window.location.pathname;
    document.querySelectorAll(".admin-sidebar a[data-admin-nav]").forEach(function (link) {
      var match = link.getAttribute("data-admin-nav");
      if (!match) return;
      var isActive =
        match === "/admin"
          ? /\/admin\/?$/.test(path)
          : path.indexOf(match) !== -1;
      if (isActive) link.classList.add("active");
    });
  }

  document.addEventListener("DOMContentLoaded", highlightActiveSidebar);
})();
