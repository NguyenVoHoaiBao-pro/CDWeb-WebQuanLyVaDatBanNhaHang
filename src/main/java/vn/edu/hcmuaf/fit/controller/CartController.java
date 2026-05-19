// FILE: src/main/java/vn/edu/hcmuaf/fit/controller/CartController.java
// VIẾT LẠI FULL để chạy với cart.jsp mới

package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    CartDAO dao = new CartDAO();

    // ==========================
    // VIEW CART
    // /cart
    // ==========================
    @GetMapping("")
    public String cart(Model model, HttpSession session) {

        User u = (User) session.getAttribute("user");

        if (u == null) {
            return "redirect:/login";
        }

        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        // FIX LOST SESSION
        if (reservationId == null) {

            reservationId =
                    dao.getLatestReservationId(u.getId());

            if (reservationId != null) {
                session.setAttribute(
                        "currentReservation",
                        reservationId
                );
            }
        }

        // CHƯA ĐẶT BÀN
        if (reservationId == null) {

            model.addAttribute(
                    "error",
                    "Bạn chưa đặt bàn!"
            );

            return "product/cart";
        }

        dao.clearOld();

        model.addAttribute(
                "list",
                dao.getCart(
                        u.getId(),
                        reservationId
                )
        );

        // TOTAL
        model.addAttribute(
                "total",
                dao.getTotal(
                        u.getId(),
                        reservationId
                )
        );

        model.addAttribute(
                "reservationId",
                reservationId
        );

        return "product/cart";
    }

    // ==========================
    // ADD ITEM
    // /cart/add/5
    // ==========================
    @GetMapping("/add/{id}")
    public String add(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if (u == null) {
            return "redirect:/login";
        }

        if (reservationId == null) {
            System.out.println("❌ CHƯA CÓ RESERVATION");
            return "redirect:/tables";
        }

        System.out.println("ADD CART WITH RESERVATION = " + reservationId);

        boolean valid =
                dao.isReservationValid(reservationId);

        if (!valid) {

            session.removeAttribute("currentReservation");

            return "redirect:/tables";
        }

        dao.add(u.getId(), id, reservationId);

        return "redirect:/cart";
    }

    // ==========================
    // INCREASE
    // ==========================
    @GetMapping("/increase/{id}")
    public String increase(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if (u == null) return "redirect:/login";

        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return "redirect:/tables";
        }

        dao.increase(u.getId(), id, reservationId);

        return "redirect:/cart";
    }

    // ==========================
    // DECREASE
    // ==========================
    @GetMapping("/decrease/{id}")
    public String decrease(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        if (u == null) return "redirect:/login";
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return "redirect:/tables";
        }

        dao.decrease(u.getId(), id, reservationId);

        return "redirect:/cart";
    }

    // ==========================
    // REMOVE ONE
    // ==========================
    @GetMapping("/remove/{id}")
    public String remove(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        if (u == null) return "redirect:/login";
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return "redirect:/tables";
        }

        dao.remove(u.getId(), id, reservationId);

        return "redirect:/cart";
    }

    // ==========================
    // CLEAR ALL
    // ==========================
    @GetMapping("/clear")
    public String clear(HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        if (u == null) return "redirect:/login";
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return "redirect:/tables";
        }

        dao.clear(u.getId(), reservationId);

        return "redirect:/cart";
    }
}