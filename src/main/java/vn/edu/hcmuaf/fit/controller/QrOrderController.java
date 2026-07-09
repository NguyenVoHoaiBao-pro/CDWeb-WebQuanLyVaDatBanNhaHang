package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.model.RestaurantTable;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;

@Controller
public class QrOrderController {

    private final TableDAO tableDAO = new TableDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final CartDAO cartDAO = new CartDAO();

    @GetMapping("/qr-order")
    public String handleQrOrder(
            @RequestParam int tableId,
            HttpSession session,
            Model model
    ) {
        RestaurantTable table = tableDAO.findById(tableId);
        if (table == null) {
            return "redirect:/?error=table_not_found";
        }

        // Get or create guest user for this specific table
        User guestUser = userDAO.getOrCreateGuestUser(tableId, table.getName());
        if (guestUser == null) {
            return "redirect:/?error=guest_creation_failed";
        }

        // Check if there is an active reservation right now for this table
        Reservation activeRes = reservationDAO.getActiveReservationNow(tableId);
        int reservationId;

        if (activeRes != null) {
            reservationId = activeRes.getId();
            // Log in as the user associated with this reservation to share the cart
            User associatedUser = userDAO.findById(activeRes.getUserId());
            if (associatedUser != null) {
                session.setAttribute("user", associatedUser);
            } else {
                session.setAttribute("user", guestUser);
            }
        } else {
            // No active reservation — create a lightweight QR walk-in (bypasses overlap guard)
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime end = now.plusHours(3);
            reservationId = reservationDAO.insertQrWalkIn(
                    guestUser.getId(),
                    tableId,
                    now,
                    end,
                    table.getName()
            );
            
            if (reservationId == 0) {
                return "redirect:/?error=reservation_failed";
            }
            session.setAttribute("user", guestUser);
        }

        // Set session attributes to authorize user and map them to the table reservation
        session.setAttribute("currentReservation", reservationId);
        session.setAttribute("qrOrderTableId", tableId);

        return "redirect:/menu-guest";
    }

    @GetMapping("/qr-order/submit")
    public String submitQrOrder(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        Integer tableId = (Integer) session.getAttribute("qrOrderTableId");

        if (u == null || reservationId == null || tableId == null) {
            return "redirect:/menu";
        }

        List<Product> cart = cartDAO.getCartByReservation(reservationId);
        if (cart == null || cart.isEmpty()) {
            return "redirect:/cart?error=empty";
        }

        // Mark the reservation as submitted
        reservationDAO.submitQrOrder(reservationId);

        // Store reservation details to show on the success page
        session.setAttribute("orderedReservationId", reservationId);
        
        RestaurantTable table = tableDAO.findById(tableId);
        String name = table != null ? table.getName() : ("Bàn " + tableId);
        session.setAttribute("orderedTableName", name);

        return "redirect:/qr-order/success";
    }

    @GetMapping("/qr-order/success")
    public String qrOrderSuccess(HttpSession session, Model model) {
        Integer reservationId = (Integer) session.getAttribute("orderedReservationId");
        if (reservationId == null) {
            return "redirect:/menu";
        }
        model.addAttribute("reservationId", reservationId);
        model.addAttribute("tableName", session.getAttribute("orderedTableName"));
        
        // Do not remove session user or currentReservation so they can continue to view/order!
        session.removeAttribute("orderedReservationId");
        session.removeAttribute("orderedTableName");

        return "product/success-qr-order";
    }
}
