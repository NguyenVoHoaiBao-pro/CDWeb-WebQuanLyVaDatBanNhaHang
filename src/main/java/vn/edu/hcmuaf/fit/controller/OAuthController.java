package vn.edu.hcmuaf.fit.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;

import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.UUID;

@Controller
public class OAuthController {

    // ===== GOOGLE =====
    private final String GG_CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID";
    private final String GG_CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";
    private final String GG_REDIRECT =
            "http://localhost:8080/NhaHangCuaChungTa_war_exploded/oauth/google/callback";

    // ===== FACEBOOK =====
    private final String FB_APP_ID = "...";
    private final String FB_APP_SECRET = "...";
    private final String FB_REDIRECT =
            "http://localhost:8080/NhaHangCuaChungTa_war_exploded/oauth/facebook/callback";

    UserDAO userDAO = new UserDAO();

    // =====================================================
    // GOOGLE LOGIN
    // =====================================================
    @GetMapping("/oauth/google")
    public String googleLogin() {

        String url = "https://accounts.google.com/o/oauth2/v2/auth?"
                + "client_id=" + GG_CLIENT_ID
                + "&redirect_uri=" + GG_REDIRECT
                + "&response_type=code"
                + "&scope=openid%20email%20profile"
                + "&access_type=offline";

        return "redirect:" + url;
    }

    @GetMapping("/oauth/google/callback")
    public String googleCallback(String code, HttpSession session) {

        try {
            // ===== 1. GET TOKEN =====
            String params = "code=" + code
                    + "&client_id=" + GG_CLIENT_ID
                    + "&client_secret=" + GG_CLIENT_SECRET
                    + "&redirect_uri=" + GG_REDIRECT
                    + "&grant_type=authorization_code";

            URL url = new URL("https://oauth2.googleapis.com/token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.getOutputStream().write(params.getBytes());

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream())
            );

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            JsonObject json = JsonParser.parseString(response.toString()).getAsJsonObject();
            String accessToken = json.get("access_token").getAsString();

            // ===== 2. GET USER INFO =====
            URL userInfoUrl = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
            HttpURLConnection conn2 = (HttpURLConnection) userInfoUrl.openConnection();
            conn2.setRequestProperty("Authorization", "Bearer " + accessToken);

            BufferedReader reader2 = new BufferedReader(
                    new InputStreamReader(conn2.getInputStream())
            );

            StringBuilder userInfo = new StringBuilder();
            while ((line = reader2.readLine()) != null) {
                userInfo.append(line);
            }

            JsonObject userJson = JsonParser.parseString(userInfo.toString()).getAsJsonObject();

            String email = userJson.get("email").getAsString();
            String name = userJson.get("name").getAsString();

            User user = userDAO.findByEmail(email);

            if (user == null) {
                user = new User();
                user.setUsername(email);
                user.setPassword(UUID.randomUUID().toString());
                user.setFullName(name);
                user.setEmail(email);
                userDAO.register(user);
            }

            session.setAttribute("user", user);
            return "redirect:/";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/login?error=google_failed";
    }

    // =====================================================
    // FACEBOOK LOGIN
    // =====================================================
    @GetMapping("/oauth/facebook")
    public String facebookLogin() {

        String url = "https://www.facebook.com/v18.0/dialog/oauth?"
                + "client_id=" + FB_APP_ID
                + "&redirect_uri=" + FB_REDIRECT
                + "&scope=email,public_profile";

        return "redirect:" + url;
    }

    @GetMapping("/oauth/facebook/callback")
    public String facebookCallback(String code, HttpSession session) {

        try {
            // ===== 1. GET TOKEN =====
            String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token?"
                    + "client_id=" + FB_APP_ID
                    + "&redirect_uri=" + FB_REDIRECT
                    + "&client_secret=" + FB_APP_SECRET
                    + "&code=" + code;

            URL url = new URL(tokenUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream())
            );

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            JsonObject json = JsonParser.parseString(response.toString()).getAsJsonObject();
            String accessToken = json.get("access_token").getAsString();

            // ===== 2. GET USER INFO =====
            String userInfoUrl = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + accessToken;

            URL url2 = new URL(userInfoUrl);
            HttpURLConnection conn2 = (HttpURLConnection) url2.openConnection();

            BufferedReader reader2 = new BufferedReader(
                    new InputStreamReader(conn2.getInputStream())
            );

            StringBuilder userInfo = new StringBuilder();
            while ((line = reader2.readLine()) != null) {
                userInfo.append(line);
            }

            JsonObject userJson = JsonParser.parseString(userInfo.toString()).getAsJsonObject();

            String email = userJson.has("email") ? userJson.get("email").getAsString() : null;
            String name = userJson.get("name").getAsString();
            String fbId = userJson.get("id").getAsString();

            User user = (email != null) ? userDAO.findByEmail(email) : null;

            if (user == null) {
                user = new User();
                user.setUsername(email != null ? email : "fb_" + fbId);
                user.setPassword(UUID.randomUUID().toString());
                user.setFullName(name);
                user.setEmail(email);
                userDAO.register(user);
            }

            session.setAttribute("user", user);
            return "redirect:/";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/login?error=facebook_failed";
    }
}