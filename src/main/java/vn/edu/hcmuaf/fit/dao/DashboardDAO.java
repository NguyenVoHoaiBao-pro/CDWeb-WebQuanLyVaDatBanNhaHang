package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.DailyRevenue;
import vn.edu.hcmuaf.fit.model.DashboardStats;
import vn.edu.hcmuaf.fit.model.TopProductStat;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.ReservationAnalyticsDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.*;

public class DashboardDAO {

    private static final String ORDER_DATE_EXPR =
            "COALESCE(r.confirmed_at, CAST(REPLACE(r.reservation_time, 'T', ' ') AS DATETIME))";

    private final AdminDAO adminDAO = new AdminDAO();

    public DashboardStats loadDashboard(int year, int month) {
        DashboardStats stats = new DashboardStats();
        stats.setYear(year);
        stats.setMonth(month);
        stats.setMonthLabel(monthLabel(year, month));

        stats.setTotalUsers(adminDAO.countUsers());
        stats.setTotalProducts(adminDAO.countProducts());
        stats.setTotalTables(adminDAO.countTables());
        stats.setTotalReservations(adminDAO.countReservations());
        stats.setTotalOrders(adminDAO.countOrders());

        stats.setRevenueMonth(sumRevenueInMonth(year, month));
        stats.setOrdersMonth(countOrdersInMonth(year, month));
        stats.setAvgOrderValue(
                stats.getOrdersMonth() > 0
                        ? stats.getRevenueMonth() / stats.getOrdersMonth()
                        : 0
        );

        LocalDate today = LocalDate.now();
        if (today.getYear() == year && today.getMonthValue() == month) {
            stats.setRevenueToday(sumRevenueOnDay(year, month, today.getDayOfMonth()));
            stats.setOrdersToday(countOrdersOnDay(year, month, today.getDayOfMonth()));
            stats.setRevenueYesterday(
                    sumRevenueOnDay(year, month, today.getDayOfMonth() - 1)
            );
        } else {
            stats.setRevenueToday(0);
            stats.setOrdersToday(0);
            stats.setRevenueYesterday(0);
        }

        if (stats.getRevenueYesterday() > 0) {
            stats.setGrowthPercent(
                    ((stats.getRevenueToday() - stats.getRevenueYesterday())
                            / stats.getRevenueYesterday()) * 100
            );
        } else if (stats.getRevenueToday() > 0) {
            stats.setGrowthPercent(100);
        } else {
            stats.setGrowthPercent(0);
        }

        stats.setRevenuePaid(sumRevenueByPayment(year, month, "PAID"));
        stats.setRevenueUnpaid(sumRevenueByPayment(year, month, "UNPAID"));

        loadReservationBreakdown(stats, year, month);
        stats.setDailyRevenue(buildDailySeries(year, month));
        stats.setTopProducts(loadTopProducts(year, month, 5));

        ReservationDAO reservationDAO = new ReservationDAO();
        reservationDAO.expirePendingReservations();
        stats.setReservationAnalytics(new ReservationAnalyticsDAO().loadTodayAnalytics());

        return stats;
    }

    private String monthLabel(int year, int month) {
        YearMonth ym = YearMonth.of(year, month);
        String name = ym.getMonth().getDisplayName(TextStyle.FULL, new Locale("vi", "VN"));
        return name.substring(0, 1).toUpperCase() + name.substring(1) + " " + year;
    }

    private double sumRevenueInMonth(int year, int month) {
        String sql =
                "SELECT COALESCE(SUM(o.total), 0) FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ?";
        return queryDouble(sql, year, month);
    }

    private double sumRevenueOnDay(int year, int month, int day) {
        if (day < 1) return 0;
        String sql =
                "SELECT COALESCE(SUM(o.total), 0) FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND DAY(" + ORDER_DATE_EXPR + ") = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ps.setInt(3, day);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int countOrdersInMonth(int year, int month) {
        String sql =
                "SELECT COUNT(o.id) FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ?";
        return queryInt(sql, year, month);
    }

    private int countOrdersOnDay(int year, int month, int day) {
        if (day < 1) return 0;
        String sql =
                "SELECT COUNT(o.id) FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND DAY(" + ORDER_DATE_EXPR + ") = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ps.setInt(3, day);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private double sumRevenueByPayment(int year, int month, String status) {
        String sql =
                "SELECT COALESCE(SUM(o.total), 0) FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND o.payment_status = ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ps.setString(3, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void loadReservationBreakdown(DashboardStats stats, int year, int month) {
        String sql =
                "SELECT r.status, COUNT(*) cnt FROM reservations r " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "GROUP BY r.status";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                if ("PENDING".equals(status)) stats.setReservationsPending(cnt);
                else if ("CONFIRMED".equals(status)) stats.setReservationsConfirmed(cnt);
                else if ("DONE".equals(status)) stats.setReservationsDone(cnt);
                else if ("CANCELLED".equals(status)) stats.setReservationsCancelled(cnt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<DailyRevenue> buildDailySeries(int year, int month) {
        Map<Integer, DailyRevenue> map = new TreeMap<>();
        int daysInMonth = YearMonth.of(year, month).lengthOfMonth();
        for (int d = 1; d <= daysInMonth; d++) {
            map.put(d, new DailyRevenue(d, 0, 0));
        }

        String sql =
                "SELECT DAY(" + ORDER_DATE_EXPR + ") d, " +
                        "COALESCE(SUM(o.total), 0) rev, COUNT(o.id) cnt " +
                        "FROM orders o " +
                        "INNER JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "GROUP BY DAY(" + ORDER_DATE_EXPR + ")";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int day = rs.getInt("d");
                if (map.containsKey(day)) {
                    map.get(day).setRevenue(rs.getDouble("rev"));
                    map.get(day).setOrderCount(rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    private List<TopProductStat> loadTopProducts(int year, int month, int limit) {
        List<TopProductStat> list = new ArrayList<>();
        String sql =
                "SELECT p.name, SUM(od.quantity) qty, SUM(od.quantity * od.price) rev " +
                        "FROM order_details od " +
                        "JOIN orders o ON od.order_id = o.id " +
                        "JOIN products p ON od.product_id = p.id " +
                        "JOIN reservations r ON o.reservation_id = r.id " +
                        "WHERE YEAR(" + ORDER_DATE_EXPR + ") = ? " +
                        "AND MONTH(" + ORDER_DATE_EXPR + ") = ? " +
                        "GROUP BY p.id, p.name " +
                        "ORDER BY rev DESC LIMIT ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopProductStat t = new TopProductStat();
                t.setName(rs.getString("name"));
                t.setQuantity(rs.getInt("qty"));
                t.setRevenue(rs.getDouble("rev"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private double queryDouble(String sql, int year, int month) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int queryInt(String sql, int year, int month) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
