package vn.edu.hcmuaf.fit.model;


public class ScheduleBlock {

    public static final String TYPE_BOOKED = "booked";
    public static final String TYPE_CLEANING = "cleaning";

    private String start;
    private String end;
    private String type;
    private int reservationId;

    public ScheduleBlock() {
    }

    public ScheduleBlock(String start, String end, String type, int reservationId) {
        this.start = start;
        this.end = end;
        this.type = type;
        this.reservationId = reservationId;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }
}
