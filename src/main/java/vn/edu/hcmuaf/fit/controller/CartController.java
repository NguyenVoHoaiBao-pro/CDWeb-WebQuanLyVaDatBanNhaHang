//src/main/java/vn/edu/hcmuaf/fit/controller/CartController.java


package vn.edu.hcmuaf.fit.controller;

import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final CartDAO dao = new CartDAO();
    private final Gson gson = new Gson();

    private String cartRedirect(HttpSession session) {
        return AuthUtil.isStaff(session) ? "redirect:/staff/cart" : "redirect:/cart";
    }

    private String gateOrNull(HttpSession session) {
        if (AuthUtil.isStaff(session)) {
            return AuthUtil.requireStaff(session);
        }
        return AuthUtil.requireVerified(session);
    }

    private Integer resolveReservationId(User u, HttpSession session) {

        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if (reservationId == null && u != null) {
            reservationId = dao.getLatestReservationId(u.getId());
            if (reservationId != null) {
                session.setAttribute("currentReservation", reservationId);
            }
        }

        return reservationId;
    }

    @GetMapping("")
    public String cart(Model model, HttpSession session) {

        User u = (User) session.getAttribute("user");
        if (AuthUtil.isStaff(session)) {
            return "redirect:/staff/cart";
        }
        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
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

    @GetMapping("/add/{id}")
    public String add(@PathVariable int id, HttpSession session) {

        String gate = gateOrNull(session);
        if (gate != null) {
            return gate;
        }
        User u = (User) session.getAttribute("user");
        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        if (reservationId == null) {
            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        boolean valid =
                dao.isReservationValid(reservationId);

        if (!valid) {

            session.removeAttribute("currentReservation");

            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        dao.add(u.getId(), id, reservationId);

        return cartRedirect(session);
    }

    @GetMapping("/increase/{id}")
    public String increase(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId =
                (Integer) session.getAttribute("currentReservation");

        String gate = gateOrNull(session);
        if (gate != null) return gate;

        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        dao.increase(u.getId(), id, reservationId);

        return cartRedirect(session);
    }

    @GetMapping("/decrease/{id}")
    public String decrease(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        String gate = gateOrNull(session);
        if (gate != null) return gate;
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        dao.decrease(u.getId(), id, reservationId);

        return cartRedirect(session);
    }

    @GetMapping("/remove/{id}")
    public String remove(@PathVariable int id, HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        String gate = gateOrNull(session);
        if (gate != null) return gate;
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        dao.remove(u.getId(), id, reservationId);

        return cartRedirect(session);
    }

    @GetMapping("/clear")
    public String clear(HttpSession session) {

        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");

        String gate = gateOrNull(session);
        if (gate != null) return gate;
        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return AuthUtil.isStaff(session) ? "redirect:/staff/walk-in" : "redirect:/tables";
        }

        dao.clear(u.getId(), reservationId);

        return cartRedirect(session);
    }

    @GetMapping(value = "/api/summary", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String cartSummary(HttpSession session) {

        Map<String, Object> payload = new HashMap<>();
        User u = (User) session.getAttribute("user");

        if (u == null) {
            payload.put("success", false);
            payload.put("count", 0);
            payload.put("total", 0);
            payload.put("message", "not_logged_in");
            return gson.toJson(payload);
        }

        Integer reservationId = resolveReservationId(u, session);

        if (reservationId == null || !dao.isReservationValid(reservationId)) {
            payload.put("success", true);
            payload.put("count", 0);
            payload.put("total", 0);
            return gson.toJson(payload);
        }

        payload.put("success", true);
        payload.put("count", dao.getItemCount(u.getId(), reservationId));
        payload.put("total", dao.getTotal(u.getId(), reservationId));
        payload.put("reservationId", reservationId);

        return gson.toJson(payload);
    }

    @GetMapping(value = "/api/add/{id}", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String addJson(@PathVariable int id, HttpSession session) {

        Map<String, Object> payload = new HashMap<>();
        User u = (User) session.getAttribute("user");

        if (u == null) {
            payload.put("success", false);
            payload.put("message", "not_logged_in");
            return gson.toJson(payload);
        }
        if (!AuthUtil.isStaff(session) && !AuthUtil.isIdentityVerified(u)) {
            payload.put("success", false);
            payload.put("message", "not_verified");
            return gson.toJson(payload);
        }

        Integer reservationId = resolveReservationId(u, session);

        if (reservationId == null) {
            payload.put("success", false);
            payload.put("message", "no_reservation");
            return gson.toJson(payload);
        }

        if (!dao.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            payload.put("success", false);
            payload.put("message", "reservation_expired");
            return gson.toJson(payload);
        }

        dao.add(u.getId(), id, reservationId);

        payload.put("success", true);
        payload.put("count", dao.getItemCount(u.getId(), reservationId));
        payload.put("total", dao.getTotal(u.getId(), reservationId));
        payload.put("productId", id);

        return gson.toJson(payload);
    }
}