package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import vn.edu.hcmuaf.fit.model.ReservationValidationResult;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.ReservationAvailabilityService;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.ReservationRules;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;

@Controller
public class ReservationController {

    private final ReservationAvailabilityService availabilityService = new ReservationAvailabilityService();

    @GetMapping("/reserve")
    public String showForm(HttpSession session) {
        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        availabilityService.expirePendingReservations();
        return "reserve";
    }

    @PostMapping("/reserve")
    public String reserve(
            @RequestParam int tableId,
            @RequestParam String time,
            @RequestParam int people,
            HttpSession session,
            Model model) {

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User user = (User) session.getAttribute("user");

        LocalDateTime start = ReservationRules.parseDateTime(time);
        if (start == null) {
            try {
                start = LocalDateTime.parse(time);
            } catch (Exception e) {
                model.addAttribute("error", "Định dạng thời gian không hợp lệ");
                return "reserve";
            }
        }

        LocalDateTime end = start.plusHours(ReservationRules.SLOT_DURATION_HOURS);
        String startIso = ReservationRules.toIsoLocal(start);
        String endIso = ReservationRules.toIsoLocal(end);

        ReservationValidationResult validation = availabilityService.validateBooking(
                tableId, startIso, endIso, people, 0);

        if (!validation.isValid()) {
            model.addAttribute("error", validation.getMessage());
            return "reserve";
        }

        int reservationId = availabilityService.createBooking(
                user.getId(), tableId, startIso, endIso, people);

        if (reservationId == 0) {
            model.addAttribute("error", "Đặt bàn thất bại — khung giờ không còn trống");
            return "reserve";
        }

        session.setAttribute("currentReservation", reservationId);
        return "redirect:/reservation/payment?id=" + reservationId;
    }
}
