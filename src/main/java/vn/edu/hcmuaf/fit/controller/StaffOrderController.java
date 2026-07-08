package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.CartDAO;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.dao.TableDAO;
import vn.edu.hcmuaf.fit.model.*;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.DateUtil;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/staff")
public class StaffOrderController {

    private final CartDAO cartDAO = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final TableDAO tableDAO = new TableDAO();

    @GetMapping("/cart")
    public String staffCart(HttpSession session, Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        User staff = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        
        List<Reservation> activeCarts = reservationDAO.getReservationsWithCarts();
        model.addAttribute("activeCarts", activeCarts);

        if (reservationId == null) {
            model.addAttribute("error", "Chưa chọn bàn — vào Khách walk-in hoặc chọn đặt bàn trước.");
            model.addAttribute("list", new ArrayList<Product>());
            model.addAttribute("total", 0.0);
            model.addAttribute("page", "cart.jsp");
            return "staff/layout";
        }
        if (!cartDAO.isReservationValid(reservationId)) {
            session.removeAttribute("currentReservation");
            return "redirect:/staff/walk-in";
        }
        List<Product> cart = cartDAO.getCartByReservation(reservationId);
        Reservation reservation = reservationDAO.findById(reservationId);
        model.addAttribute("list", cart);
        model.addAttribute("total", cartDAO.getTotalByReservation(reservationId));
        model.addAttribute("reservationId", reservationId);
        model.addAttribute("reservation", reservation);
        model.addAttribute("table", reservation != null ? tableDAO.findById(reservation.getTableId()) : null);
        model.addAttribute("page", "cart.jsp");
        return "staff/layout";
    }

    @GetMapping("/cart/select/{resId}")
    public String selectCart(@PathVariable int resId, HttpSession session) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        session.setAttribute("currentReservation", resId);
        session.setAttribute("staffWalkIn", Boolean.TRUE);
        return "redirect:/staff/cart";
    }

    @PostMapping("/order/complete")
    public String completeOrder(
            @RequestParam(required = false) String note,
            HttpSession session) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        User staff = (User) session.getAttribute("user");
        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        if (reservationId == null || !cartDAO.isReservationValid(reservationId)) {
            return "redirect:/staff/walk-in";
        }
        int orderId = orderDAO.staffCheckout(staff.getId(), reservationId, note);
        if (orderId == 0) {
            return "redirect:/staff/cart?error=1";
        }
        session.removeAttribute("currentReservation");
        session.removeAttribute("staffWalkIn");
        return "redirect:/staff/bill/" + orderId;
    }

    @GetMapping("/bill/{orderId}")
    public String bill(
            @PathVariable int orderId,
            HttpSession session,
            Model model) {
        String gate = AuthUtil.requireStaff(session);
        if (gate != null) {
            return gate;
        }
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return "redirect:/staff";
        }
        Reservation reservation = reservationDAO.findById(order.getReservationId());
        RestaurantTable table = reservation != null ? tableDAO.findById(reservation.getTableId()) : null;
        List<OrderDetail> details = orderDAO.getBillDetails(order.getReservationId());

        String billCode = order.getBillCode();
        if (billCode == null || billCode.isEmpty()) {
            billCode = "NHCT-" + orderId;
        }

        model.addAttribute("order", order);
        model.addAttribute("reservation", reservation);
        model.addAttribute("table", table);
        model.addAttribute("details", details);
        model.addAttribute("billCode", billCode);
        String qrUrl = "";

        try {
            qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data="
                    + java.net.URLEncoder.encode(billCode, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }

        model.addAttribute("qrUrl", qrUrl);
        model.addAttribute("timeDisplay", DateUtil.formatDateTime(
                reservation != null ? reservation.getReservationStartTime() : null));
        model.addAttribute("timeRange", DateUtil.formatDateTimeRange(
                reservation != null ? reservation.getReservationStartTime() : null,
                reservation != null ? reservation.getReservationEndTime() : null));
        model.addAttribute("page", "bill.jsp");
        return "staff/layout";
    }
}
