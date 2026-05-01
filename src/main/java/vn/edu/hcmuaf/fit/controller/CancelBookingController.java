package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.util.List;

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

        List<Reservation> list = reservationDAO.getAll();

        for (Reservation r : list) {

            if (r.getId() == id &&
                    r.getUserId() == user.getId() &&
                    "PENDING".equals(r.getStatus())) {

                reservationDAO.updateStatus(id, "CANCELLED");
                break;
            }
        }

        return "redirect:/my-booking";
    }
}