package vn.edu.hcmuaf.fit.model;

public class ReservationValidationResult {

    private final boolean valid;
    private final String message;

    private ReservationValidationResult(boolean valid, String message) {
        this.valid = valid;
        this.message = message;
    }

    public static ReservationValidationResult ok() {
        return new ReservationValidationResult(true, null);
    }

    public static ReservationValidationResult fail(String message) {
        return new ReservationValidationResult(false, message);
    }

    public boolean isValid() {
        return valid;
    }

    public String getMessage() {
        return message;
    }
}
