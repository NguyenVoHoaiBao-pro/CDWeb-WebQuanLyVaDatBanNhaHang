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
import vn.edu.hcmuaf.fit.service.VnpayService;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.VNPayUtil;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class CheckoutController {

    CartDAO cartDAO = new CartDAO();
    OrderDAO orderDAO = new OrderDAO();
    ReservationDAO reservationDAO = new ReservationDAO();
    RestaurantTableDAO tableDAO = new RestaurantTableDAO();

    @Autowired
    private VnpayService vnpayService;

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
            HttpServletRequest request,
            HttpSession session
    ) throws Exception {

        String gate = AuthUtil.requireVerified(session);
        if (gate != null) {
            return gate;
        }
        User u = getUser(session);

        Integer reservationId = (Integer) session.getAttribute("currentReservation");
        if(reservationId == null){
            return "redirect:/tables";
        }

        if ("VNPAY".equals(payment)) {
            List<Product> cart = cartDAO.getCart(u.getId(), reservationId);
            if (cart == null || cart.isEmpty()) {
                return "redirect:/cart";
            }
            double total = 0;
            for (Product p : cart) {
                total += p.getPrice() * p.getQuantity();
            }

            long amount = (long) (total * 100);
            String vnp_TxnRef = VNPayUtil.getRandomNumber(8);
            String vnp_IpAddr = vnpayService.getIpAddress(request);
            String orderInfo = "Thanh toan don hang cho dat ban " + reservationId;
            String returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/checkout/vnpay-return";

            String paymentUrl = vnpayService.createPaymentUrl(amount, orderInfo, vnp_IpAddr, vnp_TxnRef, returnUrl);

            session.setAttribute("checkoutNote", note != null ? note : "");
            session.setAttribute("pendingPaymentReservationId", reservationId);

            return "redirect:" + paymentUrl;
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

    @GetMapping("/checkout/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, HttpSession session, Model model) {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        if (vnpayService.verifyCallback(fields)) {
            if ("00".equals(request.getParameter("vnp_ResponseCode"))) {
                Integer resId = (Integer) session.getAttribute("pendingPaymentReservationId");
                User u = getUser(session);
                if (resId != null && u != null) {
                    String note = (String) session.getAttribute("checkoutNote");
                    int orderId = orderDAO.checkout(u.getId(), resId, "ONLINE_VNPAY", note);

                    if (orderId > 0) {
                        session.removeAttribute("pendingPaymentReservationId");
                        session.removeAttribute("checkoutNote");
                        session.removeAttribute("currentReservation");
                        session.setAttribute("orderId", orderId);
                        session.setAttribute("payment", "VNPAY");
                        return "redirect:/success?paid=1";
                    }
                }
            }
            model.addAttribute("error", "Thanh toán không thành công. Mã lỗi: " + request.getParameter("vnp_ResponseCode"));
        } else {
            model.addAttribute("error", "Chữ ký không hợp lệ!");
        }
        return "reservation-payment-result";
    }
}