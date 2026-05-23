package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.ReservationValidationResult;
import vn.edu.hcmuaf.fit.model.RestaurantTable;
import vn.edu.hcmuaf.fit.model.ScheduleBlock;
import vn.edu.hcmuaf.fit.util.ReservationRules;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class ReservationAvailabilityService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final TableDAO tableDAO = new TableDAO();

    public void expirePendingReservations() {
        reservationDAO.expirePendingReservations();
    }

    public List<ScheduleBlock> getScheduleBlocks(int tableId, int daysAhead) {
        expirePendingReservations();
        return reservationDAO.getScheduleBlocks(tableId, daysAhead);
    }

    public Map<String, Object> buildScheduleApiPayload(int tableId, int daysAhead) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("tableId", tableId);
        payload.put("timezone", "Asia/Ho_Chi_Minh");
        payload.put("serverNow", ReservationRules.toIsoLocal(ReservationRules.now()));
        payload.putAll(buildRulesConfig());
        payload.put("blocks", getScheduleBlocks(tableId, daysAhead));
        return payload;
    }

    public Map<String, Object> buildRulesConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("openHour", ReservationRules.OPEN_HOUR);
        config.put("closeHour", ReservationRules.CLOSE_HOUR);
        config.put("slotDurationHours", ReservationRules.SLOT_DURATION_HOURS);
        config.put("maxBookingSlots", ReservationRules.MAX_BOOKING_SLOTS);
        config.put("cleaningSlotCount", ReservationRules.CLEANING_SLOT_COUNT);
        config.put("cleaningBufferHours", ReservationRules.CLEANING_BUFFER_HOURS);
        config.put("daysAhead", ReservationRules.MAX_BOOKING_DAYS_AHEAD);
        return config;
    }

    public ReservationValidationResult validateBooking(
            int tableId,
            String startRaw,
            String endRaw,
            int numberOfPeople,
            int excludeReservationId
    ) {
        expirePendingReservations();

        RestaurantTable table = tableDAO.findById(tableId);
        if (table == null) {
            return ReservationValidationResult.fail("Bàn không tồn tại");
        }

        String capacityError = ReservationRules.validateCapacity(numberOfPeople, table.getCapacity());
        if (capacityError != null) {
            return ReservationValidationResult.fail(capacityError);
        }

        LocalDateTime start = ReservationRules.parseDateTime(startRaw);
        LocalDateTime end = ReservationRules.parseDateTime(endRaw);
        if (end == null && start != null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }

        String timeError = ReservationRules.validateNewBooking(start, end, ReservationRules.now());
        if (timeError != null) {
            return ReservationValidationResult.fail(timeError);
        }

        if (reservationDAO.hasOverlap(tableId, start, end, excludeReservationId)) {
            return ReservationValidationResult.fail(
                    "Bàn đã có lịch trùng hoặc đang trong khung dọn bàn (2 giờ sau đơn trước)");
        }

        return ReservationValidationResult.ok();
    }

    public int createBooking(int userId, int tableId, String startRaw, String endRaw, int numberOfPeople) {
        ReservationValidationResult check =
                validateBooking(tableId, startRaw, endRaw, numberOfPeople, 0);
        if (!check.isValid()) {
            return 0;
        }

        LocalDateTime start = ReservationRules.parseDateTime(startRaw);
        LocalDateTime end = ReservationRules.parseDateTime(endRaw);
        if (end == null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }

        return reservationDAO.insertRange(userId, tableId, start, end, numberOfPeople);
    }

    public boolean updateBookingForUser(
            int reservationId,
            int userId,
            String startRaw,
            String endRaw,
            int numberOfPeople
    ) {
        Reservation existing = reservationDAO.findById(reservationId);
        if (existing == null || existing.getUserId() != userId) {
            return false;
        }
        if (!"PENDING".equals(existing.getStatus())) {
            return false;
        }

        ReservationValidationResult check = validateBooking(
                existing.getTableId(),
                startRaw,
                endRaw,
                numberOfPeople,
                reservationId
        );
        if (!check.isValid()) {
            return false;
        }

        return reservationDAO.updateBookingForUser(
                reservationId,
                userId,
                startRaw,
                endRaw,
                numberOfPeople
        );
    }
}
