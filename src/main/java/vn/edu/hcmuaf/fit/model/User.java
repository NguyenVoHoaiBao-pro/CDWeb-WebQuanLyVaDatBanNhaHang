package vn.edu.hcmuaf.fit.model;

public class User {

    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;
    private boolean guest;
    /** Đã xác thực danh tính qua bài quiz */
    private boolean identityVerified;
    private String identityVerifiedAt;

    public User() {}

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // ===== getter setter =====
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isGuest() {
        return guest;
    }

    public void setGuest(boolean guest) {
        this.guest = guest;
    }

    public boolean isIdentityVerified() {
        return identityVerified;
    }

    public void setIdentityVerified(boolean identityVerified) {
        this.identityVerified = identityVerified;
    }

    public String getIdentityVerifiedAt() {
        return identityVerifiedAt;
    }

    public void setIdentityVerifiedAt(String identityVerifiedAt) {
        this.identityVerifiedAt = identityVerifiedAt;
    }
}