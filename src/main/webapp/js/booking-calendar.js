(function () {
  "use strict";

  var Rules = window.ReservationRules;
  if (!Rules) return;

  var DAYS_AHEAD = Rules.MAX_DAYS_AHEAD;

  function dayLabel(date, today) {
    var names = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];
    var same =
      date.getDate() === today.getDate() &&
      date.getMonth() === today.getMonth() &&
      date.getFullYear() === today.getFullYear();
    return (
      (same ? "Hôm nay — " : names[date.getDay()] + " — ") +
      Rules.pad(date.getDate()) +
      "/" +
      Rules.pad(date.getMonth() + 1)
    );
  }

  function slotTitle(state) {
    switch (state) {
      case "booked":
        return "Khung giờ này đã có khách đặt";
      case "cleaning":
        return "Khung dọn bàn — sau đơn trước (không đặt được)";
      case "delay-preview":
        return "Khung dọn bàn sau lượt bạn chọn (tự động)";
      case "past":
        return "Đã qua";
      default:
        return "Khung trống — nhấn chọn (tối đa 3 khung giờ liên tiếp)";
    }
  }

  function buildCalendar(root, blocks, previewDelayStart) {
    var now = new Date();
    var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    var slotHours = Rules.slotStarts();
    var html = "";

    html += '<div class="booking-calendar-grid booking-calendar-grid--blocks">';
    html += '<div class="booking-cal-head booking-cal-corner">Ngày / Khung giờ</div>';
    slotHours.forEach(function (h) {
      html += '<div class="booking-cal-head small">' + Rules.slotLabel(h) + "</div>";
    });

    for (var d = 0; d < DAYS_AHEAD; d++) {
      var day = new Date(today);
      day.setDate(day.getDate() + d);

      html += '<div class="booking-cal-day">' + dayLabel(day, today) + "</div>";

      slotHours.forEach(function (hour) {
        var slotStart = new Date(day.getFullYear(), day.getMonth(), day.getDate(), hour, 0, 0);
        var iso = Rules.toIsoLocal(slotStart);
        var state = Rules.getSlotState(iso, blocks, now);
        var cls = "booking-slot is-" + state;

        if (previewDelayStart && state === "available") {
          var ps = Rules.parseDateTime(previewDelayStart);
          var pe = ps ? Rules.slotEndTime(ps) : null;
          if (ps && pe && slotStart.getTime() === pe.getTime()) {
            state = "delay-preview";
            cls = "booking-slot is-delay-preview";
          }
        }

        var disabled = state !== "available";
        var label =
          state === "booked"
            ? '<i class="bi bi-lock-fill"></i>'
            : state === "cleaning" || state === "delay-preview"
            ? '<i class="bi bi-brush"></i>'
            : '<span class="slot-label">' + Rules.slotLabel(hour) + "</span>";

        html +=
          '<button type="button" class="' +
          cls +
          '" data-slot="' +
          iso +
          '" data-state="' +
          state +
          '" title="' +
          slotTitle(state) +
          '"' +
          (disabled ? " disabled" : "") +
          ">" +
          label +
          "</button>";
      });
    }

    html += "</div>";
    root.innerHTML = html;
  }

  function formatDateVi(d) {
    return (
      Rules.pad(d.getDate()) +
      "/" +
      Rules.pad(d.getMonth() + 1) +
      "/" +
      d.getFullYear() +
      " " +
      Rules.pad(d.getHours()) +
      ":" +
      Rules.pad(d.getMinutes())
    );
  }

  function formatSelection(startIso, endIso, slotCount) {
    var s = Rules.parseDateTime(startIso);
    var e = Rules.parseDateTime(endIso);
    if (!s || !e) return "";
    return (
      formatDateVi(s) +
      " → " +
      formatDateVi(e) +
      " (" +
      slotCount +
      " khung giờ)"
    );
  }

  function init() {
    var root = document.getElementById("bookingCalendar");
    if (!root) return;

    var blocks = [];
    try {
      blocks = JSON.parse(root.getAttribute("data-schedule") || "[]");
    } catch (e) {
      blocks = [];
    }

    var hiddenStart = document.getElementById("reservationTime");
    var hiddenEnd = document.getElementById("reservationEndTime");
    var display = document.getElementById("selectedSlotDisplay");
    var hint = document.getElementById("selectionHint");
    var submitBtn = document.getElementById("btnConfirmBooking");
    var ctx = root.getAttribute("data-ctx") || "";
    var tableId = root.getAttribute("data-table-id");
    var peopleInput = document.querySelector("#bookingForm [name='numberOfPeople']");

    if (Rules.fetchRemoteConfig) Rules.fetchRemoteConfig(ctx);

    var selectionStart = null;
    var previewDelayStart = null;

    function clearSelection() {
      selectionStart = null;
      previewDelayStart = null;
      root.querySelectorAll(".booking-slot").forEach(function (el) {
        el.classList.remove("is-selected", "is-range");
      });
      if (hiddenStart) hiddenStart.value = "";
      if (hiddenEnd) hiddenEnd.value = "";
      if (display) display.value = "";
      if (submitBtn) submitBtn.disabled = true;
      if (hint) {
        hint.textContent =
          "Mỗi ô = 1 khung giờ (2h). Nhấn khung đầu, rồi khung cuối (tối đa 3 khung). Khung dọn bàn tự thêm sau đó.";
      }
      buildCalendar(root, blocks, null);
    }

    function paintSelection(startIso, endIso) {
      var start = Rules.parseDateTime(startIso);
      var end = Rules.parseDateTime(endIso);
      if (!start || !end) return;

      previewDelayStart = Rules.toIsoLocal(end);

      root.querySelectorAll(".booking-slot").forEach(function (btn) {
        btn.classList.remove("is-selected", "is-range");
      });

      var h = start.getHours();
      while (h < end.getHours()) {
        var iso = Rules.toIsoLocal(
          new Date(start.getFullYear(), start.getMonth(), start.getDate(), h, 0, 0)
        );
        root.querySelectorAll('.booking-slot[data-slot="' + iso + '"]').forEach(function (btn) {
          if (btn.getAttribute("data-state") === "available") {
            btn.classList.add("is-range");
          }
        });
        if (h === start.getHours()) {
          root.querySelectorAll('.booking-slot[data-slot="' + iso + '"]').forEach(function (btn) {
            btn.classList.add("is-selected");
          });
        }
        h += Rules.SLOT_HOURS;
      }

      buildCalendar(root, blocks, previewDelayStart);
    }

    function applySelection(startIso, endIso) {
      var slotCount = Rules.countSlots(
        Rules.parseDateTime(startIso),
        Rules.parseDateTime(endIso)
      );
      var err = Rules.validateRange(startIso, endIso, new Date());
      if (err) {
        if (hint) hint.textContent = err;
        return;
      }
      if (Rules.rangeOverlapsBlocks(startIso, endIso, blocks)) {
        if (hint) hint.textContent = "Trùng lịch hoặc khung dọn bàn — chọn dãy khung giờ khác.";
        return;
      }

      if (hiddenStart) hiddenStart.value = startIso;
      if (hiddenEnd) hiddenEnd.value = endIso;
      if (display) display.value = formatSelection(startIso, endIso, slotCount);
      if (submitBtn) submitBtn.disabled = false;
      if (hint) {
        hint.textContent =
          "Đã chọn " +
          slotCount +
          " khung giờ. Khung thứ " +
          (slotCount + 1) +
          " (2h) dùng để dọn bàn — không cần chọn.";
      }
      paintSelection(startIso, endIso);

      if (tableId && ctx) {
        var people = peopleInput ? peopleInput.value : "1";
        fetch(
          ctx +
            "/api/validate-booking?tableId=" +
            tableId +
            "&reservationTime=" +
            encodeURIComponent(startIso) +
            "&reservationEndTime=" +
            encodeURIComponent(endIso) +
            "&numberOfPeople=" +
            encodeURIComponent(people)
        )
          .then(function (r) {
            return r.json();
          })
          .then(function (data) {
            if (data && data.valid === false) {
              if (hint) hint.textContent = data.message || "Không hợp lệ";
              if (submitBtn) submitBtn.disabled = true;
            }
          })
          .catch(function () {});
      }
    }

    root.addEventListener("click", function (e) {
      var btn = e.target.closest(".booking-slot.is-available");
      if (!btn) return;

      var slot = btn.getAttribute("data-slot");
      var slotDate = Rules.parseDateTime(slot);
      if (!slotDate) return;

      if (!selectionStart) {
        selectionStart = slot;
        var endOne = Rules.toIsoLocal(Rules.slotEndTime(slotDate));
        paintSelection(slot, endOne);
        if (hint) {
          hint.textContent =
            "Chọn khung kết thúc (cùng ngày, liên tiếp, tối đa " +
            Rules.MAX_BOOKING_SLOTS +
            " khung). Nhấn lại khung đầu = chỉ 1 khung.";
        }
        return;
      }

      var startDate = Rules.parseDateTime(selectionStart);
      if (!startDate) return;

      if (slot === selectionStart) {
        applySelection(selectionStart, Rules.toIsoLocal(Rules.slotEndTime(slotDate)));
        selectionStart = null;
        return;
      }

      if (
        slotDate.getFullYear() !== startDate.getFullYear() ||
        slotDate.getMonth() !== startDate.getMonth() ||
        slotDate.getDate() !== startDate.getDate() ||
        slotDate < startDate
      ) {
        selectionStart = slot;
        paintSelection(slot, Rules.toIsoLocal(Rules.slotEndTime(slotDate)));
        if (hint) hint.textContent = "Chọn khung giờ kết thúc.";
        return;
      }

      var diffHours = (slotDate - startDate) / (3600 * 1000);
      if (diffHours % Rules.SLOT_HOURS !== 0) {
        if (hint) hint.textContent = "Phải chọn các khung giờ liên tiếp (mỗi khung 2 giờ).";
        return;
      }

      var slotCount = diffHours / Rules.SLOT_HOURS + 1;
      if (slotCount > Rules.MAX_BOOKING_SLOTS) {
        if (hint) {
          hint.textContent =
            "Tối đa " +
            Rules.MAX_BOOKING_SLOTS +
            " khung. Khung thứ 4 là dọn bàn — hệ thống tự chặn, không chọn thủ công.";
        }
        return;
      }

      var endIso = Rules.toIsoLocal(Rules.slotEndTime(slotDate));
      applySelection(selectionStart, endIso);
      selectionStart = null;
    });

    buildCalendar(root, blocks, null);
    clearSelection();

    if (tableId && ctx) {
      fetch(ctx + "/api/table-schedule?tableId=" + tableId)
        .then(function (r) {
          return r.json();
        })
        .then(function (data) {
          if (data && data.blocks) {
            blocks = data.blocks;
            clearSelection();
          }
        })
        .catch(function () {});
    }

    var resetBtn = document.getElementById("btnResetSelection");
    if (resetBtn) resetBtn.addEventListener("click", clearSelection);
  }

  document.addEventListener("DOMContentLoaded", init);
})();
