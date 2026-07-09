package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.OrderDetail;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Reservation;

import java.sql.*;
import java.util.ArrayList;
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

                // KHÔNG CHO > 5
                if(p.getQuantity() > 5){

                    conn.rollback();

                    return 0;
                }

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

            String payStatus = "UNPAID";
            if (payment != null && (payment.startsWith("ONLINE_") || "DEPOSIT".equals(payment))) {
                payStatus = "PAID";
            }
            orderPs.setString(4, payStatus);

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

            if ("STAFF_BILL".equals(payment)) {
                attachStaffBillMeta(conn, orderId);
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

            String resStatus = "WAITING_PAYMENT";
            if ("DEPOSIT".equals(payment) || "STAFF_BILL".equals(payment) || (payment != null && payment.startsWith("ONLINE_"))) {
                resStatus = "CONFIRMED";
            }
            reservationPs.setString(1, resStatus);

            reservationPs.setString(2, note != null ? note : "");
            reservationPs.setString(3, payment != null ? payment : "COD");
            reservationPs.setDouble(4, total);
            reservationPs.setInt(5, reservationId);

            reservationPs.executeUpdate();

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

    /** Nhân viên: không chọn hình thức thanh toán — chỉ xuất hóa đơn tại quầy. */
    public int staffCheckout(int staffUserId, int reservationId, String note) {
        return checkout(staffUserId, reservationId, "STAFF_BILL", note);
    }

    private void attachStaffBillMeta(Connection conn, int orderId) throws SQLException {
        String code = "NHCT-" + orderId + "-" + System.currentTimeMillis() % 100000;
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE orders SET bill_code=?, order_channel='STAFF' WHERE id=?")) {
            ps.setString(1, code);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE orders SET bill_code=? WHERE id=?")) {
                ps.setString(1, code);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }
        }
    }

    public Order findById(int orderId) {
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE id=?")
        ) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapOrder(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setReservationId(rs.getInt("reservation_id"));
        order.setTotal(rs.getDouble("total"));
        order.setPaymentStatus(rs.getString("payment_status"));
        try {
            order.setBillCode(rs.getString("bill_code"));
            order.setOrderChannel(rs.getString("order_channel"));
            order.setCreatedAt(rs.getString("created_at"));
        } catch (SQLException ignored) {
        }
        return order;
    }

    public Order getBill(int reservationId){

        Order order = null;

        try(
                Connection conn =
                        DBConnection.getConnection()
        ){

            String sql =
                    "SELECT * FROM orders " +
                            "WHERE reservation_id=? " +
                            "ORDER BY id DESC LIMIT 1";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, reservationId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                order = mapOrder(rs);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return order;
    }
    public List<OrderDetail> getBillDetails(
            int reservationId
    ){

        List<OrderDetail> list =
                new ArrayList<>();

        try(
                Connection conn =
                        DBConnection.getConnection()
        ){

            String sql =
                    "SELECT " +
                            "od.*, " +
                            "p.name " +
                            "FROM order_details od " +
                            "JOIN orders o " +
                            "ON od.order_id = o.id " +
                            "JOIN products p " +
                            "ON od.product_id = p.id " +
                            "WHERE o.reservation_id=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, reservationId);

            ResultSet rs =
                    ps.executeQuery();

            while(rs.next()){

                OrderDetail d =
                        new OrderDetail();

                d.setId(
                        rs.getInt("id")
                );

                d.setOrderId(
                        rs.getInt("order_id")
                );

                d.setProductId(
                        rs.getInt("product_id")
                );

                d.setQuantity(
                        rs.getInt("quantity")
                );

                d.setPrice(
                        rs.getDouble("price")
                );

                // tên món
                d.setProductName(
                        rs.getString("name")
                );

                list.add(d);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    public Order getByReservationId(int reservationId){

        String sql =
                "SELECT * FROM orders WHERE reservation_id=?";

        try(
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ){

            ps.setInt(1, reservationId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                Order o = new Order();

                o.setId(rs.getInt("id"));

                o.setUserId(rs.getInt("user_id"));

                o.setReservationId(
                        rs.getInt("reservation_id")
                );

                o.setTotal(rs.getDouble("total"));

                o.setPaymentStatus(
                        rs.getString("payment_status")
                );

                return o;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return null;
    }
}