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

    public boolean updateBookingForUser(
            int id,
            int userId,
            String reservationTime,
            int numberOfPeople) {

        String sql =
                "UPDATE reservations SET reservation_time=?, number_of_people=? " +
                        "WHERE id=? AND user_id=? AND status='PENDING'";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, reservationTime);
            ps.setInt(2, numberOfPeople);
            ps.setInt(3, id);
            ps.setInt(4, userId);

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

    public int insertAndGetId(Reservation r) {


        String sql =
                "INSERT INTO reservations(" +
                        "user_id," +
                        "table_id," +
                        "reservation_time," +
                        "number_of_people," +
                        "status," +
                        "expired_at" +
                        ") VALUES(?,?,?,?,?,DATE_ADD(NOW(), INTERVAL 1 DAY))";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                sql,
                                Statement.RETURN_GENERATED_KEYS
                        )
        ) {

            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getTableId());
            ps.setString(3, r.getReservationTime());
            ps.setInt(4, r.getNumberOfPeople());

            // CHƯA XÁC NHẬN
            ps.setString(5, "PENDING");

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if(rs.next()){
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    public boolean isTableBooked(
            int tableId,
            String reservationTime
    ){

        String sql =
                "SELECT * FROM reservations " +
                        "WHERE table_id=? " +
                        "AND ABS(TIMESTAMPDIFF(MINUTE, reservation_time, ?)) < 120 " +
                        "AND (" +
                        "status='CONFIRMED' " +
                        "OR status='WAITING_PAYMENT' " +
                        "OR (" +
                        "status='PENDING' " +
                        "AND expired_at > NOW()" +
                        ")" +
                        ")";

        try(
                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ){

            ps.setInt(1, tableId);
            ps.setString(2, reservationTime);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        }catch(Exception e){
            e.printStackTrace();
        }

        return false;
    }
    public Reservation findById(int id){

        String sql =
                "SELECT * FROM reservations WHERE id=?";

        try(
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ){

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                Reservation r = new Reservation();

                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTableId(rs.getInt("table_id"));
                r.setReservationTime(
                        rs.getString("reservation_time")
                );
                r.setNumberOfPeople(
                        rs.getInt("number_of_people")
                );

                r.setStatus(rs.getString("status"));

                return r;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return null;
    }
    public void clearFinishedTables(){

        String sql =
                "UPDATE restaurant_tables t " +
                        "JOIN reservations r " +
                        "ON t.id = r.table_id " +
                        "SET t.status='AVAILABLE' " +
                        "WHERE r.status='DONE'";

        try(
                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ){

            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public List<String> getFoodsByReservation(
            int reservationId
    ){

        List<String> list = new ArrayList<>();

        try(Connection conn =
                    DBConnection.getConnection()){

            String sql =
                    "SELECT " +
                            "p.name, " +
                            "od.quantity " +
                            "FROM order_details od " +
                            "JOIN orders o " +
                            "ON od.order_id = o.id " +
                            "JOIN products p " +
                            "ON od.product_id = p.id " +
                            "WHERE o.reservation_id=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, reservationId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                String item =
                        rs.getString("name")
                                + " x "
                                + rs.getInt("quantity");

                list.add(item);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}