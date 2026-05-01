package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class UserReservationController {

    ReservationDAO reservationDAO = new ReservationDAO();

    // ==========================
    // LỊCH SỬ ĐẶT BÀN CỦA USER
    // ==========================
    @GetMapping("/my-booking")
    public String myBooking(Model model, HttpSession session) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        List<Reservation> all = reservationDAO.getAll();
        List<Reservation> mine = new ArrayList<>();

        for (Reservation r : all) {
            if (r.getUserId() == user.getId()) {
                mine.add(r);
            }
        }

        model.addAttribute("list", mine);

        return "my-booking";
    }
}