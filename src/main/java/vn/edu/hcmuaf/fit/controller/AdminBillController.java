package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.OrderDetail;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class AdminBillController {

    OrderDAO orderDAO = new OrderDAO();
    ReservationDAO reservationDAO = new ReservationDAO();

    @GetMapping("/admin/bill/{reservationId}")
    public String bill(
            @PathVariable int reservationId,
            Model model,
            HttpSession session
    ) {

        if (!AuthUtil.isAdmin(session)) {
            return "redirect:/login";
        }

        Reservation reservation =
                reservationDAO.findById(reservationId);

        Order bill =
                orderDAO.getBill(reservationId);

        List<OrderDetail> details =
                orderDAO.getBillDetails(reservationId);

        model.addAttribute("reservation", reservation);
        model.addAttribute("bill", bill);
        model.addAttribute("details", details);

        return "admin/bill";
    }
}
