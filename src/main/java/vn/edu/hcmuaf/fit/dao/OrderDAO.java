package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Reservation;

import java.sql.*;
import java.util.List;

public class OrderDAO {

    CartDAO cartDAO = new CartDAO();
    ReservationDAO reservationDAO = new ReservationDAO();

    public int checkout(
            int userId,
            int reservationId,
            String payment,
            String note
    ){

        Connection conn = null;

        try{

            conn = DBConnection.getConnection();

            conn.setAutoCommit(false);

            // =========================
            // GET RESERVATION
            // =========================

            Reservation reservation =
                    reservationDAO.findById(reservationId);

            if(reservation == null){
                return 0;
            }

            // =========================
            // GET CART
            // =========================

            List<Product> cart =
                    cartDAO.getCart(userId, reservationId);

            if(cart == null || cart.isEmpty()){
                return 0;
            }

            // =========================
            // TOTAL
            // =========================

            double total = 0;

            for(Product p : cart){

                total +=
                        p.getPrice() * p.getQuantity();
            }

            // =========================
            // INSERT ORDER
            // =========================

            String orderSql =
                    "INSERT INTO orders(" +
                            "user_id," +
                            "reservation_id," +
                            "total," +
                            "payment_status" +
                            ") VALUES(?,?,?,?)";

            PreparedStatement orderPs =
                    conn.prepareStatement(
                            orderSql,
                            Statement.RETURN_GENERATED_KEYS
                    );

            orderPs.setInt(1, userId);
            orderPs.setInt(2, reservationId);
            orderPs.setDouble(3, total);

            orderPs.setString(
                    4,
                    payment.equals("DEPOSIT")
                            ? "PAID"
                            : "UNPAID"
            );

            orderPs.executeUpdate();

            ResultSet rs =
                    orderPs.getGeneratedKeys();

            int orderId = 0;

            if(rs.next()){
                orderId = rs.getInt(1);
            }

            if(orderId == 0){

                conn.rollback();

                return 0;
            }

            // =========================
            // INSERT ORDER DETAILS
            // =========================

            String detailSql =
                    "INSERT INTO order_details(" +
                            "order_id," +
                            "product_id," +
                            "quantity," +
                            "price" +
                            ") VALUES(?,?,?,?)";

            PreparedStatement detailPs =
                    conn.prepareStatement(detailSql);

            for(Product p : cart){

                detailPs.setInt(1, orderId);
                detailPs.setInt(2, p.getId());
                detailPs.setInt(3, p.getQuantity());
                detailPs.setDouble(4, p.getPrice());

                detailPs.addBatch();
            }

            detailPs.executeBatch();

            // =========================
            // UPDATE RESERVATION
            // =========================

            String reservationSql =
                    "UPDATE reservations " +
                            "SET " +
                            "status=?," +
                            "note=?," +
                            "payment_method=?," +
                            "total=?," +
                            "confirmed_at=NOW() " +
                            "WHERE id=?";

            PreparedStatement reservationPs =
                    conn.prepareStatement(reservationSql);

            reservationPs.setString(
                    1,
                    payment.equals("DEPOSIT")
                            ? "CONFIRMED"
                            : "WAITING_PAYMENT"
            );

            reservationPs.setString(2, note);
            reservationPs.setString(3, payment);
            reservationPs.setDouble(4, total);
            reservationPs.setInt(5, reservationId);

            reservationPs.executeUpdate();

            // =========================
            // UPDATE TABLE
            // =========================

            PreparedStatement tablePs =
                    conn.prepareStatement(
                            "UPDATE restaurant_tables " +
                                    "SET status='RESERVED' " +
                                    "WHERE id=?"
                    );

            tablePs.setInt(1, reservation.getTableId());

            tablePs.executeUpdate();

            // =========================
            // CLEAR CART
            // =========================

            PreparedStatement clearPs =
                    conn.prepareStatement(
                            "DELETE FROM cart " +
                                    "WHERE user_id=? " +
                                    "AND reservation_id=?"
                    );

            clearPs.setInt(1, userId);
            clearPs.setInt(2, reservationId);

            clearPs.executeUpdate();

            conn.commit();

            return orderId;

        }catch(Exception e){

            e.printStackTrace();

            try{
                if(conn != null){
                    conn.rollback();
                }
            }catch(Exception ex){
                ex.printStackTrace();
            }

        }finally{

            try{
                if(conn != null){
                    conn.close();
                }
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }

        return 0;
    }
}