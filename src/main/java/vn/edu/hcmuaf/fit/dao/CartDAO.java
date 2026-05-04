package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // THÊM GIỎ HÀNG (nếu tồn tại thì +1)
    public void add(int userId, int productId, int reservationId) {

        String checkSql = "SELECT quantity FROM cart WHERE user_id=? AND product_id=? AND reservation_id=?";
        String insertSql = "INSERT INTO cart(user_id, product_id, quantity, reservation_id) VALUES(?,?,1,?)";
        String updateSql = "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=? AND reservation_id=?";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement check = conn.prepareStatement(checkSql);
            check.setInt(1, userId);
            check.setInt(2, productId);
            check.setInt(3, reservationId);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {

                PreparedStatement update = conn.prepareStatement(updateSql);
                update.setInt(1, userId);
                update.setInt(2, productId);
                update.setInt(3, reservationId);
                update.executeUpdate();

            } else {

                PreparedStatement insert = conn.prepareStatement(insertSql);
                insert.setInt(1, userId);
                insert.setInt(2, productId);
                insert.setInt(3, reservationId);
                insert.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // LẤY GIỎ HÀNG
    public List<Product> getCart(int userId, int reservationId) {

        List<Product> list = new ArrayList<>();

        String sql =
                "SELECT p.*, c.quantity " +
                        "FROM cart c " +
                        "JOIN products p ON c.product_id = p.id " +
                        "WHERE c.user_id=? AND c.reservation_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, reservationId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getString("image"));
                p.setQuantity(rs.getInt("quantity"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // TĂNG SỐ LƯỢNG
    public void increase(int userId, int productId, int reservationId) {

        String sql = "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=? AND reservation_id=?";

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

    // GIẢM SỐ LƯỢNG
    public void decrease(int userId, int productId, int reservationId) {

        String sql = "UPDATE cart SET quantity = quantity - 1 WHERE user_id=? AND product_id=? AND reservation_id=? AND quantity > 1";

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

        String sql = "DELETE FROM cart WHERE created_at < NOW() - INTERVAL 1 DAY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Integer getLatestReservationId(int userId) {

        String sql = "SELECT id FROM reservations WHERE user_id=? ORDER BY id DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
}