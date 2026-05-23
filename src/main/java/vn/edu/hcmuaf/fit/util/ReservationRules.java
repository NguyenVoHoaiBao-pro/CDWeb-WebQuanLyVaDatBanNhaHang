package vn.edu.hcmuaf.fit.util;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Quy tắc đặt bàn theo khung giờ 2 giờ:
 * - Mỗi khung giờ = 2 giờ (08:00–10:00, 10:00–12:00, ...)
 * - Khách chọn tối đa 3 khung giờ liên tiếp (tối đa 6 giờ ngồi)
 * - Sau khung cuối: tự thêm 1 khung dọn bàn 2 giờ (không cho đặt)
 */
public final class ReservationRules {

    public static final int OPEN_HOUR = 8;
    public static final int CLOSE_HOUR = 22;
    /** Mỗi khung giờ trên lịch = 2 giờ */
    public static final int SLOT_DURATION_HOURS = 2;
    /** Tối đa 3 khung giờ khách được chọn */
    public static final int MAX_BOOKING_SLOTS = 3;
    /** 1 khung dọn bàn sau khung đặt cuối */
    public static final int CLEANING_SLOT_COUNT = 1;
    public static final int CLEANING_BUFFER_HOURS = SLOT_DURATION_HOURS * CLEANING_SLOT_COUNT;

    public static final int MAX_BOOKING_DAYS_AHEAD = 7;

    private static final DateTimeFormatter DB_FORMAT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private ReservationRules() {
    }

    public static LocalDateTime parseDateTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        String v = value.trim().replace("T", " ");
        if (v.length() == 16) {
            v = v + ":00";
        }
        try {
            return LocalDateTime.parse(v, DB_FORMAT);
        } catch (DateTimeParseException e) {
            try {
                return LocalDateTime.parse(value.trim());
            } catch (DateTimeParseException e2) {
                return null;
            }
        }
    }

    public static String toDbString(LocalDateTime dt) {
        return dt.format(DB_FORMAT);
    }

    public static String toIsoLocal(LocalDateTime dt) {
        return dt.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    /** Giờ bắt đầu hợp lệ của một khung giờ (8, 10, 12, ...). */
    public static boolean isSlotStart(LocalDateTime dt) {
        if (dt == null) {
            return false;
        }
        if (dt.getMinute() != 0 || dt.getSecond() != 0) {
            return false;
        }
        int h = dt.getHour();
        if (h < OPEN_HOUR || h >= CLOSE_HOUR) {
            return false;
        }
        return (h - OPEN_HOUR) % SLOT_DURATION_HOURS == 0;
    }

    public static int countBookingSlots(LocalDateTime start, LocalDateTime end) {
        if (start == null || end == null || !end.isAfter(start)) {
            return 0;
        }
        long hours = Duration.between(start, end).toHours();
        if (hours % SLOT_DURATION_HOURS != 0) {
            return -1;
        }
        return (int) (hours / SLOT_DURATION_HOURS);
    }

    public static LocalDateTime cleaningBufferUntil(LocalDateTime reservationEnd) {
        return reservationEnd.plusHours(CLEANING_BUFFER_HOURS);
    }

    public static LocalDateTime blockedPeriodEnd(LocalDateTime reservationEnd) {
        return cleaningBufferUntil(reservationEnd);
    }

    public static String validateNewBooking(
            LocalDateTime start,
            LocalDateTime end,
            LocalDateTime now
    ) {
        if (start == null || end == null) {
            return "Thời gian đặt bàn không hợp lệ";
        }
        if (!end.isAfter(start)) {
            return "Giờ kết thúc phải sau giờ bắt đầu";
        }
        if (!start.toLocalDate().equals(end.toLocalDate())) {
            return "Chỉ được chọn các khung giờ trong cùng một ngày";
        }
        if (!isSlotStart(start)) {
            return "Giờ bắt đầu phải trùng khung giờ 2h (VD: 08:00, 10:00, 12:00...)";
        }
        if (!isSlotStart(end.minusHours(SLOT_DURATION_HOURS))) {
            return "Giờ kết thúc phải trùng biên khung giờ 2h";
        }

        int slots = countBookingSlots(start, end);
        if (slots < 1) {
            return "Phải chọn ít nhất 1 khung giờ (2 giờ)";
        }
        if (slots < 0) {
            return "Thời lượng phải là bội số của 2 giờ";
        }
        if (slots > MAX_BOOKING_SLOTS) {
            return "Tối đa " + MAX_BOOKING_SLOTS + " khung giờ (6 giờ), khung thứ 4 là dọn bàn — hệ thống tự chặn";
        }

        LocalDateTime cleaningEnd = cleaningBufferUntil(end);
        if (start.toLocalTime().isBefore(LocalTime.of(OPEN_HOUR, 0))) {
            return "Giờ mở cửa: " + OPEN_HOUR + ":00 - " + CLOSE_HOUR + ":00";
        }
        if (cleaningEnd.toLocalDate().isAfter(start.toLocalDate())) {
            // delay tràn ngày — vẫn OK nếu chỉ chặn bàn
        } else if (cleaningEnd.toLocalTime().isAfter(LocalTime.of(CLOSE_HOUR, 0))
                && end.toLocalTime().isAfter(LocalTime.of(OPEN_HOUR, 0))) {
            // cục cuối trong ngày có thể kéo delay sau 22h — chấp nhận để chặn bàn
        }

        if (start.isBefore(now)) {
            return "Không thể đặt thời gian trong quá khứ";
        }
        if (start.isAfter(now.plusDays(MAX_BOOKING_DAYS_AHEAD))) {
            return "Chỉ được đặt bàn tối đa trước " + MAX_BOOKING_DAYS_AHEAD + " ngày";
        }

        return null;
    }

    public static boolean intervalsOverlap(
            LocalDateTime aStart,
            LocalDateTime aBufferEnd,
            LocalDateTime bStart,
            LocalDateTime bBufferEnd
    ) {
        return aStart.isBefore(bBufferEnd) && bStart.isBefore(aBufferEnd);
    }

    public static boolean rangesOverlap(
            LocalDateTime newStart,
            LocalDateTime newEnd,
            LocalDateTime existingStart,
            LocalDateTime existingBufferEnd
    ) {
        return intervalsOverlap(
                newStart,
                blockedPeriodEnd(newEnd),
                existingStart,
                existingBufferEnd
        );
    }

    public static String validateCapacity(int numberOfPeople, int tableCapacity) {
        if (numberOfPeople <= 0) {
            return "Số người không hợp lệ";
        }
        if (tableCapacity > 0 && numberOfPeople > tableCapacity) {
            return "Số người vượt quá sức chứa của bàn (tối đa " + tableCapacity + ")";
        }
        return null;
    }

    public static LocalDateTime now() {
        return LocalDateTime.now();
    }
}
