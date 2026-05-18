package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.RestaurantTableDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.RestaurantTable;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;

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

        LocalDateTime now = LocalDateTime.now();

        LocalDateTime reservationTime =
                LocalDateTime.parse(time);

        // =========================
        // CHECK QUÁ KHỨ
        // =========================
        if (reservationTime.isBefore(now)) {

            model.addAttribute(
                    "error",
                    "Không thể đặt bàn trong quá khứ"
            );

            return "reserve";
        }

        // =========================
        // CHECK > 7 NGÀY
        // =========================
        if (reservationTime.isAfter(now.plusDays(7))) {

            model.addAttribute(
                    "error",
                    "Chỉ được đặt trước tối đa 7 ngày"
            );

            return "reserve";
        }

        // =========================
        // CHECK BÀN ĐÃ ĐƯỢC ĐẶT
        // =========================
        RestaurantTableDAO tableDAO = new RestaurantTableDAO();

        RestaurantTable table = tableDAO.findById(tableId);

        if(table == null){

            model.addAttribute(
                    "error",
                    "Bàn không tồn tại"
            );

            return "reserve";
        }

        if(people > table.getCapacity()){

            model.addAttribute(
                    "error",
                    "Số người vượt quá sức chứa của bàn"
            );

            return "reserve";
        }
        boolean booked =
                dao.isTableBooked(tableId, time);

        if (booked) {

            model.addAttribute(
                    "error",
                    "Bàn này đã được đặt"
            );

            return "reserve";
        }

        Reservation r = new Reservation();

        r.setUserId(user.getId());
        r.setTableId(tableId);
        r.setReservationTime(time);
        r.setNumberOfPeople(people);

        int reservationId =
                dao.insertAndGetId(r);

        if (reservationId == 0) {

            model.addAttribute(
                    "error",
                    "Đặt bàn thất bại"
            );

            return "reserve";
        }

        // LƯU SESSION
        session.setAttribute(
                "currentReservation",
                reservationId
        );

        return "redirect:/cart";
    }
}