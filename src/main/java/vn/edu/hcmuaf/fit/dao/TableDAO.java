package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.RestaurantTable;

import java.sql.*;
import java.util.*;

public class TableDAO {

    public List<RestaurantTable> getAll() {

        ensurePriceColumn();
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
                t.setFloorNumber(rs.getInt("floor_number"));
                t.setPrice(rs.getDouble("price"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public RestaurantTable findById(int id) {

        ensurePriceColumn();
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
                t.setFloorNumber(rs.getInt("floor_number"));
                t.setPrice(rs.getDouble("price"));

                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private void ensurePriceColumn() {
        try (Connection conn = DBConnection.getConnection()) {
            // 1. Create table if not exists
            try (Statement st = conn.createStatement()) {
                st.executeUpdate("CREATE TABLE IF NOT EXISTS restaurant_tables (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "name VARCHAR(100) NOT NULL, " +
                        "capacity INT DEFAULT 2, " +
                        "status VARCHAR(50) DEFAULT 'AVAILABLE', " +
                        "floor_number INT DEFAULT 1, " +
                        "position_x INT DEFAULT 0, " +
                        "position_y INT DEFAULT 0" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 2. Ensure price column exists
            DatabaseMetaData meta = conn.getMetaData();
            try (ResultSet rs = meta.getColumns(null, null, "restaurant_tables", "price")) {
                if (!rs.next()) {
                    try (Statement st = conn.createStatement()) {
                        st.executeUpdate("ALTER TABLE restaurant_tables ADD COLUMN price DOUBLE DEFAULT 0");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insert(String name,
                          int capacity,
                          int floorNumber,
                          double price) {

        ensurePriceColumn();
        String sql =
                "INSERT INTO restaurant_tables(name,capacity,status,floor_number,price) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, name);
            ps.setInt(2, capacity);
            ps.setString(3, "AVAILABLE");
            ps.setInt(4, floorNumber);
            ps.setDouble(5, price);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

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
    public List<RestaurantTable> getByFloor(int floor){

        List<RestaurantTable> list =
                new ArrayList<>();

        String sql =
                "SELECT * FROM restaurant_tables " +
                        "WHERE floor_number=? " +
                        "ORDER BY id";

        try(
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ){

            ps.setInt(1, floor);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                RestaurantTable t =
                        new RestaurantTable();

                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));

                t.setFloorNumber(
                        rs.getInt("floor_number")
                );

                list.add(t);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }

    public void normalizeOperationalStatus() {
        String sql =
                "UPDATE restaurant_tables SET status='AVAILABLE' " +
                        "WHERE status='RESERVED' OR status IS NULL OR status=''";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}