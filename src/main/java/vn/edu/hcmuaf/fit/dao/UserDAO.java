package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.User;
import java.sql.*;
import java.util.*;

public class UserDAO {

    // LOGIN
    public User login(String username, String password) {

        String sql = "SELECT * FROM users WHERE username=? AND password=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // REGISTER
    public boolean register(User u) {

        String sql =
                "INSERT INTO users(username,password,full_name,email,role) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getEmail());
            ps.setString(5, "USER");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ADMIN GET ALL USERS
    public List<User> getAll() {

        List<User> list = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement("SELECT * FROM users ORDER BY id DESC");
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapUser(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // DELETE USER
    public boolean delete(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement("DELETE FROM users WHERE id=?")
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // TOGGLE ROLE
    public boolean changeRole(int id) {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps1 =
                        conn.prepareStatement("SELECT role FROM users WHERE id=?")
        ) {

            ps1.setInt(1, id);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");
                String newRole = role.equals("ADMIN") ? "USER" : "ADMIN";

                PreparedStatement ps2 =
                        conn.prepareStatement("UPDATE users SET role=? WHERE id=?");

                ps2.setString(1, newRole);
                ps2.setInt(2, id);

                return ps2.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public User findByUsername(String username) {

        String sql = "SELECT * FROM users WHERE username=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public User findByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email=?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // MAP USER
    private User mapUser(ResultSet rs) throws Exception {

        User u = new User();

        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));

        return u;
    }
}