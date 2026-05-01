package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class EditBookingController {

    ReservationDAO reservationDAO = new ReservationDAO();

    @GetMapping("/edit-booking/{id}")
    public String editPage(@PathVariable int id,
                           HttpSession session,
                           Model model) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        List<Reservation> list = reservationDAO.getAll();

        for (Reservation r : list) {

            if (r.getId() == id &&
                    r.getUserId() == user.getId() &&
                    "PENDING".equals(r.getStatus())) {

                model.addAttribute("booking", r);
                return "edit-booking";
            }
        }

        return "redirect:/my-booking";
    }

    @PostMapping("/edit-booking")
    public String update(
            @RequestParam int id,
            @RequestParam String reservationTime,
            @RequestParam int numberOfPeople,
            HttpSession session) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        reservationDAO.updateBooking(
                id,
                reservationTime,
                numberOfPeople
        );

        return "redirect:/my-booking";
    }
}