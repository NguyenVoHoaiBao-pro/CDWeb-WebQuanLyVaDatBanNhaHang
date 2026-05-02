package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.*;
import vn.edu.hcmuaf.fit.model.*;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    ProductDAO productDAO = new ProductDAO();
    UserDAO userDAO = new UserDAO();
    TableDAO tableDAO = new TableDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    AdminDAO adminDAO = new AdminDAO();


    @GetMapping("")
    public String dashboard(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("totalUsers", adminDAO.countUsers());
        model.addAttribute("totalProducts", adminDAO.countProducts());
        model.addAttribute("totalTables", adminDAO.countTables());
        model.addAttribute("totalReservations", adminDAO.countReservations());

        model.addAttribute("page", "dashboard.jsp");
        return "admin/layout";
    }

    @GetMapping("/products")
    public String products(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", productDAO.getAll());

        model.addAttribute("page", "products.jsp"); // 🔥 QUAN TRỌNG

        return "admin/layout"; // 🔥 CHỈ TRẢ VỀ LAYOUT
    }

    @GetMapping("/add-product")
    public String showAddProduct(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("page", "add-product.jsp");
        return "admin/layout";
    }

    @PostMapping("/add-product")
    public String addProduct(
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam String description,
            @RequestParam String image,
            @RequestParam String category,
            Model model,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (name == null || name.trim().isEmpty() || price <= 0) {
            model.addAttribute("page", "add-product.jsp");
            return "admin/layout";
        }

        Product p = new Product();
        p.setName(name);
        p.setPrice(price);
        p.setDescription(description);
        p.setImage(image);
        p.setCategory(category);

        productDAO.insert(p);

        return "redirect:/admin/products";
    }

    @GetMapping("/delete-product/{id}")
    public String deleteProduct(@PathVariable int id, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        Product p = productDAO.findById(id);

        if (p != null) {
            productDAO.delete(id);
        }

        return "redirect:/admin/products";
    }

    @GetMapping("/users")
    public String users(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", userDAO.getAll());
        model.addAttribute("page", "users.jsp");
        return "admin/layout";
    }

    @GetMapping("/delete-user/{id}")
    public String deleteUser(@PathVariable int id, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        userDAO.delete(id);

        return "redirect:/admin/users";
    }

    @GetMapping("/change-role/{id}")
    public String changeRole(@PathVariable int id, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        User current = (User) session.getAttribute("user");

        if (current != null && current.getId() != id) {
            userDAO.changeRole(id);
        }

        return "redirect:/admin/users";
    }

    @GetMapping("/tables")
    public String tables(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", tableDAO.getAll());
        model.addAttribute("page", "tables.jsp");
        return "admin/layout";
    }

    @GetMapping("/change-table/{id}/{status}")
    public String changeTable(
            @PathVariable int id,
            @PathVariable String status,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (!status.equals("AVAILABLE") && !status.equals("RESERVED")) {
            return "redirect:/admin/tables";
        }

        tableDAO.updateStatus(id, status);

        return "redirect:/admin/tables";
    }

    @GetMapping("/reservations")
    public String reservations(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", reservationDAO.getAll());
        model.addAttribute("page", "reservations.jsp");
        return "admin/layout";
    }

    @GetMapping("/reservation/{id}/{status}")
    public String updateReservation(
            @PathVariable int id,
            @PathVariable String status,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (!status.equals("PENDING") &&
                !status.equals("CONFIRMED") &&
                !status.equals("DONE") &&
                !status.equals("CANCELLED")) {
            return "redirect:/admin/reservations";
        }

        reservationDAO.updateStatus(id, status);

        return "redirect:/admin/reservations";
    }
    @GetMapping("/add-table")
    public String addTablePage(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("page", "add-table.jsp");
        return "admin/layout";
    }

    @PostMapping("/add-table")
    public String addTable(
            @RequestParam String name,
            @RequestParam int capacity,
            Model model,
            HttpSession session
    ) {
        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (name == null || name.trim().isEmpty() || capacity <= 0) {
            model.addAttribute("page", "add-table.jsp");
            return "admin/layout";
        }

        tableDAO.insert(name, capacity);

        return "redirect:/admin/tables";
    }
    @GetMapping("/search-product")
    public String searchProduct(
            @RequestParam(required = false) String keyword,
            Model model,
            HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (keyword == null || keyword.trim().isEmpty()) {
            model.addAttribute("list", productDAO.getAll());
        } else {
            model.addAttribute("list", productDAO.search(keyword));
        }

        model.addAttribute("page", "products.jsp");
        return "admin/layout";
    }


}