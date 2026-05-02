package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;
import java.sql.*;
import java.util.*;

public class CartDAO {

    public void add(int userId, int productId) {

        String sql = "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Product> getCart(int userId) {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT p.* FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getString("image"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public void clearOld() {

        String sql = "DELETE FROM cart WHERE created_at < NOW() - INTERVAL 1 DAY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
