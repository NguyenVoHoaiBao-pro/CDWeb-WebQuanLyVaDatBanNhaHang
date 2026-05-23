package vn.edu.hcmuaf.fit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.AuthUtil;
import vn.edu.hcmuaf.fit.util.IdentityQuiz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class IdentityVerificationController {

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/verify-identity")
    public String showQuiz(
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
        model.addAttribute("questions", IdentityQuiz.getQuestions());
        model.addAttribute("needBooking", "1".equals(need));
        return "verify-identity";
    }

    @PostMapping("/verify-identity")
    public String submitQuiz(HttpServletRequest request, HttpSession session, Model model) {
        String redirect = AuthUtil.requireLogin(session);
        if (redirect != null) {
            return redirect;
        }
        User user = (User) session.getAttribute("user");
        Map<String, String> answers = IdentityQuiz.answersFromRequest(request.getParameterMap());

        if (!IdentityQuiz.grade(answers)) {
            model.addAttribute("error", "Bạn cần trả lời đúng cả 5 câu. Vui lòng thử lại.");
            model.addAttribute("questions", IdentityQuiz.getQuestions());
            return "verify-identity";
        }

        if (!userDAO.ensureIdentityColumns()) {
            model.addAttribute("error",
                    "Không thể cập nhật database (thiếu quyền ALTER). Chạy file sql/migration_identity_verified.sql trên MySQL.");
            model.addAttribute("questions", IdentityQuiz.getQuestions());
            return "verify-identity";
        }

        if (!userDAO.setIdentityVerified(user.getId())) {
            model.addAttribute("error", "Lưu xác thực thất bại — vui lòng thử lại hoặc liên hệ quản trị.");
            model.addAttribute("questions", IdentityQuiz.getQuestions());
            return "verify-identity";
        }

        User fresh = AuthUtil.refreshSessionUser(session);
        if (fresh != null) {
            fresh.setIdentityVerified(true);
            session.setAttribute("user", fresh);
        }
        return "redirect:/profile?verified=1";
    }
}
