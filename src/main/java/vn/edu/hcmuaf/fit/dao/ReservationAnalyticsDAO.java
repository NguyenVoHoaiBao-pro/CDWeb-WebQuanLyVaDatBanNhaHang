package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.HourlyBookingStat;
import vn.edu.hcmuaf.fit.model.ReservationAnalytics;
import vn.edu.hcmuaf.fit.model.ScheduleBlock;
import vn.edu.hcmuaf.fit.model.TableBookingStat;
import vn.edu.hcmuaf.fit.util.ReservationSql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReservationAnalyticsDAO {

    public ReservationAnalytics loadTodayAnalytics() {
        ReservationAnalytics a = new ReservationAnalytics();
        a.setReservationsToday(countTodayCreated());
        a.setActiveReservations(countActive());
        a.setCancelledToday(countTodayByStatus("CANCELLED"));
        a.setCompletedToday(countTodayByStatusCompleted());
        a.setTableUtilizationPercent(computeUtilizationToday());
        a.setTopTables(loadTopTables(5));
        a.setBusiestHours(loadBusiestHours(8));
        a.setTodayTimeline(loadTodayTimeline());
        return a;
    }

    private int countTodayCreated() {
        String sql =
                "SELECT COUNT(*) FROM reservations " +
                        "WHERE DATE(created_at) = CURDATE()";
        return queryInt(sql);
    }

    private int countActive() {
        String sql =
                "SELECT COUNT(*) FROM reservations WHERE " + ReservationSql.ACTIVE_WHERE;
        return queryInt(sql);
    }

    private int countTodayByStatus(String status) {
        String sql =
                "SELECT COUNT(*) FROM reservations " +
                        "WHERE status = ? AND DATE(created_at) = CURDATE()";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int countTodayByStatusCompleted() {
        String sql =
                "SELECT COUNT(*) FROM reservations " +
                        "WHERE status IN ('COMPLETED','DONE') AND DATE(created_at) = CURDATE()";
        return queryInt(sql);
    }

    private double computeUtilizationToday() {
        int totalTables = queryInt("SELECT COUNT(*) FROM restaurant_tables");
        if (totalTables == 0) return 0;

        String sql =
                "SELECT COUNT(DISTINCT table_id) FROM reservations " +
                        "WHERE DATE(" + ReservationSql.EFFECTIVE_START + ") = CURDATE() " +
                        "AND status NOT IN ('CANCELLED')";
        int used = queryInt(sql);
        return Math.min(100.0, (used * 100.0) / totalTables);
    }

    private List<TableBookingStat> loadTopTables(int limit) {
        List<TableBookingStat> list = new ArrayList<>();
        String sql =
                "SELECT r.table_id, t.name, COUNT(*) AS cnt " +
                        "FROM reservations r " +
                        "LEFT JOIN restaurant_tables t ON r.table_id = t.id " +
                        "WHERE r.status NOT IN ('CANCELLED') " +
                        "AND " + ReservationSql.EFFECTIVE_START + " >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                        "GROUP BY r.table_id, t.name " +
                        "ORDER BY cnt DESC LIMIT ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TableBookingStat s = new TableBookingStat();
                s.setTableId(rs.getInt("table_id"));
                s.setTableName(rs.getString("name"));
                s.setBookingCount(rs.getInt("cnt"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<HourlyBookingStat> loadBusiestHours(int limit) {
        List<HourlyBookingStat> list = new ArrayList<>();
        String sql =
                "SELECT HOUR(" + ReservationSql.EFFECTIVE_START + ") AS hr, COUNT(*) AS cnt " +
                        "FROM reservations " +
                        "WHERE status NOT IN ('CANCELLED') " +
                        "AND " + ReservationSql.EFFECTIVE_START + " >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                        "GROUP BY hr ORDER BY cnt DESC LIMIT ?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HourlyBookingStat h = new HourlyBookingStat();
                h.setHour(rs.getInt("hr"));
                h.setCount(rs.getInt("cnt"));
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<ScheduleBlock> loadTodayTimeline() {
        List<ScheduleBlock> blocks = new ArrayList<>();
        String sql =
                "SELECT r.id, r.table_id, t.name, " +
                        ReservationSql.EFFECTIVE_START + " AS eff_start, " +
                        ReservationSql.EFFECTIVE_END + " AS eff_end, " +
                        ReservationSql.EFFECTIVE_BUFFER + " AS eff_buffer, r.status " +
                        "FROM reservations r " +
                        "LEFT JOIN restaurant_tables t ON r.table_id = t.id " +
                        "WHERE DATE(" + ReservationSql.EFFECTIVE_START + ") = CURDATE() " +
                        "AND r.status NOT IN ('CANCELLED') " +
                        "ORDER BY eff_start LIMIT 40";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                String start = toIso(rs.getString("eff_start"));
                String end = toIso(rs.getString("eff_end"));
                String buffer = toIso(rs.getString("eff_buffer"));
                int id = rs.getInt("id");
                String tableName = rs.getString("name");
                String label = (tableName != null ? tableName : "Bàn #" + rs.getInt("table_id"));

                ScheduleBlock booked = new ScheduleBlock(start, end, ScheduleBlock.TYPE_BOOKED, id);
                blocks.add(booked);
                if (end != null && buffer != null && !end.equals(buffer)) {
                    blocks.add(new ScheduleBlock(end, buffer, ScheduleBlock.TYPE_CLEANING, id));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blocks;
    }

    private String toIso(String db) {
        if (db == null) return null;
        return db.trim().replace(" ", "T");
    }

    private int queryInt(String sql) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
