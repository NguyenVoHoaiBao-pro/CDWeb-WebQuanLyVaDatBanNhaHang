package vn.edu.hcmuaf.fit.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean checkPassword(String password, String hashed) {
        if (password == null || hashed == null) {
            return false;
        }
        hashed = hashed.trim();
        if (hashed.startsWith("$2a$") || hashed.startsWith("$2b$") || hashed.startsWith("$2y$")) {
            try {
                return BCrypt.checkpw(password, hashed);
            } catch (IllegalArgumentException e) {
                // trong trường hợp ko thể check, sử dụng so sánh trực tiếp
                return password.equals(hashed);
            }
        }
        return password.equals(hashed);
    }
}