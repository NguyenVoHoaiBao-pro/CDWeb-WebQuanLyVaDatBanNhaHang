package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.edu.hcmuaf.fit.dao.ProductDAO;


@Controller
public class ProductController {

    private ProductDAO dao = new ProductDAO();

    @GetMapping("/menu")
    public String menu(
            @RequestParam(required = false) String category,
            Model model) {

        if (category != null && !category.isEmpty()) {
            model.addAttribute("list", dao.findByCategory(category));
        } else {
            model.addAttribute("list", dao.getAll());
        }

        return "product/menu";
    }

}
