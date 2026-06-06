package vn.edu.hcmuaf.fit.util;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class MailUtil {

    private static final String HOST = ConfigLoader.get("mail.host", "smtp.gmail.com");
    private static final String PORT = ConfigLoader.get("mail.port", "587");
    private static final String USERNAME = ConfigLoader.get("mail.username");
    private static final String PASSWORD = ConfigLoader.get("mail.password");

    public static boolean sendEmail(String to, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/plain; charset=UTF-8");

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String generateVerificationCode() {
        int code = (int) ((Math.random() * 900000) + 100000);
        return String.valueOf(code);
    }
}
