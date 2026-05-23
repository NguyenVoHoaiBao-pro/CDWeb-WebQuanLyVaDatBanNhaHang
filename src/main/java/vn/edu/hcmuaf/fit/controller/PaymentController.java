package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Thanh toán giả lập (Momo / VNPay) trước khi hoàn tất đơn.
 */
@Controller
public class PaymentController {

    private final CartDAO cartDAO = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @GetMapping("/payment/simulate")
    public String simulatePage(
            @RequestParam(defaultValue = "MOMO") String method,
            HttpSession session,
            Model model
    ) {
        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        if (reservationId == null || !cartDAO.isReservationValid(reservationId)) {
            return "redirect:/tables";
        }
        List<Product> cart = cartDAO.getCart(u.getId(), reservationId);
        if (cart == null || cart.isEmpty()) {
            return "redirect:/cart";
        }
        double total = 0;
        for (Product p : cart) {
            total += p.getPrice() * p.getQuantity();
        }
        Reservation reservation = reservationDAO.findById(reservationId);
        model.addAttribute("method", method);
        model.addAttribute("total", total);
        model.addAttribute("reservation", reservation);
        model.addAttribute("cart", cart);
        session.setAttribute("pendingPayment", method);
        session.setAttribute("pendingNote", session.getAttribute("checkoutNote"));
        return "payment-simulate";
    }

    @PostMapping("/payment/simulate/confirm")
    public String confirmSimulatedPayment(HttpSession session) {
        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        if (reservationId == null) {
            return "redirect:/tables";
        }
        String method = (String) session.getAttribute("pendingPayment");
        if (method == null) {
            method = "SIMULATE_MOMO";
        }
        String note = (String) session.getAttribute("pendingNote");
        if (note == null) {
            note = "";
        }

        int orderId = orderDAO.checkout(u.getId(), reservationId, "ONLINE_" + method, note);
        if (orderId == 0) {
            return "redirect:/cart?error=checkout";
        }

        session.setAttribute("orderId", orderId);
        session.setAttribute("payment", method);
        session.removeAttribute("currentReservation");
        session.removeAttribute("pendingPayment");
        session.removeAttribute("pendingNote");
        session.removeAttribute("checkoutNote");
        return "redirect:/success?paid=1";
    }
}
