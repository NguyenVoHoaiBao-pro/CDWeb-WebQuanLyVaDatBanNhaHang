//package vn.edu.hcmuaf.fit.dao;
//
//import vn.edu.hcmuaf.fit.model.RestaurantTable;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class TableDAO {
//
//    public List<RestaurantTable> getAll() {
//        List<RestaurantTable> list = new ArrayList<>();
//        String sql = "SELECT * FROM restaurant_tables";
//
//        try (Connection conn = DBConnection.getConnection();
//             Statement st = conn.createStatement();
//             ResultSet rs = st.executeQuery(sql)) {
//
//            while (rs.next()) {
//                RestaurantTable t = new RestaurantTable();
//                t.setId(rs.getInt("id"));
//                t.setName(rs.getString("name"));
//                t.setFloor(rs.getInt("floor"));
//                t.setStatus(rs.getString("status"));
//                list.add(t);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//
//    public void insert(String name, int floor) {
//        String sql = "INSERT INTO restaurant_tables(name, floor, status) VALUES (?, ?, 'AVAILABLE')";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, name);
//            ps.setInt(2, floor);
//            ps.executeUpdate();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    public void updateStatus(int id, String status) {
//        String sql = "UPDATE restaurant_tables SET status=? WHERE id=?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, status);
//            ps.setInt(2, id);
//            ps.executeUpdate();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//}
package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.RestaurantTable;
import java.sql.*;
import java.util.*;

public class TableDAO {

    // GET ALL TABLES
    public List<RestaurantTable> getAll() {

        List<RestaurantTable> list = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement("SELECT * FROM restaurant_tables ORDER BY id");
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

    // ADD TABLE
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

    // UPDATE STATUS
    public boolean updateStatus(int id, String status) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                "UPDATE restaurant_tables SET status=? WHERE id=?"
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

    // DELETE TABLE
    public boolean delete(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(
                                "DELETE FROM restaurant_tables WHERE id=?"
                        )
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}