package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.RestaurantTable;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;

@Controller
public class TableBookingController {

    private ReservationDAO reservationDAO = new ReservationDAO();
    private TableDAO tableDAO = new TableDAO();

    // ==========================
    // PAGE: FORM ĐẶT BÀN
    // URL: /table-booking?tableId=1
    // ==========================
    @GetMapping("/table-booking")
    public String bookingPage(
            @RequestParam(required = false) Integer tableId,
            Model model,
            HttpSession session
    ) {
        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // nếu không có tableId → quay về danh sách bàn
        if (tableId == null) {
            return "redirect:/tables";
        }

        model.addAttribute("tableId", tableId);

        return "table-booking"; // cần file table-booking.jsp
    }

    // ==========================
    // ACTION: ĐẶT BÀN
    // ==========================
    @PostMapping("/book-table")
    public String bookTable(
            @RequestParam int tableId,
            @RequestParam String reservationTime,
            @RequestParam int numberOfPeople,
            HttpSession session,
            Model model
    ) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }


        RestaurantTable table =
                tableDAO.findById(tableId);

        if(table == null){
            return "redirect:/tables?error=notfound";
        }

// check sức chứa
        if(numberOfPeople > table.getCapacity()){

            model.addAttribute(
                    "error",
                    "Số người vượt quá sức chứa của bàn"
            );

            model.addAttribute("tableId", tableId);

            return "table-booking";
        }

// check reservation thực sự
        boolean booked =
                reservationDAO.isTableBooked(
                        tableId,
                        reservationTime
                );

        if(booked){

            model.addAttribute(
                    "error",
                    "Bàn này đã được đặt trong thời gian đó"
            );

            model.addAttribute("tableId", tableId);

            return "table-booking";
        }

        LocalDateTime now = LocalDateTime.now();

        LocalDateTime bookingTime;

        try{
            bookingTime =
                    LocalDateTime.parse(reservationTime);
        }catch (Exception e){
            return "redirect:/tables?error=format";
        }

        if(bookingTime.isBefore(now)){
            model.addAttribute(
                    "error",
                    "Không thể đặt thời gian trong quá khứ"
            );

            model.addAttribute("tableId", tableId);

            return "table-booking";
        }

        if(bookingTime.isAfter(now.plusDays(7))){

            model.addAttribute(
                    "error",
                    "Chỉ được đặt bàn tối đa trước 7 ngày"
            );

            model.addAttribute("tableId", tableId);

            return "table-booking";
        }

        if(numberOfPeople <= 0){

            model.addAttribute(
                    "error",
                    "Số người không hợp lệ"
            );

            model.addAttribute("tableId", tableId);

            return "table-booking";
        }

        Reservation r = new Reservation();

        r.setUserId(user.getId());
        r.setTableId(tableId);
        r.setReservationTime(reservationTime);
        r.setNumberOfPeople(numberOfPeople);

        int reservationId =
                reservationDAO.insertAndGetId(r);

        if(reservationId == 0){
            return "redirect:/tables?error=insert";
        }


        session.setAttribute(
                "currentReservation",
                reservationId
        );

        return "redirect:/cart";
    }

    @GetMapping("/my-booking")
    public String myBooking(HttpSession session, Model model){

        User u = (User) session.getAttribute("user");

        if(u == null){
            return "redirect:/login";
        }

        model.addAttribute("list",
                reservationDAO.getByUser(u.getId()));

        return "my-booking";
    }
}