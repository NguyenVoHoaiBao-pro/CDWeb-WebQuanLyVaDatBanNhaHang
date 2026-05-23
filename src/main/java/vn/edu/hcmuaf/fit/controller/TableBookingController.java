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

import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.ReservationRules;



import javax.servlet.http.HttpSession;

import java.util.HashMap;

import java.util.Map;



@Controller

public class TableBookingController {



    private final ReservationDAO reservationDAO = new ReservationDAO();

    private final TableDAO tableDAO = new TableDAO();

    private final ReservationAvailabilityService availabilityService = new ReservationAvailabilityService();

    private final Gson gson = new Gson();



    private void populateBookingModel(Model model, int tableId) {

        model.addAttribute("tableId", tableId);

        model.addAttribute("table", tableDAO.findById(tableId));

        model.addAttribute(

                "scheduleJson",

                gson.toJson(availabilityService.getScheduleBlocks(

                        tableId, ReservationRules.MAX_BOOKING_DAYS_AHEAD))

        );

        model.addAttribute("rulesJson", gson.toJson(availabilityService.buildRulesConfig()));

    }



    @GetMapping("/table-booking")

    public String bookingPage(

            @RequestParam(required = false) Integer tableId,

            Model model,

            HttpSession session

    ) {

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }

        if (tableId == null) {

            return "redirect:/tables";

        }

        RestaurantTable table = tableDAO.findById(tableId);

        if (table == null) {

            return "redirect:/tables?error=notfound";

        }



        availabilityService.expirePendingReservations();

        populateBookingModel(model, tableId);

        return "table-booking";

    }



    @GetMapping(value = "/api/table-schedule", produces = "application/json;charset=UTF-8")

    @ResponseBody

    public String tableSchedule(@RequestParam int tableId) {

        return gson.toJson(availabilityService.buildScheduleApiPayload(

                tableId, ReservationRules.MAX_BOOKING_DAYS_AHEAD));

    }



    @GetMapping(value = "/api/reservation-config", produces = "application/json;charset=UTF-8")

    @ResponseBody

    public String reservationConfig() {

        Map<String, Object> payload = new HashMap<>(availabilityService.buildRulesConfig());

        payload.put("timezone", "Asia/Ho_Chi_Minh");

        payload.put("serverNow", ReservationRules.toIsoLocal(ReservationRules.now()));

        return gson.toJson(payload);

    }



    @GetMapping(value = "/api/validate-booking", produces = "application/json;charset=UTF-8")

    @ResponseBody

    public String validateBooking(

            @RequestParam int tableId,

            @RequestParam String reservationTime,

            @RequestParam String reservationEndTime,

            @RequestParam(required = false, defaultValue = "0") int excludeId,

            @RequestParam(required = false, defaultValue = "1") int numberOfPeople

    ) {

        ReservationValidationResult result = availabilityService.validateBooking(

                tableId, reservationTime, reservationEndTime, numberOfPeople, excludeId);



        Map<String, Object> payload = new HashMap<>();

        payload.put("valid", result.isValid());

        if (!result.isValid()) {

            payload.put("message", result.getMessage());

        }

        return gson.toJson(payload);

    }



    @PostMapping("/book-table")

    public String bookTable(

            @RequestParam int tableId,

            @RequestParam String reservationTime,

            @RequestParam(required = false) String reservationEndTime,

            @RequestParam int numberOfPeople,

            HttpSession session,

            Model model

    ) {

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }

        User user = (User) session.getAttribute("user");

        ReservationValidationResult validation = availabilityService.validateBooking(

                tableId, reservationTime, reservationEndTime, numberOfPeople, 0);



        if (!validation.isValid()) {

            model.addAttribute("error", validation.getMessage());

            populateBookingModel(model, tableId);

            return "table-booking";

        }



        int reservationId = availabilityService.createBooking(

                user.getId(), tableId, reservationTime, reservationEndTime, numberOfPeople);



        if (reservationId == 0) {

            model.addAttribute("error",

                    "Không thể đặt bàn — khung giờ vừa được giữ. Vui lòng chọn lại.");

            populateBookingModel(model, tableId);

            return "table-booking";

        }



        session.setAttribute("currentReservation", reservationId);

        return "redirect:/cart";

    }



    @GetMapping("/my-booking")

    public String myBooking(HttpSession session, Model model) {

        User u = (User) session.getAttribute("user");

        if (u == null) {

            return "redirect:/login";

        }

        availabilityService.expirePendingReservations();

        model.addAttribute("list", reservationDAO.getByUser(u.getId()));

        return "my-booking";

    }

}

