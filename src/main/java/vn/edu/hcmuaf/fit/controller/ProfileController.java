package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;

@Controller
public class ProfileController {

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        String redirect = AuthUtil.requireLogin(session);
        if (redirect != null) {
            return redirect;
        }
        User user = AuthUtil.refreshSessionUser(session);
        model.addAttribute("user", user);
        model.addAttribute("verified", AuthUtil.isIdentityVerified(user));
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            HttpSession session,
            Model model
    ) {
        String redirect = AuthUtil.requireLogin(session);
        if (redirect != null) {
            return redirect;
        }
        User user = (User) session.getAttribute("user");
        if (fullName == null || fullName.trim().isEmpty()) {
            model.addAttribute("error", "Họ tên không được để trống");
            model.addAttribute("user", user);
            return "profile";
        }
        userDAO.updateProfile(user.getId(), fullName.trim(), email != null ? email.trim() : null);
        AuthUtil.refreshSessionUser(session);
        return "redirect:/profile?saved=1";
    }
}
