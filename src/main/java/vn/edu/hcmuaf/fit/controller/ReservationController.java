package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;

@Controller
public class ReservationController {

    ReservationDAO dao = new ReservationDAO();

    @GetMapping("/reserve")
    public String showForm() {
        return "reserve";
    }

    @PostMapping("/reserve")
    public String reserve(@RequestParam int userId,
                          @RequestParam int tableId,
                          @RequestParam String time,
                          @RequestParam int people,
                          Model model) {

        Reservation r = new Reservation();
        r.setUserId(userId);
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