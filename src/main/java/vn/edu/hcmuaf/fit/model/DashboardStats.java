package vn.edu.hcmuaf.fit.model;

import java.util.ArrayList;
import java.util.List;

public class DashboardStats {

    private int year;
    private int month;
    private String monthLabel;

    private double revenueMonth;
    private double revenueToday;
    private double revenueYesterday;
    private double growthPercent;

    private int ordersMonth;
    private int ordersToday;
    private double avgOrderValue;

    private double revenuePaid;
    private double revenueUnpaid;

    private int reservationsPending;
    private int reservationsConfirmed;
    private int reservationsDone;
    private int reservationsCancelled;

    private int totalUsers;
    private int totalProducts;
    private int totalTables;
    private int totalReservations;
    private int totalOrders;

    private List<DailyRevenue> dailyRevenue = new ArrayList<>();
    private List<TopProductStat> topProducts = new ArrayList<>();

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getMonth() { return month; }
    public void setMonth(int month) { this.month = month; }

    public String getMonthLabel() { return monthLabel; }
    public void setMonthLabel(String monthLabel) { this.monthLabel = monthLabel; }

    public double getRevenueMonth() { return revenueMonth; }
    public void setRevenueMonth(double revenueMonth) { this.revenueMonth = revenueMonth; }

    public double getRevenueToday() { return revenueToday; }
    public void setRevenueToday(double revenueToday) { this.revenueToday = revenueToday; }

    public double getRevenueYesterday() { return revenueYesterday; }
    public void setRevenueYesterday(double revenueYesterday) { this.revenueYesterday = revenueYesterday; }

    public double getGrowthPercent() { return growthPercent; }
    public void setGrowthPercent(double growthPercent) { this.growthPercent = growthPercent; }

    public int getOrdersMonth() { return ordersMonth; }
    public void setOrdersMonth(int ordersMonth) { this.ordersMonth = ordersMonth; }

    public int getOrdersToday() { return ordersToday; }
    public void setOrdersToday(int ordersToday) { this.ordersToday = ordersToday; }

    public double getAvgOrderValue() { return avgOrderValue; }
    public void setAvgOrderValue(double avgOrderValue) { this.avgOrderValue = avgOrderValue; }

    public double getRevenuePaid() { return revenuePaid; }
    public void setRevenuePaid(double revenuePaid) { this.revenuePaid = revenuePaid; }

    public double getRevenueUnpaid() { return revenueUnpaid; }
    public void setRevenueUnpaid(double revenueUnpaid) { this.revenueUnpaid = revenueUnpaid; }

    public int getReservationsPending() { return reservationsPending; }
    public void setReservationsPending(int reservationsPending) { this.reservationsPending = reservationsPending; }

    public int getReservationsConfirmed() { return reservationsConfirmed; }
    public void setReservationsConfirmed(int reservationsConfirmed) { this.reservationsConfirmed = reservationsConfirmed; }

    public int getReservationsDone() { return reservationsDone; }
    public void setReservationsDone(int reservationsDone) { this.reservationsDone = reservationsDone; }

    public int getReservationsCancelled() { return reservationsCancelled; }
    public void setReservationsCancelled(int reservationsCancelled) { this.reservationsCancelled = reservationsCancelled; }

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }

    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }

    public int getTotalTables() { return totalTables; }
    public void setTotalTables(int totalTables) { this.totalTables = totalTables; }

    public int getTotalReservations() { return totalReservations; }
    public void setTotalReservations(int totalReservations) { this.totalReservations = totalReservations; }

    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

    public List<DailyRevenue> getDailyRevenue() { return dailyRevenue; }
    public void setDailyRevenue(List<DailyRevenue> dailyRevenue) { this.dailyRevenue = dailyRevenue; }

    public List<TopProductStat> getTopProducts() { return topProducts; }
    public void setTopProducts(List<TopProductStat> topProducts) { this.topProducts = topProducts; }
}
