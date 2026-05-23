package vn.edu.hcmuaf.fit.util;

public final class ReservationSql {

    public static final String EFFECTIVE_START =
            "COALESCE(reservation_start_time, reservation_time)";

    public static final String EFFECTIVE_END =
            "COALESCE(reservation_end_time, DATE_ADD(reservation_time, INTERVAL 2 HOUR))";

    public static final String EFFECTIVE_BUFFER =
            "COALESCE(cleaning_buffer_until, DATE_ADD(" + EFFECTIVE_END + ", INTERVAL "
                    + ReservationRules.CLEANING_BUFFER_HOURS + " HOUR))";

    public static final String ACTIVE_WHERE =
            "status <> 'CANCELLED' AND status <> 'COMPLETED' AND status <> 'DONE' " +
                    "AND (status IN ('CONFIRMED','WAITING_PAYMENT') " +
                    "OR (status = 'PENDING' AND expired_at > NOW())) " +
                    "AND " + EFFECTIVE_BUFFER + " > NOW()";

    private ReservationSql() {
    }
}
