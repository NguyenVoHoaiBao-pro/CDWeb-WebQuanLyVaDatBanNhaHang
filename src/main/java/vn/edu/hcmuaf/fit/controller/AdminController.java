package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.*;
import vn.edu.hcmuaf.fit.model.*;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import com.google.gson.Gson;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    ProductDAO productDAO = new ProductDAO();
    UserDAO userDAO = new UserDAO();
    TableDAO tableDAO = new TableDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    AdminDAO adminDAO = new AdminDAO();
    DashboardDAO dashboardDAO = new DashboardDAO();
    private final Gson gson = new Gson();


    @GetMapping("")
    public String dashboard(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            Model model,
            HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        new ReservationDAO().expirePendingReservations();

        LocalDate now = LocalDate.now();
        int reportYear = year != null ? year : now.getYear();
        int reportMonth = month != null ? month : now.getMonthValue();

        DashboardStats stats = dashboardDAO.loadDashboard(reportYear, reportMonth);
        model.addAttribute("stats", stats);
        model.addAttribute("chartJson", buildChartJson(stats));
        model.addAttribute("page", "dashboard.jsp");
        return "admin/layout";
    }

    private String buildChartJson(DashboardStats stats) {
        List<String> dayLabels = new ArrayList<>();
        List<Double> revenues = new ArrayList<>();
        List<Integer> orders = new ArrayList<>();

        for (DailyRevenue d : stats.getDailyRevenue()) {
            dayLabels.add(String.valueOf(d.getDay()));
            revenues.add(d.getRevenue());
            orders.add(d.getOrderCount());
        }

        List<String> topNames = new ArrayList<>();
        List<Double> topRevenues = new ArrayList<>();
        for (TopProductStat t : stats.getTopProducts()) {
            topNames.add(t.getName());
            topRevenues.add(t.getRevenue());
        }

        Map<String, Object> data = new HashMap<>();
        data.put("dayLabels", dayLabels);
        data.put("revenues", revenues);
        data.put("orders", orders);
        data.put("topNames", topNames);
        data.put("topRevenues", topRevenues);
        data.put("paid", stats.getRevenuePaid());
        data.put("unpaid", stats.getRevenueUnpaid());
        data.put("resPending", stats.getReservationsPending());
        data.put("resConfirmed", stats.getReservationsConfirmed());
        data.put("resDone", stats.getReservationsDone());
        data.put("resCancelled", stats.getReservationsCancelled());

        if (stats.getReservationAnalytics() != null) {
            ReservationAnalytics ra = stats.getReservationAnalytics();
            data.put("resToday", ra.getReservationsToday());
            data.put("resActive", ra.getActiveReservations());
            data.put("tableUtil", ra.getTableUtilizationPercent());
            List<String> busyLabels = new ArrayList<>();
            List<Integer> busyCounts = new ArrayList<>();
            for (HourlyBookingStat h : ra.getBusiestHours()) {
                busyLabels.add(h.getHour() + ":00");
                busyCounts.add(h.getCount());
            }
            data.put("busyHourLabels", busyLabels);
            data.put("busyHourCounts", busyCounts);
        }

        return gson.toJson(data);
    }

    @GetMapping("/products")
    public String products(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        model.addAttribute("list", productDAO.getAll());

        model.addAttribute("page", "products.jsp");

        return "admin/layout";
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

            @RequestParam(required = false) String aiKeywords,
            @RequestParam(required = false) String aiDescription,

            Model model,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session))
            return "redirect:/login";

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

        // AI
        p.setAiKeywords(aiKeywords);
        p.setAiDescription(aiDescription);

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
    @GetMapping("/edit-product/{id}")
    public String editProduct(
            @PathVariable int id,
            Model model,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session))
            return "redirect:/login";

        Product p = productDAO.findById(id);

        if (p == null) {
            return "redirect:/admin/products";
        }

        model.addAttribute("product", p);
        model.addAttribute("page", "edit-product.jsp");

        return "admin/layout";
    }
    @PostMapping("/update-product")
    public String updateProduct(

            @RequestParam int id,
            @RequestParam String name,
            @RequestParam double price,
            @RequestParam String description,
            @RequestParam String image,
            @RequestParam String category,

            @RequestParam(required = false) String aiKeywords,
            @RequestParam(required = false) String aiDescription,

            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session))
            return "redirect:/login";

        Product p = new Product();

        p.setId(id);

        p.setName(name);
        p.setPrice(price);
        p.setDescription(description);
        p.setImage(image);
        p.setCategory(category);

        // AI
        p.setAiKeywords(aiKeywords);
        p.setAiDescription(aiDescription);

        productDAO.update(p);

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

    @GetMapping("/set-role/{id}/{role}")
    public String setRole(
            @PathVariable int id,
            @PathVariable String role,
            HttpSession session) {

        if (!AuthUtil.isAdmin(session)) {
            return "redirect:/login";
        }
        if ("USER".equals(role) || "STAFF".equals(role) || "ADMIN".equals(role)) {
            userDAO.setRole(id, role);
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

        if (!status.equals("AVAILABLE")
                && !status.equals("MAINTENANCE")
                && !status.equals("RESERVED")) {
            return "redirect:/admin/tables";
        }

        tableDAO.updateStatus(id, status);

        return "redirect:/admin/tables";
    }

    @GetMapping("/reservations")
    public String reservations(Model model, HttpSession session) {

        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        reservationDAO.expirePendingReservations();
        model.addAttribute("list", reservationDAO.getAll());
        model.addAttribute("page", "reservations.jsp");

        OrderDAO orderDAO = new OrderDAO();

        Map<Integer, Order> orderMap = new HashMap<>();

        for (Reservation r : reservationDAO.getAll()) {

            Order order = orderDAO.getBill(r.getId());

            if(order != null){
                orderMap.put(r.getId(), order);
            }
        }

        model.addAttribute("orderMap", orderMap);
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
                !status.equals("COMPLETED") &&
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
            @RequestParam int floorNumber,
            Model model,
            HttpSession session
    ) {
        if (!AuthUtil.isAdmin(session)) return "redirect:/login";

        if (name == null || name.trim().isEmpty() || capacity <= 0) {
            model.addAttribute("page", "add-table.jsp");
            return "admin/layout";
        }

        tableDAO.insert(name, capacity, floorNumber);

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