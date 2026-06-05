package vn.edu.hcmuaf.fit.model;

public class Reservation {
    private int id;
    private int userId;
    private int tableId;

    private String reservationTime;
    private String reservationStartTime;
    private String reservationEndTime;
    private String cleaningBufferUntil;
    private int numberOfPeople;
    private String status;
    private String bookingSource;
    private String guestName;
    private String staffAdjustedAt;
    private Integer staffAdjustedBy;
    private String customerUsername;
    private String tableName;
    private double totalPrice;
    private double paidAmount;
    private String vnpTxnRef;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public double getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(double paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getVnpTxnRef() {
        return vnpTxnRef;
    }

    public void setVnpTxnRef(String vnpTxnRef) {
        this.vnpTxnRef = vnpTxnRef;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }

    public String getReservationTime() {
        if (reservationStartTime != null && !reservationStartTime.isEmpty()) {
            return reservationStartTime;
        }
        return reservationTime;
    }

    public void setReservationTime(String reservationTime) {
        this.reservationTime = reservationTime;
        if (this.reservationStartTime == null) {
            this.reservationStartTime = reservationTime;
        }
    }

    public String getReservationStartTime() {
        return reservationStartTime != null ? reservationStartTime : reservationTime;
    }

    public void setReservationStartTime(String reservationStartTime) {
        this.reservationStartTime = reservationStartTime;
        this.reservationTime = reservationStartTime;
    }

    public String getReservationEndTime() {
        return reservationEndTime;
    }

    public void setReservationEndTime(String reservationEndTime) {
        this.reservationEndTime = reservationEndTime;
    }

    public String getCleaningBufferUntil() {
        return cleaningBufferUntil;
    }

    public void setCleaningBufferUntil(String cleaningBufferUntil) {
        this.cleaningBufferUntil = cleaningBufferUntil;
    }

    public int getNumberOfPeople() { return numberOfPeople; }
    public void setNumberOfPeople(int numberOfPeople) { this.numberOfPeople = numberOfPeople; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBookingSource() { return bookingSource; }
    public void setBookingSource(String bookingSource) { this.bookingSource = bookingSource; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getStaffAdjustedAt() { return staffAdjustedAt; }
    public void setStaffAdjustedAt(String staffAdjustedAt) { this.staffAdjustedAt = staffAdjustedAt; }

    public Integer getStaffAdjustedBy() { return staffAdjustedBy; }
    public void setStaffAdjustedBy(Integer staffAdjustedBy) { this.staffAdjustedBy = staffAdjustedBy; }

    public String getCustomerUsername() { return customerUsername; }
    public void setCustomerUsername(String customerUsername) { this.customerUsername = customerUsername; }

    public String getTableName() { return tableName; }
    public void setTableName(String tableName) { this.tableName = tableName; }
}
