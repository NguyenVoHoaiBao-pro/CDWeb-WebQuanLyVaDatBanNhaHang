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
            HttpSession session
    ) {

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // ===== CHECK BÀN =====
        RestaurantTable table = null;

        for (RestaurantTable t : tableDAO.getAll()) {
            if (t.getId() == tableId) {
                table = t;
                break;
            }
        }

        // ❌ bàn không tồn tại hoặc đã được đặt
        if (table == null || !"AVAILABLE".equals(table.getStatus())) {
            return "redirect:/tables?error=full";
        }

        // ===== TẠO BOOKING =====
        Reservation r = new Reservation();
        r.setUserId(user.getId());
        r.setTableId(tableId);
        r.setReservationTime(reservationTime);
        r.setNumberOfPeople(numberOfPeople);

        // ✔ đúng: check xong mới insert
        int reservationId = reservationDAO.insertAndGetId(r);

// lưu session
        session.setAttribute("currentReservation", reservationId);

// update bàn
        tableDAO.updateStatus(tableId, "RESERVED");

// chuyển qua cart
        return "redirect:/cart";
    }

    // ==========================
    // PAGE: LỊCH SỬ ĐẶT BÀN
    // ==========================
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