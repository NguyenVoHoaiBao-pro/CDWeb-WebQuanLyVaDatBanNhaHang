package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.UserRoles;
import vn.edu.hcmuaf.fit.util.PasswordUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static volatile boolean identitySchemaReady = false;

    public synchronized boolean ensureIdentityColumns() {
        if (identitySchemaReady) {
            return true;
        }
        try (Connection conn = DBConnection.getConnection()) {
            // 1. Create table if not exists
            try (Statement st = conn.createStatement()) {
                st.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "username VARCHAR(100) NOT NULL UNIQUE, " +
                        "password VARCHAR(255) NOT NULL, " +
                        "full_name VARCHAR(255), " +
                        "email VARCHAR(255), " +
                        "role VARCHAR(50) DEFAULT 'USER'" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 2. Ensure identity columns exist
            String[] cols = { "is_guest", "identity_verified", "identity_verified_at" };
            String[] types = {
                    "TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = guest/walk-in'",
                    "TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = da xac thuc danh tinh'",
                    "DATETIME NULL COMMENT 'Thoi diem xac thuc'"
            };

            for (int i = 0; i < cols.length; i++) {
                if (!columnExists(conn, "users", cols[i])) {
                    try (Statement st = conn.createStatement()) {
                        st.executeUpdate("ALTER TABLE users ADD COLUMN " + cols[i] + " " + types[i]);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            // 3. Special initialization for existing staff/admin
            try (Statement st = conn.createStatement()) {
                st.executeUpdate("UPDATE users SET identity_verified=1, identity_verified_at=NOW() " +
                        "WHERE (role='ADMIN' OR role='STAFF') AND identity_verified=0");
            } catch (Exception ignored) {
            }

            identitySchemaReady = true;
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean columnExists(Connection conn, String table, String column) throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        String catalog = conn.getCatalog();
        try (ResultSet rs = meta.getColumns(catalog, null, table, column)) {
            return rs.next();
        }
    }

    private void prepareSchema() {
        ensureIdentityColumns();
    }

    // LOGIN
    public User login(String username, String password) {
        prepareSchema();
        User u = findByUsername(username);
        if (u != null && PasswordUtils.checkPassword(password, u.getPassword())) {
            return u;
        }
        return null;
    }

    // REGISTER
    public boolean register(User u) {
        prepareSchema();
        String sql =
                "INSERT INTO users(username,password,full_name,email,role) VALUES(?,?,?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, u.getUsername());
            ps.setString(2, PasswordUtils.hashPassword(u.getPassword()));
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getEmail());
            ps.setString(5, UserRoles.USER);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAll() {
        prepareSchema();
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
                String newRole = UserRoles.nextRole(role);
                PreparedStatement ps2 =
                        conn.prepareStatement(
                                "UPDATE users SET role=?, identity_verified=? WHERE id=?");
                ps2.setString(1, newRole);
                boolean verified = UserRoles.isAdminRole(newRole) || UserRoles.isStaffRole(newRole);
                ps2.setInt(2, verified ? 1 : 0);
                ps2.setInt(3, id);
                return ps2.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User findByUsername(String username) {
        prepareSchema();
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
        prepareSchema();
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

    public User findById(int id) {
        prepareSchema();
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id=?")
        ) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean setRole(int userId, String role) {
        prepareSchema();
        String sql =
                "UPDATE users SET role=?, identity_verified=? WHERE id=?";
        boolean verified = UserRoles.isAdminRole(role) || UserRoles.isStaffRole(role);
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, role);
            ps.setInt(2, verified ? 1 : 0);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean setIdentityVerified(int userId) {
        if (!ensureIdentityColumns()) {
            return false;
        }
        String sql =
                "UPDATE users SET identity_verified=1, identity_verified_at=NOW() WHERE id=?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isIdentityVerifiedInDb(int userId) {
        prepareSchema();
        String sql = "SELECT identity_verified FROM users WHERE id=?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("identity_verified") == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfile(int userId, String fullName, String email) {
        String sql = "UPDATE users SET full_name=?, email=? WHERE id=?";
        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getOrCreateGuestUser(int tableId, String tableName) {
        prepareSchema();
        String username = "guest_table_" + tableId;
        User u = findByUsername(username);
        if (u != null) {
            return u;
        }

        // Create new guest user
        u = new User();
        u.setUsername(username);
        u.setPassword(PasswordUtils.hashPassword("guest123")); // default password
        u.setFullName(tableName);
        u.setEmail(username + "@restaurant.com");
        u.setRole(UserRoles.GUEST);
        u.setIdentityVerified(true);
        u.setGuest(true);

        String sql = "INSERT INTO users(username, password, full_name, email, role, is_guest, identity_verified, identity_verified_at) VALUES(?,?,?,?,?,1,1,NOW())";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getRole());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    u.setId(keys.getInt(1));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return findByUsername(username); // fallback
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));

        try {
            u.setGuest(rs.getInt("is_guest") == 1);
        } catch (SQLException ignored) {
        }

        try {
            int verified = rs.getInt("identity_verified");
            u.setIdentityVerified(verified == 1);
            u.setIdentityVerifiedAt(rs.getString("identity_verified_at"));
        } catch (SQLException ignored) {
            u.setIdentityVerified(
                    UserRoles.isAdminRole(u.getRole()) || UserRoles.isStaffRole(u.getRole()));
        }

        return u;
    }
}
