package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // LẤY TẤT CẢ MÓN ĂN
    public List<Product> getAll() {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products ORDER BY id DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // THÊM MÓN
    public boolean insert(Product p) {

        String sql =
                "INSERT INTO products(name,price,description,image,category) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setString(5, p.getCategory());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // CẬP NHẬT
    public boolean update(Product p) {

        String sql =
                "UPDATE products SET name=?,price=?,description=?,image=?,category=? WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setString(5, p.getCategory());
            ps.setInt(6, p.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // XOÁ
    public boolean delete(int id) {

        String sql = "DELETE FROM products WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // TÌM THEO ID
    public Product findById(int id) {

        String sql = "SELECT * FROM products WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapProduct(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // THEO DANH MỤC
    public List<Product> findByCategory(String category) {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products WHERE category=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, category);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // TÌM KIẾM
    public List<Product> search(String keyword) {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products WHERE name LIKE ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // TOP MÓN NỔI BẬT
    public List<Product> getTop6() {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products ORDER BY RAND() LIMIT 6";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // MAP OBJECT
    private Product mapProduct(ResultSet rs) throws SQLException {

        Product p = new Product();

        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        p.setDescription(rs.getString("description"));

        String image = rs.getString("image");
        if (image == null || image.trim().isEmpty()) {
            image = "default.jpg";
        }

        p.setImage(image);
        p.setCategory(rs.getString("category"));

        return p;
    }
}