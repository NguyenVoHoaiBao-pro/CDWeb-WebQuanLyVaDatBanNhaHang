package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.ReservationAvailabilityService;

import javax.servlet.http.HttpSession;

@Controller
public class EditBookingController {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final ReservationAvailabilityService availabilityService = new ReservationAvailabilityService();

    @GetMapping("/edit-booking/{id}")
    public String editPage(@PathVariable int id,
                           HttpSession session,
                           Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        availabilityService.expirePendingReservations();
        Reservation r = reservationDAO.findById(id);

        if (r != null && r.getUserId() == user.getId() && "PENDING".equals(r.getStatus())) {
            model.addAttribute("booking", r);
            model.addAttribute("table", new vn.edu.hcmuaf.fit.dao.TableDAO().findById(r.getTableId()));
            return "edit-booking";
        }

        return "redirect:/my-booking";
    }

    @PostMapping("/edit-booking")
    public String update(
            @RequestParam int id,
            @RequestParam String reservationTime,
            @RequestParam(required = false) String reservationEndTime,
            @RequestParam int numberOfPeople,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        boolean ok = availabilityService.updateBookingForUser(
                id, user.getId(), reservationTime, reservationEndTime, numberOfPeople);

        if (!ok) {
            Reservation r = reservationDAO.findById(id);
            if (r != null && r.getUserId() == user.getId()) {
                model.addAttribute("booking", r);
                model.addAttribute("error",
                        "Không thể cập nhật — khung giờ trùng lịch, quá sức chứa hoặc không hợp lệ.");
                return "edit-booking";
            }
        }

        return "redirect:/my-booking";
    }
}
