// FILE: src/main/java/vn/edu/hcmuaf/fit/dao/OrderDAO.java
// FIX HOÀN CHỈNH + sạch + an toàn + đúng logic

package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.List;

public class OrderDAO {

    CartDAO cartDAO = new CartDAO();

    // ======================================
    // CHECKOUT FULL
    // ======================================
    public int checkout(int userId,
                        int reservationId,   // ✅ thêm dòng này
                        int tableId,
                        String time,
                        int people,
                        String payment,
                        String note) {

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // ========================
            // 1. GET CART
            // ========================
            List<Product> cart = cartDAO.getCart(userId, reservationId);

            if (cart == null || cart.isEmpty()) {
                return 0;
            }

            double total = 0;
            for (Product p : cart) {
                total += p.getPrice() * p.getQuantity();
            }

            // ========================
            // 2. CHECK TABLE AVAILABLE
            // ========================
            PreparedStatement checkTable = conn.prepareStatement(
                    "SELECT id FROM restaurant_tables WHERE id=?"
            );
            checkTable.setInt(1, tableId);
            ResultSet rsTable = checkTable.executeQuery();

            if (!rsTable.next()) {
                conn.rollback();
                return 0;
            }

            // ========================
            // 3. INSERT RESERVATION (🔥 TRƯỚC)
            // ========================
//            String reserveSql =
//                    "INSERT INTO reservations(user_id,table_id,reservation_time,number_of_people,status,note) " +
//                            "VALUES(?,?,?,?,?,?)";
//
//            PreparedStatement reservePs =
//                    conn.prepareStatement(reserveSql, Statement.RETURN_GENERATED_KEYS);
//
//            reservePs.setInt(1, userId);
//            reservePs.setInt(2, tableId);
//            reservePs.setString(3, time.replace("T", " "));
//            reservePs.setInt(4, people);
//            reservePs.setString(5,
//                    payment.equals("DEPOSIT") ? "CONFIRMED" : "PENDING");
//            reservePs.setString(6, note);
//
//            reservePs.executeUpdate();
//
//            ResultSet rsRes = reservePs.getGeneratedKeys();
//            int reservationId = 0;
//
//            if (rsRes.next()) {
//                reservationId = rsRes.getInt(1);
//            }
//
//            if (reservationId == 0) {
//                conn.rollback();
//                return 0;
//            }

            // ========================
            // 4. INSERT ORDER (🔥 GẮN reservation_id)
            // ========================
            String orderSql =
                    "INSERT INTO orders(user_id,reservation_id,total,created_at,payment_status) " +
                            "VALUES(?,?,?,?,?)";

            PreparedStatement orderPs =
                    conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);

            orderPs.setInt(1, userId);
            orderPs.setInt(2, reservationId);
            orderPs.setDouble(3, total);
            orderPs.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            orderPs.setString(5,
                    payment.equals("DEPOSIT") ? "PAID" : "UNPAID");

            orderPs.executeUpdate();

            ResultSet rsOrder = orderPs.getGeneratedKeys();
            int orderId = 0;

            if (rsOrder.next()) {
                orderId = rsOrder.getInt(1);
            }

            if (orderId == 0) {
                conn.rollback();
                return 0;
            }

            // ========================
            // 5. ORDER DETAILS
            // ========================
            String detailSql =
                    "INSERT INTO order_details(order_id,product_id,quantity,price) VALUES(?,?,?,?)";

            PreparedStatement detailPs =
                    conn.prepareStatement(detailSql);

            for (Product p : cart) {
                detailPs.setInt(1, orderId);
                detailPs.setInt(2, p.getId());
                detailPs.setInt(3, p.getQuantity());
                detailPs.setDouble(4, p.getPrice());
                detailPs.addBatch();
            }

            detailPs.executeBatch();

            // ========================
            // 6. UPDATE TABLE
            // ========================
            PreparedStatement tablePs =
                    conn.prepareStatement(
                            "UPDATE restaurant_tables SET status='RESERVED' WHERE id=?"
                    );

            tablePs.setInt(1, tableId);
//            tablePs.executeUpdate();

            // ========================
            // 7. CLEAR CART
            // ========================
            PreparedStatement clearPs =
                    conn.prepareStatement(
                            "DELETE FROM cart WHERE user_id=? AND reservation_id=?"
                    );

            clearPs.setInt(1, userId);
            clearPs.setInt(2, reservationId);
            clearPs.executeUpdate();

            conn.commit();

            return orderId;

        } catch (Exception e) {

            e.printStackTrace();

            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

        } finally {

            try {
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        return 0;
    }
}