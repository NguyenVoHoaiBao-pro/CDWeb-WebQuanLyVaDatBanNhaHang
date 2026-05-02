package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

@Controller
public class ReservationController {

    ReservationDAO dao = new ReservationDAO();

    @GetMapping("/reserve")
    public String showForm() {
        return "reserve";
    }

    @PostMapping("/reserve")
    public String reserve(
            @RequestParam int tableId,
            @RequestParam String time,
            @RequestParam int people,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        Reservation r = new Reservation();
        r.setUserId(user.getId()); // ✅ lấy từ session
        r.setTableId(tableId);
        r.setReservationTime(time);
        r.setNumberOfPeople(people);

        boolean success = dao.insert(r);

        if (success) {
            return "success";
        } else {
            model.addAttribute("error", "Đặt bàn thất bại");
            return "reserve";
        }
    }
}