// FILE: src/main/java/vn/edu/hcmuaf/fit/model/RestaurantTable.java
// FIX CHUẨN THEO DATABASE capacity, KHÔNG dùng floor

package vn.edu.hcmuaf.fit.model;

public class RestaurantTable {

    private int id;
    private String name;
    private int capacity;
    private String status;

    public RestaurantTable() {
    }

    public RestaurantTable(int id,
                           String name,
                           int capacity,
                           String status) {
        this.id = id;
        this.name = name;
        this.capacity = capacity;
        this.status = status;
    }

    // =====================
    // GETTER / SETTER
    // =====================

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // =====================
    // GIỮ TƯƠNG THÍCH CODE CŨ
    // nếu file khác còn gọi setFloor()
    // =====================
    public void setFloor(int floor) {
        this.capacity = floor;
    }

    public int getFloor() {
        return this.capacity;
    }
}