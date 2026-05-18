package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;

@Controller
public class TableController {

    private TableDAO dao = new TableDAO();

    // ==============================
    // USER: XEM DANH SÁCH BÀN
    // URL: /tables
    // ==============================
    @GetMapping("/tables")
    public String tables(Model model) {

        model.addAttribute("list", dao.getAll());

        // 👉 phải tồn tại file:
        // /WEB-INF/views/table/list.jsp
        return "table/list";
    }

    // ==============================
    // ADMIN: QUẢN LÝ BÀN
    // URL: /admin/tables
    // ==============================
//    @GetMapping("/admin/tables")
//    public String adminTables(Model model, HttpSession session) {
//
//        if (!AuthUtil.isAdmin(session)) {
//            return "redirect:/login";
//        }
//
//        model.addAttribute("list", dao.getAll());
//
//        // 👉 dùng layout giống AdminController
//        model.addAttribute("page", "tables.jsp");
//
//        return "admin/layout";
//    }

    // ==============================
    // ADMIN: THÊM BÀN
    // ==============================
    @PostMapping("/admin/tables/add")
    public String add(
            @RequestParam String name,
            @RequestParam int capacity,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) {
            return "redirect:/login";
        }

        if (name == null || name.trim().isEmpty() || capacity <= 0) {
            return "redirect:/admin/tables?error=1";
        }

        dao.insert(name, capacity);

        return "redirect:/admin/tables?success=1";
    }

    // ==============================
    // ADMIN: ĐỔI TRẠNG THÁI
    // ==============================
//    @GetMapping("/admin/tables/status/{id}")
//    public String status(
//            @PathVariable int id,
//            @RequestParam String value,
//            HttpSession session
//    ) {
//
//        if (!AuthUtil.isAdmin(session)) {
//            return "redirect:/login";
//        }
//
//        if (!value.equals("AVAILABLE") && !value.equals("RESERVED")) {
//            return "redirect:/admin/tables";
//        }
//
//        dao.updateStatus(id, value);
//
//        return "redirect:/admin/tables";
//    }

    // ==============================
    // ADMIN: XÓA BÀN
    // ==============================
    @GetMapping("/admin/tables/delete/{id}")
    public String delete(
            @PathVariable int id,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) {
            return "redirect:/login";
        }

        dao.delete(id);

        return "redirect:/admin/tables";
    }
}