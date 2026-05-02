package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    CartDAO dao = new CartDAO();

    @GetMapping("/add/{id}")
    public String add(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");

        if (u == null) return "redirect:/login";

        dao.add(u.getId(), id);

        return "redirect:/cart";
    }

    @GetMapping("")
    public String cart(Model model, HttpSession session) {

        User u = (User) session.getAttribute("user");

        if (u == null) return "redirect:/login";

        dao.clearOld();

        model.addAttribute("list", dao.getCart(u.getId()));

        return "product/cart"; // ✅ FIX Ở ĐÂY
    }
}
