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