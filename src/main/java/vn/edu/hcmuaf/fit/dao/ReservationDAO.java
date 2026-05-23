package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.ReservationStatus;
import vn.edu.hcmuaf.fit.model.ScheduleBlock;
import vn.edu.hcmuaf.fit.util.ReservationRules;
import vn.edu.hcmuaf.fit.util.ReservationSql;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class ReservationDAO {

    public int expirePendingReservations() {
        String sql =
                "UPDATE reservations SET status = 'CANCELLED' " +
                        "WHERE status = 'PENDING' AND expired_at IS NOT NULL AND expired_at < NOW()";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setUserId(rs.getInt("user_id"));
        r.setTableId(rs.getInt("table_id"));
        r.setNumberOfPeople(rs.getInt("number_of_people"));
        r.setStatus(rs.getString("status"));

        String start = getColumnString(rs, "reservation_start_time");
        if (start == null || start.isEmpty()) {
            start = rs.getString("reservation_time");
        }
        r.setReservationStartTime(start);
        r.setReservationTime(start);

        String end = getColumnString(rs, "reservation_end_time");
        r.setReservationEndTime(end);

        String buffer = getColumnString(rs, "cleaning_buffer_until");
        r.setCleaningBufferUntil(buffer);

        r.setBookingSource(getColumnString(rs, "booking_source"));
        r.setGuestName(getColumnString(rs, "guest_name"));
        r.setStaffAdjustedAt(getColumnString(rs, "staff_adjusted_at"));
        try {
            int adjBy = rs.getInt("staff_adjusted_by");
            if (!rs.wasNull()) {
                r.setStaffAdjustedBy(adjBy);
            }
        } catch (SQLException ignored) {
        }
        try {
            r.setCustomerUsername(rs.getString("customer_username"));
        } catch (SQLException ignored) {
        }
        try {
            r.setTableName(rs.getString("table_name"));
        } catch (SQLException ignored) {
        }

        return r;
    }

    private String getColumnString(ResultSet rs, String column) {
        try {
            return rs.getString(column);
        } catch (SQLException e) {
            return null;
        }
    }

    private String toIso(String dbDateTime) {
        if (dbDateTime == null) {
            return null;
        }
        return dbDateTime.trim().replace(" ", "T");
    }

    // USER BOOK TABLE (legacy)
    public boolean insert(Reservation r) {
        LocalDateTime start = ReservationRules.parseDateTime(r.getReservationStartTime());
        LocalDateTime end = ReservationRules.parseDateTime(r.getReservationEndTime());
        if (end == null && start != null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }
        return insertRange(r.getUserId(), r.getTableId(), start, end, r.getNumberOfPeople()) > 0;
    }

    public List<Reservation> getAll() {
        List<Reservation> list = new ArrayList<>();
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM reservations ORDER BY id DESC");
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        if (ReservationStatus.DONE.equals(status)) {
            status = ReservationStatus.COMPLETED;
        }
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE reservations SET status=? WHERE id=?")
        ) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM reservations WHERE id=?")
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBooking(int id, String reservationTime, int numberOfPeople) {
        return updateBookingRange(id, reservationTime, null, numberOfPeople, 0);
    }

    public boolean updateBookingForUser(
            int id,
            int userId,
            String reservationStart,
            String reservationEnd,
            int numberOfPeople) {

        return updateBookingRange(id, reservationStart, reservationEnd, numberOfPeople, userId);
    }

    public boolean updateBookingForUser(
            int id,
            int userId,
            String reservationTime,
            int numberOfPeople) {

        LocalDateTime start = ReservationRules.parseDateTime(reservationTime);
        LocalDateTime end = start != null ? start.plusHours(ReservationRules.SLOT_DURATION_HOURS) : null;
        String endStr = end != null ? ReservationRules.toDbString(end) : null;
        return updateBookingForUser(id, userId, reservationTime, endStr, numberOfPeople);
    }

    private boolean updateBookingRange(
            int id,
            String startStr,
            String endStr,
            int numberOfPeople,
            int userIdOrZero) {

        LocalDateTime start = ReservationRules.parseDateTime(startStr);
        LocalDateTime end = ReservationRules.parseDateTime(endStr);
        if (end == null && start != null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }
        if (start == null || end == null) {
            return false;
        }

        String validationError = ReservationRules.validateNewBooking(start, end, ReservationRules.now());
        if (validationError != null) {
            return false;
        }

        Reservation existing = findById(id);
        if (existing == null) {
            return false;
        }

        if (hasOverlap(existing.getTableId(), start, end, id)) {
            return false;
        }

        LocalDateTime buffer = ReservationRules.cleaningBufferUntil(end);
        String startDb = ReservationRules.toDbString(start);
        String endDb = ReservationRules.toDbString(end);
        String bufferDb = ReservationRules.toDbString(buffer);

        String sql =
                "UPDATE reservations SET " +
                        "reservation_time=?, reservation_start_time=?, reservation_end_time=?, " +
                        "cleaning_buffer_until=?, number_of_people=? " +
                        "WHERE id=? AND status='PENDING'";

        if (userIdOrZero > 0) {
            sql += " AND user_id=?";
        }

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, startDb);
            ps.setString(2, startDb);
            ps.setString(3, endDb);
            ps.setString(4, bufferDb);
            ps.setInt(5, numberOfPeople);
            ps.setInt(6, id);
            if (userIdOrZero > 0) {
                ps.setInt(7, userIdOrZero);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Reservation> getByUser(int userId) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE user_id = ? ORDER BY id DESC";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertAndGetId(Reservation r) {
        LocalDateTime start = ReservationRules.parseDateTime(r.getReservationStartTime());
        LocalDateTime end = ReservationRules.parseDateTime(r.getReservationEndTime());
        if (end == null && start != null) {
            end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        }
        if (start == null || end == null) {
            return 0;
        }
        return insertRange(r.getUserId(), r.getTableId(), start, end, r.getNumberOfPeople());
    }

    public int insertRange(
            int userId,
            int tableId,
            LocalDateTime start,
            LocalDateTime end,
            int numberOfPeople) {

        LocalDateTime buffer = ReservationRules.cleaningBufferUntil(end);
        String startDb = ReservationRules.toDbString(start);
        String endDb = ReservationRules.toDbString(end);
        String bufferDb = ReservationRules.toDbString(buffer);

        String sql =
                "INSERT INTO reservations(" +
                        "user_id, table_id, reservation_time, reservation_start_time, " +
                        "reservation_end_time, cleaning_buffer_until, number_of_people, status, expired_at" +
                        ") VALUES(?,?,?,?,?,?,?,'PENDING', DATE_ADD(NOW(), INTERVAL 1 DAY))";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            lockTableForBooking(conn, tableId);

            if (hasOverlap(conn, tableId, start, end, 0)) {
                conn.rollback();
                return 0;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, tableId);
                ps.setString(3, startDb);
                ps.setString(4, startDb);
                ps.setString(5, endDb);
                ps.setString(6, bufferDb);
                ps.setInt(7, numberOfPeople);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int id = keys.getInt(1);
                    conn.commit();
                    return id;
                }
            }
            conn.rollback();
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
        return 0;
    }

    /** Legacy point-in-time check */
    public boolean isTableBooked(int tableId, String reservationTime) {
        LocalDateTime start = ReservationRules.parseDateTime(reservationTime);
        if (start == null) {
            return true;
        }
        return hasOverlap(tableId, start, start.plusHours(2), 0);
    }

    public boolean hasOverlap(
            int tableId,
            LocalDateTime start,
            LocalDateTime end,
            int excludeReservationId) {

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            return hasOverlap(conn, tableId, start, end, excludeReservationId);
        } catch (Exception e) {
            e.printStackTrace();
            return true;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private void lockTableForBooking(Connection conn, int tableId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id FROM restaurant_tables WHERE id = ? FOR UPDATE")) {
            ps.setInt(1, tableId);
            ps.executeQuery();
        }
    }

    private boolean hasOverlap(
            Connection conn,
            int tableId,
            LocalDateTime start,
            LocalDateTime end,
            int excludeReservationId) throws SQLException {

        LocalDateTime newBuffer = ReservationRules.cleaningBufferUntil(end);
        String newStart = ReservationRules.toDbString(start);
        String newBufferStr = ReservationRules.toDbString(newBuffer);

        String sql =
                "SELECT id FROM reservations WHERE table_id = ? AND " + ReservationSql.ACTIVE_WHERE +
                        " AND ? < " + ReservationSql.EFFECTIVE_BUFFER +
                        " AND " + ReservationSql.EFFECTIVE_START + " < ?";

        if (excludeReservationId > 0) {
            sql += " AND id <> ?";
        }
        sql += " FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, tableId);
            ps.setString(i++, newStart);
            ps.setString(i++, newBufferStr);
            if (excludeReservationId > 0) {
                ps.setInt(i, excludeReservationId);
            }
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public Reservation findById(int id) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM reservations WHERE id=?")
        ) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void clearFinishedTables() {
        String sql =
                "UPDATE restaurant_tables t " +
                        "JOIN reservations r ON t.id = r.table_id " +
                        "SET t.status='AVAILABLE' " +
                        "WHERE r.status IN ('DONE','COMPLETED')";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public List<ScheduleBlock> getScheduleBlocks(int tableId, int daysAhead) {
        List<ScheduleBlock> blocks = new ArrayList<>();

        String sql =
                "SELECT id, " + ReservationSql.EFFECTIVE_START + " AS eff_start, " +
                        ReservationSql.EFFECTIVE_END + " AS eff_end, " +
                        ReservationSql.EFFECTIVE_BUFFER + " AS eff_buffer " +
                        "FROM reservations " +
                        "WHERE table_id = ? AND " + ReservationSql.ACTIVE_WHERE +
                        " AND " + ReservationSql.EFFECTIVE_START + " < DATE_ADD(NOW(), INTERVAL ? DAY) " +
                        "ORDER BY eff_start";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tableId);
            ps.setInt(2, daysAhead);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int rid = rs.getInt("id");
                String start = toIso(rs.getString("eff_start"));
                String end = toIso(rs.getString("eff_end"));
                String buffer = toIso(rs.getString("eff_buffer"));

                blocks.add(new ScheduleBlock(start, end, ScheduleBlock.TYPE_BOOKED, rid));
                if (end != null && buffer != null && !end.equals(buffer)) {
                    blocks.add(new ScheduleBlock(end, buffer, ScheduleBlock.TYPE_CLEANING, rid));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return blocks;
    }

    public List<String> getActiveReservationTimes(int tableId, int daysAhead) {
        List<String> list = new ArrayList<>();
        for (ScheduleBlock b : getScheduleBlocks(tableId, daysAhead)) {
            if (ScheduleBlock.TYPE_BOOKED.equals(b.getType())) {
                list.add(b.getStart());
            }
        }
        return list;
    }

    public List<String> getFoodsByReservation(int reservationId) {
        List<String> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql =
                    "SELECT p.name, od.quantity " +
                            "FROM order_details od " +
                            "JOIN orders o ON od.order_id = o.id " +
                            "JOIN products p ON od.product_id = p.id " +
                            "WHERE o.reservation_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reservationId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("name") + " x " + rs.getInt("quantity"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertStaffRange(
            int staffUserId,
            int tableId,
            LocalDateTime start,
            LocalDateTime end,
            int numberOfPeople,
            String guestName) {

        int id = insertRange(staffUserId, tableId, start, end, numberOfPeople);
        if (id > 0) {
            finalizeStaffBooking(id, guestName);
        }
        return id;
    }

    private void finalizeStaffBooking(int reservationId, String guestName) {
        String guest = guestName != null ? guestName.trim() : "";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE reservations SET status='CONFIRMED', booking_source='STAFF', guest_name=? " +
                                "WHERE id=?")
        ) {
            ps.setString(1, guest.isEmpty() ? null : guest);
            ps.setInt(2, reservationId);
            ps.executeUpdate();
        } catch (Exception e) {
            try (
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "UPDATE reservations SET status='CONFIRMED' WHERE id=?")
            ) {
                ps.setInt(1, reservationId);
                ps.executeUpdate();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }


    public boolean adjustReservationEnd(int reservationId, LocalDateTime newEnd, int staffUserId) {
        Reservation existing = findById(reservationId);
        if (existing == null) {
            return false;
        }
        if ("CANCELLED".equals(existing.getStatus())) {
            return false;
        }

        LocalDateTime start = ReservationRules.parseDateTime(existing.getReservationStartTime());
        LocalDateTime oldEnd = ReservationRules.parseDateTime(existing.getReservationEndTime());
        if (start == null || oldEnd == null || newEnd == null) {
            return false;
        }

        LocalDateTime minEnd = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        if (newEnd.isBefore(minEnd) || newEnd.isAfter(oldEnd)) {
            return false;
        }
        long hours = java.time.Duration.between(start, newEnd).toHours();
        if (hours % ReservationRules.SLOT_DURATION_HOURS != 0) {
            return false;
        }

        if (hasOverlap(existing.getTableId(), start, newEnd, reservationId)) {
            return false;
        }

        LocalDateTime buffer = ReservationRules.cleaningBufferUntil(newEnd);
        String endDb = ReservationRules.toDbString(newEnd);
        String bufferDb = ReservationRules.toDbString(buffer);

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE reservations SET reservation_end_time=?, cleaning_buffer_until=?, " +
                                "staff_adjusted_at=NOW(), staff_adjusted_by=? " +
                                "WHERE id=? AND status NOT IN ('CANCELLED')")
        ) {
            ps.setString(1, endDb);
            ps.setString(2, bufferDb);
            ps.setInt(3, staffUserId);
            ps.setInt(4, reservationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            try (
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                            "UPDATE reservations SET reservation_end_time=?, cleaning_buffer_until=? " +
                                    "WHERE id=? AND status NOT IN ('CANCELLED')")
            ) {
                ps.setString(1, endDb);
                ps.setString(2, bufferDb);
                ps.setInt(3, reservationId);
                return ps.executeUpdate() > 0;
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return false;
    }

    public List<Reservation> findByDate(String dateYmd) {
        List<Reservation> list = new ArrayList<>();
        String sql =
                "SELECT r.*, u.username AS customer_username, t.name AS table_name " +
                        "FROM reservations r " +
                        "LEFT JOIN users u ON r.user_id = u.id " +
                        "LEFT JOIN restaurant_tables t ON r.table_id = t.id " +
                        "WHERE DATE(r.reservation_start_time) = ? " +
                        "AND r.status <> 'CANCELLED' " +
                        "ORDER BY r.reservation_start_time, r.table_id";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, dateYmd);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Reservation> findByTableAndDate(int tableId, String dateYmd) {
        List<Reservation> list = new ArrayList<>();
        String sql =
                "SELECT r.*, u.username AS customer_username, t.name AS table_name " +
                        "FROM reservations r " +
                        "LEFT JOIN users u ON r.user_id = u.id " +
                        "LEFT JOIN restaurant_tables t ON r.table_id = t.id " +
                        "WHERE r.table_id = ? AND DATE(r.reservation_start_time) = ? " +
                        "AND r.status <> 'CANCELLED' " +
                        "ORDER BY r.reservation_start_time";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, tableId);
            ps.setString(2, dateYmd);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
