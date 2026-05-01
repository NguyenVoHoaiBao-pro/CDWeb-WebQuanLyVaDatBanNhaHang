package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.Product;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class EditProductController {

    ProductDAO productDAO = new ProductDAO();

    @GetMapping("/edit-product/{id}")
    public String editPage(@PathVariable int id,
                           HttpSession session,
                           Model model) {

        Object user = session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        List<Product> list = productDAO.getAll();

        for (Product p : list) {
            if (p.getId() == id) {
                model.addAttribute("product", p);
                return "admin/edit-product";
            }
        }

        return "redirect:/admin/products";
    }

    @PostMapping("/edit-product")
    public String update(
            @RequestParam int id,
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam String description,
            @RequestParam String image,
            @RequestParam String category,
            HttpSession session) {

        Object user = session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        Product p = new Product();

        p.setId(id);
        p.setName(name);
        p.setPrice(price);
        p.setDescription(description);
        p.setImage(image);
        p.setCategory(category);

        productDAO.update(p);

        return "redirect:/admin/products";
    }
}