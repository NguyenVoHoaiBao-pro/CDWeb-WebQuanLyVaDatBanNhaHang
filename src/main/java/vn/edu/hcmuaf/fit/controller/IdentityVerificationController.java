package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.MailUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class IdentityVerificationController {

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/verify-identity")
    public String showVerificationForm(
            @RequestParam(required = false) String need,
            HttpSession session,
            Model model
    ) {
        String redirect = AuthUtil.requireLogin(session);
        if (redirect != null) {
            return redirect;
        }
        User user = AuthUtil.refreshSessionUser(session);
        if (AuthUtil.isIdentityVerified(user)) {
            return "redirect:/profile?verified=1";
        }

        // Gửi mã xác thực nếu chưa có trong session
        String code = (String) session.getAttribute("verificationCode");
        if (code == null) {
            code = MailUtil.generateVerificationCode();
            session.setAttribute("verificationCode", code);
            boolean sent = MailUtil.sendEmail(
                    user.getEmail(),
                    "Xác thực tài khoản Nhà Hàng Của Chúng Ta",
                    "Mã xác thực của bạn là: " + code
            );
            if (!sent) {
                model.addAttribute("error", "Không thể gửi email xác thực. Vui lòng kiểm tra lại email hoặc thử lại sau.");
            } else {
                model.addAttribute("message", "Mã xác thực đã được gửi tới email: " + user.getEmail());
            }
        }

        model.addAttribute("needBooking", "1".equals(need));
        return "verify-identity";
    }

    @PostMapping("/verify-identity")
    public String verifyCode(
            @RequestParam String code,
            HttpSession session,
            Model model
    ) {
        String redirect = AuthUtil.requireLogin(session);
        if (redirect != null) {
            return redirect;
        }
        User user = (User) session.getAttribute("user");
        String sessionCode = (String) session.getAttribute("verificationCode");

        if (sessionCode == null || !sessionCode.equals(code)) {
            model.addAttribute("error", "Mã xác thực không chính xác hoặc đã hết hạn.");
            return "verify-identity";
        }

        if (!userDAO.setIdentityVerified(user.getId())) {
            model.addAttribute("error", "Lưu xác thực thất bại — vui lòng thử lại hoặc liên hệ quản trị.");
            return "verify-identity";
        }

        // Xóa mã sau khi xác thực thành công
        session.removeAttribute("verificationCode");

        User fresh = AuthUtil.refreshSessionUser(session);
        if (fresh != null) {
            fresh.setIdentityVerified(true);
            session.setAttribute("user", fresh);
        }
        return "redirect:/profile?verified=1";
    }

    @GetMapping("/resend-verification")
    public String resendCode(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            String code = MailUtil.generateVerificationCode();
            session.setAttribute("verificationCode", code);
            MailUtil.sendEmail(
                    user.getEmail(),
                    "Xác thực tài khoản Nhà Hàng Của Chúng Ta",
                    "Mã xác thực của bạn là: " + code
            );
        }
        return "redirect:/verify-identity?resend=1";
    }
}
