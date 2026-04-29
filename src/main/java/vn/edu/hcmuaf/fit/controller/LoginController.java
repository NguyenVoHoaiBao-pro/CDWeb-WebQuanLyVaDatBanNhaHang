package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;

@Controller
public class LoginController {

    UserDAO userDAO = new UserDAO();

    @GetMapping("/login")
    public String showLogin() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model) {

        User user = userDAO.login(username, password);

        if (user != null) {
            return "home";
        } else {
            model.addAttribute("error", "Sai tài khoản!");
            return "login";
        }
    }
}