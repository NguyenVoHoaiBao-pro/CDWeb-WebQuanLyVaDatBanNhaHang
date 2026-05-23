package vn.edu.hcmuaf.fit.util;

import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

public class AuthUtil {

    private static final UserDAO userDAO = new UserDAO();

    public static boolean isAdmin(HttpSession session) {
        User u = (User) session.getAttribute("user");
        return u != null && UserRoles.isAdminRole(u.getRole());
    }

    public static boolean isStaff(HttpSession session) {
        User u = (User) session.getAttribute("user");
        return u != null && UserRoles.isStaffRole(u.getRole());
    }

    public static boolean isStaffOrAdmin(HttpSession session) {
        return isAdmin(session) || isStaff(session);
    }

    public static boolean isIdentityVerified(User user) {
        if (user == null) {
            return false;
        }
        if (UserRoles.isAdminRole(user.getRole()) || UserRoles.isStaffRole(user.getRole())) {
            return true;
        }
        return user.isIdentityVerified();
    }

    public static User refreshSessionUser(HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) {
            return null;
        }
        User fresh = userDAO.findById(u.getId());
        if (fresh != null) {
            session.setAttribute("user", fresh);
            return fresh;
        }
        return u;
    }

    public static String requireLogin(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return null;
    }

    public static String requireAdmin(HttpSession session) {
        String login = requireLogin(session);
        if (login != null) {
            return login;
        }
        if (!isAdmin(session)) {
            return "redirect:/login?error=forbidden";
        }
        return null;
    }

    public static String requireStaff(HttpSession session) {
        String login = requireLogin(session);
        if (login != null) {
            return login;
        }
        if (!isStaffOrAdmin(session)) {
            return "redirect:/login?error=forbidden";
        }
        return null;
    }

    public static String requireVerified(HttpSession session) {
        String login = requireLogin(session);
        if (login != null) {
            return login;
        }
        User u = refreshSessionUser(session);
        if (UserRoles.isStaffRole(u.getRole()) || UserRoles.isAdminRole(u.getRole())) {
            return null;
        }
        if (!isIdentityVerified(u)) {
            return "redirect:/verify-identity?need=1";
        }
        return null;
    }
}
