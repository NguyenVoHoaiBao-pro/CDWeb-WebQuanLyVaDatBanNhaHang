//package vn.edu.hcmuaf.fit.controller;
//
//import vn.edu.hcmuaf.fit.service.ChatbotService;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//
//import java.io.IOException;
//
//@WebServlet("/chat")
//public class ChatbotController
//        extends HttpServlet {
//
//    ChatbotService chatbotService =
//            new ChatbotService();
//
//    @Override
//    protected void doPost(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//
//        String message =
//                request.getParameter("message");
//
//        String reply =
//                chatbotService.reply(message);
//
//        response.setContentType("text/html;charset=UTF-8");
//
//        response.getWriter().write(reply);
//    }
//}
package vn.edu.hcmuaf.fit.controller;

import org.springframework.web.bind.annotation.*;
import vn.edu.hcmuaf.fit.service.ChatbotService;

@RestController
public class ChatbotController {

    ChatbotService chatbotService =
            new ChatbotService();

    @PostMapping(
            value = "/chat",
            produces = "text/plain;charset=UTF-8"
    )
    public String chat(
            @RequestParam String message
    ) {

        return chatbotService.reply(message);
    }
}