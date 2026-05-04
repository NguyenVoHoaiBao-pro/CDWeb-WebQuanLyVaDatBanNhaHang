// FILE: src/main/java/vn/edu/hcmuaf/fit/controller/ProductController.java
// NÂNG CẤP từ code hiện tại của bạn

package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.Product;

import java.util.List;

@Controller
public class ProductController {

    private ProductDAO dao = new ProductDAO();

    // =====================================
    // MENU CHÍNH
    // /menu
    // /menu?category=MÓN CHÍNH
    // /menu?keyword=bò
    // =====================================
    @GetMapping("/menu")
    public String menu(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<Product> list;

        // SEARCH
        if(keyword != null && !keyword.trim().isEmpty()){

            list = dao.search(keyword.trim());

        }
        // FILTER CATEGORY
        else if(category != null && !category.trim().isEmpty()){

            list = dao.findByCategory(category);

        }
        // ALL
        else{

            list = dao.getAll();
        }

        model.addAttribute("list", list);
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);

        return "product/menu";
    }

    // =====================================
    // ALIAS /products -> dùng chung
    // =====================================
    @GetMapping("/products")
    public String products(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            Model model){

        return menu(category, keyword, model);
    }

    // =====================================
    // CHI TIẾT MÓN
    // /product/5
    // =====================================
    @GetMapping("/product/{id}")
    public String detail(@PathVariable int id,
                         Model model) {

        Product p = dao.findById(id);

        if (p == null) {
            return "redirect:/menu";
        }

        model.addAttribute("product", p);

        // gợi ý cùng category trước
        List<Product> suggest =
                dao.findByCategory(p.getCategory());

        // nếu ít quá thì lấy all
        if(suggest == null || suggest.size() <= 1){
            suggest = dao.getAll();
        }

        model.addAttribute("suggest", suggest);

        return "product/detail";
    }
}