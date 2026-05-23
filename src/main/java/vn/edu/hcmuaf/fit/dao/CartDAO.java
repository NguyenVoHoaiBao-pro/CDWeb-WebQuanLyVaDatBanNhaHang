package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // THÊM GIỎ HÀNG (nếu tồn tại thì +1)
    public void add(int userId, int productId, int reservationId) {
        if (!isReservationValid(reservationId)) {
            return;
        }

        String checkSql = "SELECT quantity FROM cart WHERE user_id=? AND product_id=? AND reservation_id=?";
        String insertSql = "INSERT INTO cart(user_id, product_id, quantity, reservation_id) VALUES(?,?,1,?)";
        String updateSql = "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=? AND reservation_id=?";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement check = conn.prepareStatement(checkSql);
            check.setInt(1, userId);
            check.setInt(2, productId);
            check.setInt(3, reservationId);

            ResultSet rs = check.executeQuery();

            if(rs.next()){

                int qty = rs.getInt("quantity");

                // MAX 5
                if(qty >= 5){
                    return;
                }

                String update =
                        "UPDATE cart SET quantity = quantity + 1 " +
                                "WHERE user_id=? AND product_id=? AND reservation_id=?";

                PreparedStatement ups = conn.prepareStatement(update);

                ups.setInt(1, userId);
                ups.setInt(2, productId);
                ups.setInt(3, reservationId);

                ups.executeUpdate();

            }else{

                String insert =
                        "INSERT INTO cart(user_id,product_id,quantity,reservation_id) " +
                                "VALUES(?,?,1,?)";

                PreparedStatement ins = conn.prepareStatement(insert);

                ins.setInt(1, userId);
                ins.setInt(2, productId);
                ins.setInt(3, reservationId);

                ins.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // LẤY GIỎ HÀNG
    public List<Product> getCart(int userId, int reservationId) {

        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "p.id AS product_id, " +
                        "p.name, " +
                        "p.price, " +
                        "p.image, " +
                        "p.description, " +
                        "p.category, " +
                        "c.quantity " +
                        "FROM cart c " +
                        "JOIN products p " +
                        "ON c.product_id = p.id " +
                        "WHERE c.user_id=? " +
                        "AND c.reservation_id=?";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, reservationId);


            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                Product p = new Product();

                p.setId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getString("image"));

                // QUAN TRỌNG
                p.setQuantity(rs.getInt("quantity"));
                System.out.println(
                        p.getName() + " | qty = " + p.getQuantity()
                );



                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // TĂNG SỐ LƯỢNG
    public void increase(int userId, int productId, int reservationId){

        try(Connection conn = DBConnection.getConnection()){

            String checkSql =
                    "SELECT quantity FROM cart " +
                            "WHERE user_id=? AND product_id=? AND reservation_id=?";

            PreparedStatement check = conn.prepareStatement(checkSql);

            check.setInt(1, userId);
            check.setInt(2, productId);
            check.setInt(3, reservationId);

            ResultSet rs = check.executeQuery();

            if(rs.next()){

                int qty = rs.getInt("quantity");

                // GIỚI HẠN MAX = 5
                if(qty >= 5){
                    return;
                }
            }

            String sql =
                    "UPDATE cart " +
                            "SET quantity = quantity + 1 " +
                            "WHERE user_id=? AND product_id=? AND reservation_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, reservationId);

            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    // GIẢM SỐ LƯỢNG

    public void decrease(
            int userId,
            int productId,
            int reservationId
    ){

        try(
                Connection conn =
                        DBConnection.getConnection()
        ){

            String checkSql =
                    "SELECT quantity FROM cart " +
                            "WHERE user_id=? " +
                            "AND product_id=? " +
                            "AND reservation_id=?";

            PreparedStatement check =
                    conn.prepareStatement(checkSql);

            check.setInt(1, userId);
            check.setInt(2, productId);
            check.setInt(3, reservationId);

            ResultSet rs = check.executeQuery();

            if(rs.next()){

                int quantity =
                        rs.getInt("quantity");

                if(quantity <= 1){

                    remove(
                            userId,
                            productId,
                            reservationId
                    );

                }else{

                    String updateSql =
                            "UPDATE cart " +
                                    "SET quantity=quantity-1 " +
                                    "WHERE user_id=? " +
                                    "AND product_id=? " +
                                    "AND reservation_id=?";

                    PreparedStatement update =
                            conn.prepareStatement(updateSql);

                    update.setInt(1, userId);
                    update.setInt(2, productId);
                    update.setInt(3, reservationId);

                    update.executeUpdate();
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    // XÓA 1 MÓN
    public void remove(int userId, int productId, int reservationId) {

        String sql = "DELETE FROM cart WHERE user_id=? AND product_id=? AND reservation_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, reservationId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // XÓA TOÀN BỘ CART
    public void clear(int userId, int reservationId) {

        String sql = "DELETE FROM cart WHERE user_id=? AND reservation_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, reservationId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // XÓA CART CŨ
    public void clearOld() {

        String deleteCart =
                "DELETE c FROM cart c " +
                        "JOIN reservations r ON c.reservation_id = r.id " +
                        "WHERE r.status='PENDING' " +
                        "AND r.expired_at < NOW()";

        String expireReservation =
                "UPDATE reservations " +
                        "SET status='EXPIRED' " +
                        "WHERE status='PENDING' " +
                        "AND expired_at < NOW()";

        try (
                Connection conn = DBConnection.getConnection()
        ) {

            PreparedStatement ps1 =
                    conn.prepareStatement(deleteCart);

            ps1.executeUpdate();

            PreparedStatement ps2 =
                    conn.prepareStatement(expireReservation);

            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Integer getLatestReservationId(int userId) {

        String sql =
                "SELECT id " +
                        "FROM reservations " +
                        "WHERE user_id=? " +
                        "AND status='PENDING' " +
                        "AND expired_at > NOW() " +
                        "ORDER BY id DESC " +
                        "LIMIT 1";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean isReservationValid(Integer reservationId) {
        if (reservationId == null) {
            return false;
        }
        return isReservationValid(reservationId.intValue());
    }

    public boolean isReservationValid(int reservationId){

        String sql =
                "SELECT * FROM reservations " +
                        "WHERE id=? " +
                        "AND status='PENDING' " +
                        "AND expired_at > NOW()";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(1, reservationId);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e){
            e.printStackTrace();
        }

        return false;
    }
    public double getTotal(int userId, int reservationId){

        double total = 0;

        try(Connection conn = DBConnection.getConnection()){

            String sql =
                    "SELECT SUM(c.quantity * p.price) total " +
                            "FROM cart c " +
                            "JOIN products p ON c.product_id = p.id " +
                            "WHERE c.user_id=? AND c.reservation_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, reservationId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                total = rs.getDouble("total");
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return total;
    }
}