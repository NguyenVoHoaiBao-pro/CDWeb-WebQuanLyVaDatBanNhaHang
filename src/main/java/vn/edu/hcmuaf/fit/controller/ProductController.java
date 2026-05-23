// FILE: src/main/java/vn/edu/hcmuaf/fit/controller/ProductController.java
// NÂNG CẤP từ code hiện tại của bạn

package vn.edu.hcmuaf.fit.controller;

import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import vn.edu.hcmuaf.fit.dao.ProductDAO;
import vn.edu.hcmuaf.fit.model.Product;

import java.util.List;

@Controller
public class ProductController {

    private ProductDAO dao = new ProductDAO();
    private final Gson gson = new Gson();

    private List<Product> filterMenu(String category, String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return dao.search(keyword.trim());
        }
        if (category != null && !category.trim().isEmpty()) {
            return dao.findByCategory(category);
        }
        return dao.getAll();
    }

    @GetMapping(value = "/api/menu", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String menuJson(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword) {
        return gson.toJson(filterMenu(category, keyword));
    }

    @GetMapping("/menu")
    public String menu(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<Product> list = filterMenu(category, keyword);

        model.addAttribute("list", list);
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);

        return "product/menu";
    }

    @GetMapping("/products")
    public String products(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            Model model){

        return menu(category, keyword, model);
    }

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