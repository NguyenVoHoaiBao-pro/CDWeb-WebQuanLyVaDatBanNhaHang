package vn.edu.hcmuaf.fit.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    // TOTAL USERS
    public int countUsers() {
        return count("SELECT COUNT(*) FROM users");
    }

    // TOTAL PRODUCTS
    public int countProducts() {
        return count("SELECT COUNT(*) FROM products");
    }

    // TOTAL TABLES
    public int countTables() {
        return count("SELECT COUNT(*) FROM restaurant_tables");
    }

    // TOTAL RESERVATIONS
    public int countReservations() {
        return count("SELECT COUNT(*) FROM reservations");
    }

    // TOTAL ORDERS
    public int countOrders() {
        return count("SELECT COUNT(*) FROM orders");
    }

    // PENDING RESERVATIONS
    public int countPendingReservations() {
        return count(
                "SELECT COUNT(*) FROM reservations WHERE status='PENDING'"
        );
    }

    // COMMON METHOD
    private int count(String sql) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}