package vn.edu.hcmuaf.fit.model;

import java.util.ArrayList;
import java.util.List;

public class ReservationAnalytics {

    private int reservationsToday;
    private int activeReservations;
    private int cancelledToday;
    private int completedToday;
    private double tableUtilizationPercent;
    private List<TableBookingStat> topTables = new ArrayList<>();
    private List<HourlyBookingStat> busiestHours = new ArrayList<>();
    private List<ScheduleBlock> todayTimeline = new ArrayList<>();

    public int getReservationsToday() { return reservationsToday; }
    public void setReservationsToday(int reservationsToday) { this.reservationsToday = reservationsToday; }

    public int getActiveReservations() { return activeReservations; }
    public void setActiveReservations(int activeReservations) { this.activeReservations = activeReservations; }

    public int getCancelledToday() { return cancelledToday; }
    public void setCancelledToday(int cancelledToday) { this.cancelledToday = cancelledToday; }

    public int getCompletedToday() { return completedToday; }
    public void setCompletedToday(int completedToday) { this.completedToday = completedToday; }

    public double getTableUtilizationPercent() { return tableUtilizationPercent; }
    public void setTableUtilizationPercent(double tableUtilizationPercent) {
        this.tableUtilizationPercent = tableUtilizationPercent;
    }

    public List<TableBookingStat> getTopTables() { return topTables; }
    public void setTopTables(List<TableBookingStat> topTables) { this.topTables = topTables; }

    public List<HourlyBookingStat> getBusiestHours() { return busiestHours; }
    public void setBusiestHours(List<HourlyBookingStat> busiestHours) { this.busiestHours = busiestHours; }

    public List<ScheduleBlock> getTodayTimeline() { return todayTimeline; }
    public void setTodayTimeline(List<ScheduleBlock> todayTimeline) { this.todayTimeline = todayTimeline; }
}
