/**
 * Khung giờ 2h — tối đa 3 khung đặt + 1 khung dọn bàn (đồng bộ ReservationRules.java)
 */
window.ReservationRules = (function () {
  "use strict";

  var OPEN_HOUR = 8;
  var CLOSE_HOUR = 22;
  var SLOT_HOURS = 2;
  var MAX_BOOKING_SLOTS = 3;
  var CLEANING_SLOT_COUNT = 1;
  var CLEANING_BUFFER_HOURS = 2;
  var MAX_DAYS_AHEAD = 7;

  function applyConfig(cfg) {
    if (!cfg) return;
    if (cfg.openHour != null) OPEN_HOUR = cfg.openHour;
    if (cfg.closeHour != null) CLOSE_HOUR = cfg.closeHour;
    if (cfg.slotDurationHours != null) SLOT_HOURS = cfg.slotDurationHours;
    if (cfg.maxBookingSlots != null) MAX_BOOKING_SLOTS = cfg.maxBookingSlots;
    if (cfg.cleaningBufferHours != null) CLEANING_BUFFER_HOURS = cfg.cleaningBufferHours;
    if (cfg.daysAhead != null) MAX_DAYS_AHEAD = cfg.daysAhead;
  }

  function loadEmbeddedConfig() {
    var el = document.getElementById("reservationRulesData");
    if (!el) return;
    try {
      applyConfig(JSON.parse(el.textContent));
    } catch (e) {}
  }

  function fetchRemoteConfig(ctx) {
    if (!ctx) return Promise.resolve();
    return fetch(ctx + "/api/reservation-config", { headers: { Accept: "application/json" } })
      .then(function (r) {
        return r.json();
      })
      .then(applyConfig)
      .catch(function () {});
  }

  loadEmbeddedConfig();

  function pad(n) {
    return n < 10 ? "0" + n : String(n);
  }

  function parseDateTime(iso) {
    if (!iso) return null;
    var d = new Date(iso.replace(" ", "T"));
    return isNaN(d.getTime()) ? null : d;
  }

  function toIsoLocal(date) {
    return (
      date.getFullYear() +
      "-" +
      pad(date.getMonth() + 1) +
      "-" +
      pad(date.getDate()) +
      "T" +
      pad(date.getHours()) +
      ":00"
    );
  }

  function isSlotStart(date) {
    if (!date) return false;
    var h = date.getHours();
    if (date.getMinutes() !== 0) return false;
    if (h < OPEN_HOUR || h >= CLOSE_HOUR) return false;
    return (h - OPEN_HOUR) % SLOT_HOURS === 0;
  }

  function slotEndTime(slotStart) {
    return new Date(slotStart.getTime() + SLOT_HOURS * 3600 * 1000);
  }

  function countSlots(start, end) {
    if (!start || !end || end <= start) return 0;
    var hours = (end - start) / (3600 * 1000);
    if (hours % SLOT_HOURS !== 0) return -1;
    return hours / SLOT_HOURS;
  }

  function slotOverlapsInterval(slotStart, slotEnd, blockStart, blockEnd) {
    return slotStart < blockEnd && blockStart < slotEnd;
  }

  function getSlotState(slotIso, blocks, now) {
    var slotStart = parseDateTime(slotIso);
    if (!slotStart || !isSlotStart(slotStart)) return "past";
    var slotEnd = slotEndTime(slotStart);

    if (slotEnd.getTime() <= now.getTime()) return "past";

    for (var i = 0; i < blocks.length; i++) {
      var b = blocks[i];
      var bs = parseDateTime(b.start);
      var be = parseDateTime(b.end);
      if (!bs || !be) continue;
      if (!slotOverlapsInterval(slotStart, slotEnd, bs, be)) continue;
      if (b.type === "cleaning") return "cleaning";
      if (b.type === "booked") return "booked";
    }
    return "available";
  }

  function validateRange(startIso, endIso, now) {
    var start = parseDateTime(startIso);
    var end = parseDateTime(endIso);
    if (!start || !end) return "Thời gian không hợp lệ";
    if (end.getTime() <= start.getTime()) return "Giờ kết thúc phải sau khung giờ bắt đầu";
    if (
      start.getFullYear() !== end.getFullYear() ||
      start.getMonth() !== end.getMonth() ||
      start.getDate() !== end.getDate()
    ) {
      return "Chỉ chọn khung giờ trong cùng một ngày";
    }
    if (!isSlotStart(start)) return "Khung giờ bắt đầu không hợp lệ";
    var slots = countSlots(start, end);
    if (slots < 1) return "Chọn ít nhất 1 khung giờ (2 giờ)";
    if (slots < 0) return "Phải chọn theo khung giờ 2 giờ";
    if (slots > MAX_BOOKING_SLOTS) {
      return "Tối đa " + MAX_BOOKING_SLOTS + " khung giờ (6 giờ). Khung thứ 4 là dọn bàn — hệ thống tự chặn.";
    }
    if (start.getTime() < now.getTime()) return "Không đặt trong quá khứ";
    var max = new Date(now);
    max.setDate(max.getDate() + MAX_DAYS_AHEAD);
    if (start.getTime() > max.getTime()) {
      return "Chỉ đặt tối đa " + MAX_DAYS_AHEAD + " ngày trước";
    }
    return null;
  }

  function rangeOverlapsBlocks(startIso, endIso, blocks) {
    var start = parseDateTime(startIso);
    var end = parseDateTime(endIso);
    if (!start || !end) return true;
    var bufferEnd = new Date(end.getTime() + CLEANING_BUFFER_HOURS * 3600 * 1000);

    for (var i = 0; i < blocks.length; i++) {
      var b = blocks[i];
      var bs = parseDateTime(b.start);
      var be = parseDateTime(b.end);
      if (!bs || !be) continue;
      if (start < be && bs < bufferEnd) return true;
    }
    return false;
  }

  function slotStarts() {
    var list = [];
    for (var h = OPEN_HOUR; h < CLOSE_HOUR; h += SLOT_HOURS) {
      list.push(h);
    }
    return list;
  }

  function slotLabel(hour) {
    return pad(hour) + ":00-" + pad(hour + SLOT_HOURS) + ":00";
  }

  return {
    OPEN_HOUR: OPEN_HOUR,
    CLOSE_HOUR: CLOSE_HOUR,
    SLOT_HOURS: SLOT_HOURS,
    MAX_BOOKING_SLOTS: MAX_BOOKING_SLOTS,
    CLEANING_BUFFER_HOURS: CLEANING_BUFFER_HOURS,
    MAX_DAYS_AHEAD: MAX_DAYS_AHEAD,
    applyConfig: applyConfig,
    fetchRemoteConfig: fetchRemoteConfig,
    pad: pad,
    parseDateTime: parseDateTime,
    toIsoLocal: toIsoLocal,
    isSlotStart: isSlotStart,
    slotEndTime: slotEndTime,
    countSlots: countSlots,
    getSlotState: getSlotState,
    validateRange: validateRange,
    rangeOverlapsBlocks: rangeOverlapsBlocks,
    slotOverlapsInterval: slotOverlapsInterval,
    slotStarts: slotStarts,
    slotLabel: slotLabel,
  };
})();
