package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.Product;

import java.util.Collections;
import java.util.List;

@Controller
public class HomeController {

    private final ProductDAO dao = new ProductDAO();

    @GetMapping("/")
    public String home(Model model) {

        List<Product> list = dao.getAll();
        Collections.shuffle(list);

        int total = Math.min(list.size(), 12);

        model.addAttribute("list", list);
        model.addAttribute("total", total);

        return "home";
    }
}
