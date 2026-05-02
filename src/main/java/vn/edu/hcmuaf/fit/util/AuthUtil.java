package vn.edu.hcmuaf.fit.util;

import vn.edu.hcmuaf.fit.model.User;
import javax.servlet.http.HttpSession;

public class AuthUtil {

    public static boolean isAdmin(HttpSession session) {
        User u = (User) session.getAttribute("user");
        return u != null && "ADMIN".equals(u.getRole());
    }
}