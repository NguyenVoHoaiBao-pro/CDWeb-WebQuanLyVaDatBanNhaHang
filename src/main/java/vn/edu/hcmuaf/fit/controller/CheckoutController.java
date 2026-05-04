// FILE: src/main/java/vn/edu/hcmuaf/fit/controller/CheckoutController.java

package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

@Controller
public class CheckoutController {

    CartDAO cartDAO = new CartDAO();
    OrderDAO orderDAO = new OrderDAO();
    TableDAO tableDAO = new TableDAO();

    private User getUser(HttpSession session){
        return (User) session.getAttribute("user");
    }

    // ==========================
    // MỞ TRANG CHECKOUT
    // ==========================
    @GetMapping("/checkout")
    public String checkout(
            @RequestParam int reservationId,
            Model model,
            HttpSession session){

        User u = getUser(session);

        if(u == null){
            return "redirect:/login";
        }

        model.addAttribute("list",
                cartDAO.getCart(u.getId(), reservationId));

        model.addAttribute("tables",
                tableDAO.getAll()); // 🔥 thêm dòng này

        model.addAttribute("reservationId", reservationId);

        return "product/checkout";
    }
    @PostMapping("/checkout")
    public String submit(
            @RequestParam String name,
            @RequestParam String phone,
            @RequestParam String time,
            @RequestParam int people,
            @RequestParam int tableId,
            @RequestParam String payment,
            @RequestParam(required = false) String note,
            HttpSession session) {

        System.out.println(">>> CONTROLLER RUNNING");

        User u = getUser(session);

        if (u == null) return "redirect:/login";

        System.out.println("USER ID = " + u.getId());
        System.out.println("TABLE ID = " + tableId);
        System.out.println("TIME = " + time);

        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");
        if(reservationId == null){
            return "redirect:/tables";
        }
        int orderId = orderDAO.checkout(
                u.getId(),
                reservationId,   // ✅ thêm dòng này
                tableId,
                time,
                people,
                payment,
                note
        );

        System.out.println("ORDER ID = " + orderId);

        // checkout thất bại thì quay lại trang checkout
        if (orderId == 0) {
            System.out.println(">>> CHECKOUT FAILED");
            return "redirect:/checkout?reservationId=" + reservationId;
        }

        // BỎ dòng cartDAO.clear(u.getId());
        // vì OrderDAO đã xóa cart rồi

        session.setAttribute("orderId", orderId);
        session.setAttribute("payment", payment);

        return "redirect:/success";
    }

    // ==========================
    // THÀNH CÔNG
    // ==========================
    @GetMapping("/success")
    public String success(){
        return "product/success";
    }
}