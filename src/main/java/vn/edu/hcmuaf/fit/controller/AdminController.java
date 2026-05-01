package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.*;
import vn.edu.hcmuaf.fit.model.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    ProductDAO productDAO = new ProductDAO();
    UserDAO userDAO = new UserDAO();
    TableDAO tableDAO = new TableDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    AdminDAO adminDAO = new AdminDAO();

    private boolean isAdmin(HttpSession session) {
        User u = (User) session.getAttribute("user");
        return u != null && "ADMIN".equals(u.getRole());
    }

    @GetMapping("")
    public String dashboard(Model model, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("totalUsers", adminDAO.countUsers());
        model.addAttribute("totalProducts", adminDAO.countProducts());
        model.addAttribute("totalTables", adminDAO.countTables());
        model.addAttribute("totalReservations", adminDAO.countReservations());

        return "admin/dashboard";
    }

    @GetMapping("/products")
    public String products(Model model, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", productDAO.getAll());

        return "admin/products";
    }

    @GetMapping("/add-product")
    public String showAddProduct(HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        return "admin/add-product";
    }

    @PostMapping("/add-product")
    public String addProduct(
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam String description,
            @RequestParam String image,
            @RequestParam String category,
            HttpSession session
    ) {

        if (!isAdmin(session)) return "redirect:/login";

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

        if (!isAdmin(session)) return "redirect:/login";

        productDAO.delete(id);

        return "redirect:/admin/products";
    }

    @GetMapping("/users")
    public String users(Model model, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", userDAO.getAll());

        return "admin/users";
    }

    @GetMapping("/delete-user/{id}")
    public String deleteUser(@PathVariable int id, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        userDAO.delete(id);

        return "redirect:/admin/users";
    }

    @GetMapping("/change-role/{id}")
    public String changeRole(@PathVariable int id, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        userDAO.changeRole(id);

        return "redirect:/admin/users";
    }

    @GetMapping("/tables")
    public String tables(Model model, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", tableDAO.getAll());

        return "admin/tables";
    }

    @GetMapping("/change-table/{id}/{status}")
    public String changeTable(
            @PathVariable int id,
            @PathVariable String status,
            HttpSession session
    ) {

        if (!isAdmin(session)) return "redirect:/login";

        tableDAO.updateStatus(id, status);

        return "redirect:/admin/tables";
    }

    @GetMapping("/reservations")
    public String reservations(Model model, HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", reservationDAO.getAll());

        return "admin/reservations";
    }

    @GetMapping("/reservation/{id}/{status}")
    public String updateReservation(
            @PathVariable int id,
            @PathVariable String status,
            HttpSession session
    ) {

        if (!isAdmin(session)) return "redirect:/login";

        reservationDAO.updateStatus(id, status);

        return "redirect:/admin/reservations";
    }

}