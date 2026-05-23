package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

@Controller
public class CancelBookingController {

    ReservationDAO reservationDAO = new ReservationDAO();

    @GetMapping("/cancel-booking/{id}")
    public String cancel(@PathVariable int id,
                         HttpSession session) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        Reservation target = reservationDAO.findById(id);

        if (target != null
                && target.getUserId() == user.getId()
                && "PENDING".equals(target.getStatus())) {

            reservationDAO.updateStatus(id, "CANCELLED");

            Integer current = (Integer) session.getAttribute("currentReservation");
            if (current != null && current == id) {
                session.removeAttribute("currentReservation");
            }
        }

        return "redirect:/my-booking";
    }
}