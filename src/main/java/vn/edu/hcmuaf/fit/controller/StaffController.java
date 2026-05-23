package vn.edu.hcmuaf.fit.controller;

import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.ReservationValidationResult;
import vn.edu.hcmuaf.fit.model.RestaurantTable;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.service.ReservationAvailabilityService;
import vn.edu.hcmuaf.fit.service.StaffReservationService;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.ReservationRules;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/staff")
public class StaffController {

    private final TableDAO tableDAO = new TableDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final StaffReservationService staffService = new StaffReservationService();
    private final ReservationAvailabilityService availabilityService = new ReservationAvailabilityService();
    private final Gson gson = new Gson();

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ISO_LOCAL_DATE;

    @GetMapping("")
    public String dashboard(
            @RequestParam(required = false) String date,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        reservationDAO.expirePendingReservations();
        LocalDate day = date != null ? LocalDate.parse(date) : LocalDate.now();
        model.addAttribute("selectedDate", day.format(DATE_FMT));
        model.addAttribute("reservations", reservationDAO.findByDate(day.format(DATE_FMT)));
        model.addAttribute("tables", tableDAO.getAll());
        model.addAttribute("page", "dashboard.jsp");
        return "staff/layout";
    }

    @GetMapping("/schedule")
    public String schedule(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) Integer tableId,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        LocalDate day = date != null ? LocalDate.parse(date) : LocalDate.now();
        String dateStr = day.format(DATE_FMT);
        model.addAttribute("selectedDate", dateStr);
        model.addAttribute("tables", tableDAO.getAll());
        model.addAttribute("tableId", tableId);

        if (tableId != null) {
            model.addAttribute("bookings", reservationDAO.findByTableAndDate(tableId, dateStr));
            model.addAttribute("table", tableDAO.findById(tableId));
            model.addAttribute(
                    "scheduleJson",
                    gson.toJson(availabilityService.getScheduleBlocks(
                            tableId, ReservationRules.MAX_BOOKING_DAYS_AHEAD)));
        } else {
            model.addAttribute("bookings", reservationDAO.findByDate(dateStr));
        }
        model.addAttribute("rulesJson", gson.toJson(availabilityService.buildRulesConfig()));
        model.addAttribute("page", "schedule.jsp");
        return "staff/layout";
    }

    @GetMapping("/reservation/{id}")
    public String reservationDetail(
            @PathVariable int id,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        Reservation r = reservationDAO.findById(id);
        if (r == null) {
            return "redirect:/staff";
        }
        RestaurantTable table = tableDAO.findById(r.getTableId());
        model.addAttribute("reservation", r);
        model.addAttribute("table", table);
        model.addAttribute("foods", reservationDAO.getFoodsByReservation(id));
        model.addAttribute("maxSlots", ReservationRules.MAX_BOOKING_SLOTS);
        model.addAttribute("page", "reservation-detail.jsp");
        return "staff/layout";
    }

    @PostMapping("/reservation/{id}/adjust-slots")
    public String adjustSlots(
            @PathVariable int id,
            @RequestParam int usedSlots,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        User staff = (User) session.getAttribute("user");
        String err = staffService.adjustToUsedSlots(id, usedSlots, staff.getId());
        if (err != null) {
            model.addAttribute("error", err);
            Reservation r = reservationDAO.findById(id);
            model.addAttribute("reservation", r);
            model.addAttribute("table", tableDAO.findById(r != null ? r.getTableId() : 0));
            model.addAttribute("foods", reservationDAO.getFoodsByReservation(id));
            model.addAttribute("maxSlots", ReservationRules.MAX_BOOKING_SLOTS);
            model.addAttribute("page", "reservation-detail.jsp");
            return "staff/layout";
        }
        return "redirect:/staff/reservation/" + id + "?adjusted=1";
    }

    @GetMapping("/walk-in")
    public String walkInPage(
            @RequestParam(required = false) Integer tableId,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        if (tableId != null) {
            model.addAttribute("table", tableDAO.findById(tableId));
            model.addAttribute("tableId", tableId);
            model.addAttribute(
                    "scheduleJson",
                    gson.toJson(availabilityService.getScheduleBlocks(
                            tableId, ReservationRules.MAX_BOOKING_DAYS_AHEAD)));
        }
        model.addAttribute("tables", tableDAO.getAll());
        model.addAttribute("rulesJson", gson.toJson(availabilityService.buildRulesConfig()));
        model.addAttribute("page", "walk-in.jsp");
        return "staff/layout";
    }

    @PostMapping("/walk-in/book")
    public String walkInBook(
            @RequestParam int tableId,
            @RequestParam String reservationTime,
            @RequestParam(required = false) String reservationEndTime,
            @RequestParam int numberOfPeople,
            @RequestParam(required = false) String guestName,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        User staff = (User) session.getAttribute("user");

        ReservationValidationResult validation = staffService.validateWalkIn(
                tableId, reservationTime, reservationEndTime, numberOfPeople);
        if (!validation.isValid()) {
            model.addAttribute("error", validation.getMessage());
            return walkInPage(tableId, session, model);
        }

        int reservationId = staffService.createWalkIn(
                staff.getId(),
                tableId,
                reservationTime,
                reservationEndTime,
                numberOfPeople,
                guestName);

        if (reservationId == 0) {
            model.addAttribute("error", "Không thể giữ bàn — khung giờ vừa được đặt");
            return walkInPage(tableId, session, model);
        }

        session.setAttribute("currentReservation", reservationId);
        session.setAttribute("staffWalkIn", Boolean.TRUE);
        return "redirect:/staff/cart";
    }

}
