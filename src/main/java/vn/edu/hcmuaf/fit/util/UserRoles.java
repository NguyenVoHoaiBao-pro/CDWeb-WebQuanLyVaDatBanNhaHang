package vn.edu.hcmuaf.fit.util;

public final class UserRoles {

    public static final String USER = "USER";
    public static final String STAFF = "STAFF";
    public static final String ADMIN = "ADMIN";

    private UserRoles() {
    }

    public static boolean isStaffRole(String role) {
        return STAFF.equals(role);
    }

    public static boolean isAdminRole(String role) {
        return ADMIN.equals(role);
    }

    public static boolean isCustomerRole(String role) {
        return USER.equals(role) || role == null;
    }

    public static String nextRole(String current) {
        if (ADMIN.equals(current)) {
            return USER;
        }
        if (STAFF.equals(current)) {
            return ADMIN;
        }
        return STAFF;
    }

    public static String label(String role) {
        if (ADMIN.equals(role)) {
            return "Quản trị";
        }
        if (STAFF.equals(role)) {
            return "Nhân viên";
        }
        return "Khách hàng";
    }
}
