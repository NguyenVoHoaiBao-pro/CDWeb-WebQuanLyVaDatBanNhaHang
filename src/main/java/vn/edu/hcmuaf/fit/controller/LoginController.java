package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    UserDAO userDAO = new UserDAO();

    // ===== LOGIN =====
    @GetMapping("/login")
    public String showLogin() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model,
                        HttpSession session) {

        User user = userDAO.login(username, password);

        if (user != null) {
            new UserDAO().ensureIdentityColumns();
            session.setAttribute("user", user);

            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/admin";
            }
            if ("STAFF".equals(user.getRole())) {
                return "redirect:/staff";
            }

            return "redirect:/";
        }

        model.addAttribute("error", "Sai tài khoản!");
        return "login";
    }


    // ===== REGISTER =====
    @GetMapping("/register")
    public String showRegister() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String fullName,
                           @RequestParam String email,
                           Model model) {

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);

        boolean result = userDAO.register(user);

        if (result) {
            return "redirect:/login?registered=true";
        } else {
            model.addAttribute("error", "Đăng ký thất bại!");
            return "register";
        }
    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}