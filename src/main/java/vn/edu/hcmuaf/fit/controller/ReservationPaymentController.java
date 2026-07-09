package vn.edu.hcmuaf.fit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.dao.ReservationDAO;
import vn.edu.hcmuaf.fit.model.Reservation;
import vn.edu.hcmuaf.fit.service.VnpayService;
import vn.edu.hcmuaf.fit.util.VNPayUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/reservation")
public class ReservationPaymentController {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Autowired
    private VnpayService vnpayService;

    @GetMapping("/payment")
    public String showPaymentInfo(@RequestParam int id, Model model, HttpSession session) {
        Reservation r = reservationDAO.findById(id);
        if (r == null) return "redirect:/tables";
        
        double fee = r.getTotalPrice() * 0.5;
        model.addAttribute("reservation", r);
        model.addAttribute("fee", fee);
        return "reservation-payment";
    }

    @PostMapping("/vnpay-pay")
    public String payWithVNPay(@RequestParam int id, HttpServletRequest request) throws Exception {
        Reservation r = reservationDAO.findById(id);
        if (r == null) return "redirect:/tables";

        long amount = (long) (r.getTotalPrice() * 0.5 * 100); // 50% fee in cents
        String vnp_TxnRef = VNPayUtil.getRandomNumber(8);
        String vnp_IpAddr = vnpayService.getIpAddress(request);
        String orderInfo = "Thanh toan coc dat ban " + id;
        String returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/reservation/vnpay-return";

        String paymentUrl = vnpayService.createPaymentUrl(amount, orderInfo, vnp_IpAddr, vnp_TxnRef, returnUrl);

        // Store reservation ID in session for reference when returning
        request.getSession().setAttribute("pendingReservationId", id);

        return "redirect:" + paymentUrl;
    }

    @GetMapping("/vnpay-return")
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
                Integer resId = (Integer) session.getAttribute("pendingReservationId");
                if (resId != null) {
                    double amount = Double.parseDouble(request.getParameter("vnp_Amount")) / 100;
                    String txnRef = request.getParameter("vnp_TxnRef");
                    reservationDAO.updatePaidAmount(resId, amount, txnRef);
                    session.removeAttribute("pendingReservationId");
                    session.setAttribute("currentReservation", resId);
                    return "redirect:/cart?paid=1";
                }
            }
            model.addAttribute("error", "Thanh toán không thành công. Mã lỗi: " + request.getParameter("vnp_ResponseCode"));
        } else {
            model.addAttribute("error", "Chữ ký không hợp lệ!");
        }
        return "reservation-payment-result";
    }
}
