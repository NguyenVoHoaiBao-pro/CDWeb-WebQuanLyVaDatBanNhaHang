package vn.edu.hcmuaf.fit.model;

public class Reservation {
    private int id;
    private int userId;
    private int tableId;
    private String reservationTime;
    private int numberOfPeople;
    private String status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }

    public String getReservationTime() { return reservationTime; }
    public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }

    public int getNumberOfPeople() { return numberOfPeople; }
    public void setNumberOfPeople(int numberOfPeople) { this.numberOfPeople = numberOfPeople; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}