package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.dao.RestaurantTableDAO;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class CheckoutController {

    CartDAO cartDAO = new CartDAO();
    OrderDAO orderDAO = new OrderDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    RestaurantTableDAO tableDAO = new RestaurantTableDAO();

    private User getUser(HttpSession session){
        return (User) session.getAttribute("user");
    }

    @GetMapping("/checkout")
    public String checkout(
            Model model,
            HttpSession session
    ){

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User u = getUser(session);

        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if(reservationId == null){
            return "redirect:/tables";
        }

        boolean valid =
                cartDAO.isReservationValid(reservationId);

        if(!valid){

            session.removeAttribute("currentReservation");

            return "redirect:/tables";
        }

        List<Product> cart = cartDAO.getCart(u.getId(), reservationId);

        if (cart == null || cart.isEmpty()) {
            model.addAttribute("error", "Giỏ hàng trống — vui lòng chọn món trước khi thanh toán");
            return "redirect:/cart";
        }

        Reservation reservation =
                reservationDAO.findById(reservationId);

        model.addAttribute("list", cart);
        model.addAttribute(
                "tables",
                tableDAO.getAll()
        );

        model.addAttribute("reservation", reservation);

        return "product/checkout";
    }

    @PostMapping("/checkout")
    public String submit(

            @RequestParam String payment,
            @RequestParam(required = false) String note,

            HttpSession session
    ){

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User u = getUser(session);

        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if(reservationId == null){
            return "redirect:/tables";
        }

        boolean valid =
                cartDAO.isReservationValid(reservationId);

        if(!valid){

            session.removeAttribute("currentReservation");

            return "redirect:/tables";
        }

        if (payment != null && (payment.startsWith("SIMULATE_"))) {
            session.setAttribute("checkoutNote", note != null ? note : "");
            String method = payment.replace("SIMULATE_", "");
            return "redirect:/payment/simulate?method=" + method;
        }

        int orderId =
                orderDAO.checkout(
                        u.getId(),
                        reservationId,
                        payment,
                        note
                );

        if (orderId == 0) {
            return "redirect:/cart?error=checkout";
        }

        session.setAttribute("orderId", orderId);
        session.setAttribute("payment", payment);
        session.removeAttribute("currentReservation");

        return "redirect:/success";
    }

    @GetMapping("/success")
    public String success(){
        return "product/success";
    }
}