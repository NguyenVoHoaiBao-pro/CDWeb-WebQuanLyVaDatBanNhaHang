package vn.edu.hcmuaf.fit.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public final class DateUtil {

    public static final DateTimeFormatter DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    public static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    public static final DateTimeFormatter DATE_TIME_SEC = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private static final DateTimeFormatter[] DB_PARSERS = {
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
    };

    private DateUtil() {
    }

    public static LocalDateTime parseDb(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        String v = value.trim().replace("T", " ");
        for (DateTimeFormatter f : DB_PARSERS) {
            try {
                if (f.toString().contains("HH:mm:ss") || v.length() > 16) {
                    return LocalDateTime.parse(v.length() == 16 ? v + ":00" : v, f);
                }
                return LocalDateTime.parse(v, f);
            } catch (DateTimeParseException ignored) {
            }
        }
        try {
            return LocalDateTime.parse(value.trim());
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    public static String formatDate(String dbValue) {
        LocalDateTime dt = parseDb(dbValue);
        return dt != null ? dt.format(DATE) : (dbValue != null ? dbValue : "");
    }

    public static String formatDateTime(String dbValue) {
        LocalDateTime dt = parseDb(dbValue);
        return dt != null ? dt.format(DATE_TIME) : (dbValue != null ? dbValue : "");
    }

    public static String formatDateTimeRange(String startDb, String endDb) {
        if (startDb == null || startDb.isEmpty()) {
            return "";
        }
        String s = formatDateTime(startDb);
        if (endDb == null || endDb.isEmpty()) {
            return s;
        }
        return s + " → " + formatDateTime(endDb);
    }

    public static String formatToday() {
        return LocalDate.now().format(DATE);
    }

    public static String formatNow() {
        return LocalDateTime.now().format(DATE_TIME);
    }

    public static String toIsoForInput(LocalDate date) {
        return date != null ? date.toString() : "";
    }
}
