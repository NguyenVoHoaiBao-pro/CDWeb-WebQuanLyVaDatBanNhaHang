package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.util.ConfigLoader;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL = ConfigLoader.get("db.url");
    private static final String USER = ConfigLoader.get("db.user");
    private static final String PASSWORD = ConfigLoader.get("db.password");

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi kết nối DB", e);
        }
    }
}