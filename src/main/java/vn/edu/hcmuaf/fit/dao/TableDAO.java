// FILE: src/main/java/vn/edu/hcmuaf/fit/dao/TableDAO.java
// FULL CHUẨN - GIỮ CODE CỦA BẠN + THÊM findById()

package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.RestaurantTable;

import java.sql.*;
import java.util.*;

public class TableDAO {

    // ==========================
    // GET ALL TABLES
    // ==========================
    public List<RestaurantTable> getAll() {

        List<RestaurantTable> list = new ArrayList<>();

        String sql =
                "SELECT * FROM restaurant_tables ORDER BY id";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                RestaurantTable t = new RestaurantTable();

                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ==========================
    // FIND BY ID
    // ==========================
    public RestaurantTable findById(int id) {

        String sql =
                "SELECT * FROM restaurant_tables WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                RestaurantTable t = new RestaurantTable();

                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));

                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ==========================
    // ADD TABLE
    // ==========================
    public boolean insert(String name, int capacity) {

        String sql =
                "INSERT INTO restaurant_tables(name,capacity,status) VALUES(?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, name);
            ps.setInt(2, capacity);
            ps.setString(3, "AVAILABLE");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==========================
    // UPDATE STATUS
    // ==========================
    public boolean updateStatus(int id, String status) {

        String sql =
                "UPDATE restaurant_tables SET status=? WHERE id=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==========================
    // DELETE TABLE
    // ==========================
    public boolean delete(int id) {

        String sql =
                "DELETE FROM restaurant_tables WHERE id=?";

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
}