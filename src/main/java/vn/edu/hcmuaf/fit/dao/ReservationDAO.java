//package vn.edu.hcmuaf.fit.dao;
//
//import vn.edu.hcmuaf.fit.model.Reservation;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//
//public class ReservationDAO {
//
//    public boolean insert(Reservation r) {
//        String sql = "INSERT INTO reservations(user_id, table_id, reservation_time, number_of_people, status) VALUES (?, ?, ?, ?, ?)";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, r.getUserId());
//            ps.setInt(2, r.getTableId());
//            ps.setString(3, r.getReservationTime());
//            ps.setInt(4, r.getNumberOfPeople());
//            ps.setString(5, "PENDING");
//
//            return ps.executeUpdate() > 0;
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//}
package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Reservation;
import java.sql.*;
import java.util.*;

public class ReservationDAO {

    // USER BOOK TABLE
    public boolean insert(Reservation r) {

        String sql =
                "INSERT INTO reservations(user_id,table_id,reservation_time,number_of_people,status) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getTableId());
            ps.setString(3, r.getReservationTime());
            ps.setInt(4, r.getNumberOfPeople());
            ps.setString(5, "PENDING");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ADMIN VIEW ALL
    public List<Reservation> getAll() {

        List<Reservation> list = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                "SELECT * FROM reservations ORDER BY id DESC"
                        );
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Reservation r = new Reservation();

                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTableId(rs.getInt("table_id"));
                r.setReservationTime(rs.getString("reservation_time"));
                r.setNumberOfPeople(rs.getInt("number_of_people"));
                r.setStatus(rs.getString("status"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // UPDATE STATUS
    public boolean updateStatus(int id, String status) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                "UPDATE reservations SET status=? WHERE id=?"
                        )
        ) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // DELETE RESERVATION
    public boolean delete(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                "DELETE FROM reservations WHERE id=?"
                        )
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateBooking(int id, String reservationTime, int numberOfPeople) {

        String sql = "UPDATE reservations SET reservation_time=?, number_of_people=? WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, reservationTime);
            ps.setInt(2, numberOfPeople);
            ps.setInt(3, id);

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

                Reservation r = new Reservation();

                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTableId(rs.getInt("table_id"));
                r.setReservationTime(rs.getString("reservation_time"));
                r.setNumberOfPeople(rs.getInt("number_of_people"));
                r.setStatus(rs.getString("status"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
//    public int getLastId() {
//
//        String sql = "SELECT MAX(id) FROM reservations";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return 0;
//    }
    public int insertAndGetId(Reservation r) {

        String sql = "INSERT INTO reservations(user_id,table_id,reservation_time,number_of_people,status) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {

            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getTableId());
            ps.setString(3, r.getReservationTime());
            ps.setInt(4, r.getNumberOfPeople());
            ps.setString(5, "PENDING");

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}