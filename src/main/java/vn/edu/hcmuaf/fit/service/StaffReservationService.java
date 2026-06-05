package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.ReservationValidationResult;
import vn.edu.hcmuaf.fit.util.ReservationRules;
import vn.edu.hcmuaf.fit.dao.TableDAO;

import java.time.LocalDateTime;

public class StaffReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final ReservationAvailabilityService availabilityService = new ReservationAvailabilityService();

    public ReservationValidationResult validateWalkIn(
            int tableId,
            String startRaw,
            String endRaw,
            int numberOfPeople
    ) {
        return availabilityService.validateBooking(tableId, startRaw, endRaw, numberOfPeople, 0);
    }

    public int createWalkIn(
            int staffUserId,
            int tableId,
            String startRaw,
            String endRaw,
            int numberOfPeople,
            String guestName
    ) {
        ReservationValidationResult check =
                validateWalkIn(tableId, startRaw, endRaw, numberOfPeople);
        if (!check.isValid()) {
            return 0;
        }

        double totalPrice = 0;
        vn.edu.hcmuaf.fit.model.RestaurantTable table = tableDAO.findById(tableId);
        if (table != null) {
            totalPrice = table.getPrice();
        }

        LocalDateTime start = ReservationRules.parseDateTime(startRaw);
        LocalDateTime end = ReservationRules.parseDateTime(endRaw);
        if (end == null && start != null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }
        return reservationDAO.insertStaffRange(
                staffUserId, tableId, start, end, numberOfPeople, guestName, totalPrice);
    }


    public String adjustToUsedSlots(int reservationId, int usedSlots, int staffUserId) {
        if (usedSlots < 1 || usedSlots > ReservationRules.MAX_BOOKING_SLOTS) {
            return "Số khung giờ sử dụng phải từ 1 đến " + ReservationRules.MAX_BOOKING_SLOTS;
        }
        Reservation r = reservationDAO.findById(reservationId);
        if (r == null) {
            return "Không tìm thấy đặt bàn";
        }
        LocalDateTime start = ReservationRules.parseDateTime(r.getReservationStartTime());
        LocalDateTime bookedEnd = ReservationRules.parseDateTime(r.getReservationEndTime());
        if (start == null || bookedEnd == null) {
            return "Dữ liệu thời gian không hợp lệ";
        }
        int bookedSlots = ReservationRules.countBookingSlots(start, bookedEnd);
        if (usedSlots > bookedSlots) {
            return "Không thể tăng quá số khung đã đặt (" + bookedSlots + " khung)";
        }
        LocalDateTime newEnd = start.plusHours((long) usedSlots * ReservationRules.SLOT_DURATION_HOURS);
        if (!reservationDAO.adjustReservationEnd(reservationId, newEnd, staffUserId)) {
            return "Không thể điều chỉnh — trùng lịch hoặc trạng thái không hợp lệ";
        }
        return null;
    }
}
