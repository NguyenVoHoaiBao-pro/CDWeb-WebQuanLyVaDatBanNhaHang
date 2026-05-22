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
    @GetMapping("/tables")
    public String tables(Model model) {

        model.addAttribute(
                "groundTables",
                dao.getByFloor(0)
        );

        model.addAttribute(
                "floor1Tables",
                dao.getByFloor(1)
        );

        model.addAttribute(
                "floor2Tables",
                dao.getByFloor(2)
        );

        return "table/list";
    }

    @PostMapping("/admin/tables/add")
    public String add(
            @RequestParam String name,
            @RequestParam int capacity,
            @RequestParam int floorNumber,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) {
            return "redirect:/login";
        }

        if (name == null || name.trim().isEmpty() || capacity <= 0) {
            return "redirect:/admin/tables?error=1";
        }

        dao.insert(name, capacity, floorNumber);

        return "redirect:/admin/tables?success=1";
    }
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