/**
 * Admin dashboard charts (Chart.js)
 */
(function () {
  "use strict";

  function formatVnd(n) {
    return Number(n || 0).toLocaleString("vi-VN") + " ₫";
  }

  function initCharts() {
    var el = document.getElementById("dashboardChartData");
    if (!el || typeof Chart === "undefined") return;

    var data;
    try {
      data = JSON.parse(el.textContent);
    } catch (e) {
      console.error("Chart data parse error", e);
      return;
    }

    Chart.defaults.color = "#94a3b8";
    Chart.defaults.borderColor = "rgba(255,255,255,0.08)";
    Chart.defaults.font.family = "'Segoe UI', system-ui, sans-serif";

    var revenueCtx = document.getElementById("revenueLineChart");
    if (revenueCtx) {
      new Chart(revenueCtx, {
        type: "line",
        data: {
          labels: data.dayLabels.map(function (d) {
            return "Ngày " + d;
          }),
          datasets: [
            {
              label: "Doanh thu (₫)",
              data: data.revenues,
              borderColor: "#ff6b35",
              backgroundColor: "rgba(255, 107, 53, 0.12)",
              fill: true,
              tension: 0.4,
              pointRadius: 3,
              pointHoverRadius: 6,
              pointBackgroundColor: "#ff8c5a",
              yAxisID: "y",
            },
            {
              label: "Số đơn",
              data: data.orders,
              borderColor: "#60a5fa",
              backgroundColor: "transparent",
              borderDash: [4, 4],
              tension: 0.35,
              pointRadius: 2,
              yAxisID: "y1",
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          interaction: { mode: "index", intersect: false },
          plugins: {
            legend: { position: "top" },
            tooltip: {
              callbacks: {
                label: function (ctx) {
                  if (ctx.datasetIndex === 0) {
                    return "Doanh thu: " + formatVnd(ctx.raw);
                  }
                  return "Đơn hàng: " + ctx.raw;
                },
              },
            },
          },
          scales: {
            y: {
              position: "left",
              ticks: {
                callback: function (v) {
                  return (v / 1000).toFixed(0) + "k";
                },
              },
              grid: { color: "rgba(255,255,255,0.05)" },
            },
            y1: {
              position: "right",
              grid: { drawOnChartArea: false },
              ticks: { stepSize: 1 },
            },
            x: { grid: { display: false } },
          },
        },
      });
    }

    var payCtx = document.getElementById("paymentDoughnutChart");
    if (payCtx) {
      new Chart(payCtx, {
        type: "doughnut",
        data: {
          labels: ["Đã thanh toán", "Chưa thanh toán"],
          datasets: [
            {
              data: [data.paid, data.unpaid],
              backgroundColor: ["#22c55e", "#f59e0b"],
              borderWidth: 0,
              hoverOffset: 8,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          cutout: "68%",
          plugins: {
            legend: { position: "bottom" },
            tooltip: {
              callbacks: {
                label: function (ctx) {
                  return ctx.label + ": " + formatVnd(ctx.raw);
                },
              },
            },
          },
        },
      });
    }

    var resCtx = document.getElementById("reservationBarChart");
    if (resCtx) {
      new Chart(resCtx, {
        type: "bar",
        data: {
          labels: ["Chờ", "Xác nhận", "Hoàn thành", "Đã hủy"],
          datasets: [
            {
              label: "Đặt bàn",
              data: [
                data.resPending,
                data.resConfirmed,
                data.resDone,
                data.resCancelled,
              ],
              backgroundColor: [
                "rgba(245, 158, 11, 0.85)",
                "rgba(34, 197, 94, 0.85)",
                "rgba(59, 130, 246, 0.85)",
                "rgba(239, 68, 68, 0.75)",
              ],
              borderRadius: 8,
              borderSkipped: false,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: {
              beginAtZero: true,
              ticks: { stepSize: 1 },
              grid: { color: "rgba(255,255,255,0.05)" },
            },
            x: { grid: { display: false } },
          },
        },
      });
    }

    var busyCtx = document.getElementById("busyHoursChart");
    if (busyCtx && data.busyHourLabels && data.busyHourLabels.length > 0) {
      new Chart(busyCtx, {
        type: "bar",
        data: {
          labels: data.busyHourLabels,
          datasets: [
            {
              label: "Lượt đặt",
              data: data.busyHourCounts,
              backgroundColor: "rgba(255, 107, 53, 0.8)",
              borderRadius: 6,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: { beginAtZero: true, ticks: { stepSize: 1 } },
            x: { grid: { display: false } },
          },
        },
      });
    }

    var topCtx = document.getElementById("topProductsChart");
    if (topCtx && data.topNames && data.topNames.length > 0) {
      new Chart(topCtx, {
        type: "bar",
        data: {
          labels: data.topNames,
          datasets: [
            {
              label: "Doanh thu",
              data: data.topRevenues,
              backgroundColor: "rgba(255, 107, 53, 0.75)",
              borderRadius: 6,
            },
          ],
        },
        options: {
          indexAxis: "y",
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              callbacks: {
                label: function (ctx) {
                  return formatVnd(ctx.raw);
                },
              },
            },
          },
          scales: {
            x: {
              ticks: {
                callback: function (v) {
                  return (v / 1000).toFixed(0) + "k";
                },
              },
              grid: { color: "rgba(255,255,255,0.05)" },
            },
            y: { grid: { display: false } },
          },
        },
      });
    }
  }

  document.addEventListener("DOMContentLoaded", initCharts);
})();
