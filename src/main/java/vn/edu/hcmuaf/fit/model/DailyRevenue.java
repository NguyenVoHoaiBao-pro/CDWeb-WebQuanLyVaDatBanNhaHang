package vn.edu.hcmuaf.fit.model;

public class DailyRevenue {
    private int day;
    private double revenue;
    private int orderCount;

    public DailyRevenue() {}

    public DailyRevenue(int day, double revenue, int orderCount) {
        this.day = day;
        this.revenue = revenue;
        this.orderCount = orderCount;
    }

    public int getDay() { return day; }
    public void setDay(int day) { this.day = day; }

    public double getRevenue() { return revenue; }
    public void setRevenue(double revenue) { this.revenue = revenue; }

    public int getOrderCount() { return orderCount; }
    public void setOrderCount(int orderCount) { this.orderCount = orderCount; }
}
