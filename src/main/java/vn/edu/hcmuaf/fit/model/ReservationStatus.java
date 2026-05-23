package vn.edu.hcmuaf.fit.model;

public final class ReservationStatus {

    public static final String PENDING = "PENDING";
    public static final String CONFIRMED = "CONFIRMED";
    public static final String COMPLETED = "COMPLETED";
    public static final String CANCELLED = "CANCELLED";

    /** Legacy statuses still present in DB */
    public static final String DONE = "DONE";
    public static final String WAITING_PAYMENT = "WAITING_PAYMENT";

    private ReservationStatus() {
    }

    public static boolean isActiveBookingStatus(String status) {
        if (status == null) {
            return false;
        }
        switch (status) {
            case PENDING:
            case CONFIRMED:
            case WAITING_PAYMENT:
                return true;
            default:
                return false;
        }
    }

    public static String normalize(String status) {
        if (DONE.equals(status)) {
            return COMPLETED;
        }
        return status;
    }
}
