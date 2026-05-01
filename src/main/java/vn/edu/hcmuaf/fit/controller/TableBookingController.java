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

    ReservationDAO reservationDAO = new ReservationDAO();
    TableDAO tableDAO = new TableDAO();

    // ==========================
    // PAGE BOOK TABLE
    // ==========================
    @GetMapping("/tables")
    public String tables(Model model) {

        List<RestaurantTable> list = tableDAO.getAll();

        model.addAttribute("list", list);

        return "tables";
    }

    // ==========================
    // BOOK NOW
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

        Reservation r = new Reservation();

        r.setUserId(user.getId());
        r.setTableId(tableId);
        r.setReservationTime(reservationTime);
        r.setNumberOfPeople(numberOfPeople);

        reservationDAO.insert(r);

        tableDAO.updateStatus(tableId, "RESERVED");

        return "redirect:/tables?success=1";
    }
}