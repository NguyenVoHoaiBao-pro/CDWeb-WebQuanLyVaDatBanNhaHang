package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.Product;


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
    @GetMapping("/product/{id}")
    public String detail(@PathVariable int id, Model model) {

        Product p = dao.findById(id);

        if (p == null) return "redirect:/";

        model.addAttribute("product", p);
        model.addAttribute("suggest", dao.getAll());

        return "product/detail";
    }


}
