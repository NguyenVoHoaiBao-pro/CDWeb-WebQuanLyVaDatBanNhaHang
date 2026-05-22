package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.dao.RestaurantTableDAO;
import javax.servlet.http.HttpSession;

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

        User u = getUser(session);

        if(u == null){
            return "redirect:/login";
        }

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

        Reservation reservation =
                reservationDAO.findById(reservationId);

        model.addAttribute(
                "list",
                cartDAO.getCart(u.getId(), reservationId)
        );
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

        User u = getUser(session);

        if(u == null){
            return "redirect:/login";
        }

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

        int orderId =
                orderDAO.checkout(
                        u.getId(),
                        reservationId,
                        payment,
                        note
                );

        if(orderId == 0){
            return "redirect:/checkout";
        }

        session.setAttribute("orderId", orderId);

        session.removeAttribute("currentReservation");

        return "redirect:/success";
    }

    @GetMapping("/success")
    public String success(){
        return "product/success";
    }
}