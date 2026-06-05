
package vn.edu.hcmuaf.fit.model;

public class RestaurantTable {

    private int id;
    private String name;
    private int capacity;
    private String status;
    private int floorNumber;
    private int positionX;
    private int positionY;
    private double price;

    public RestaurantTable() {
    }

    public RestaurantTable(int id,
                           String name,
                           int capacity,
                           String status,
                           double price) {
        this.id = id;
        this.name = name;
        this.capacity = capacity;
        this.status = status;
        this.price = price;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

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

    public void setFloor(int floor) {
        this.floorNumber = floor;
    }

    public int getFloor() {
        return this.floorNumber;
    }

    public int getPositionY() {
        return positionY;
    }

    public void setPositionY(int positionY) {
        this.positionY = positionY;
    }

    public int getPositionX() {
        return positionX;
    }

    public void setPositionX(int positionX) {
        this.positionX = positionX;
    }

    public int getFloorNumber() {
        return floorNumber;
    }

    public void setFloorNumber(int floorNumber) {
        this.floorNumber = floorNumber;
    }
}