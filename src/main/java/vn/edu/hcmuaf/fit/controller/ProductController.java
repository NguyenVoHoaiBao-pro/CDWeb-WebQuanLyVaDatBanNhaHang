package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmuaf.fit.dao.ProductDAO;

@Controller
public class ProductController {

    private ProductDAO dao = new ProductDAO();

    @GetMapping("/menu")
    public String menu(Model model) {

        // Lấy danh sách sản phẩm
        model.addAttribute("list", dao.getAll());

        // Trả về view
        return "product/menu"; // => /WEB-INF/views/product/menu.jsp
    }
}
