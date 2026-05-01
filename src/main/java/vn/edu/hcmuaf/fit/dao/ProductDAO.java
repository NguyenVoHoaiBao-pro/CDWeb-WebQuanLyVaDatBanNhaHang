package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setImage(rs.getString("image"));
                p.setCategory(rs.getString("category"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Product findById(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement("SELECT * FROM products WHERE id=?")
        ) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setImage(rs.getString("image"));
                p.setCategory(rs.getString("category"));

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

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

    public boolean delete(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement("DELETE FROM products WHERE id=?")
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}