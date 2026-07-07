package vn.edu.hcmuaf.fit.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.edu.hcmuaf.fit.dao.UserDAO;
import vn.edu.hcmuaf.fit.model.User;
import vn.edu.hcmuaf.fit.util.ConfigLoader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Controller
public class OAuthController {

    private final String GG_CLIENT_ID = ConfigLoader.get("google.client.id");
    private final String GG_CLIENT_SECRET = ConfigLoader.get("google.client.secret");

    private final String HARDCODED_REDIRECT_URI = ConfigLoader.get("google.redirect.uri");

    UserDAO userDAO = new UserDAO();

    private String googleRedirect(HttpServletRequest request) {
        return baseUrl(request) + "/login/oauth2/code/google";
    }

    private String baseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        String ctx = request.getContextPath();
        boolean defaultPort =
                ("http".equals(scheme) && port == 80)
                        || ("https".equals(scheme) && port == 443);
        return scheme + "://" + host + (defaultPort ? "" : ":" + port) + ctx;
    }

    private void putUserInSession(HttpSession session, User user) {
        if (user != null && user.getId() > 0) {
            session.setAttribute("user", user);
        }
    }

    private User reloadAfterRegister(User draft) {
        if (draft.getEmail() != null && !draft.getEmail().isEmpty()) {
            User fromDb = userDAO.findByEmail(draft.getEmail());
            if (fromDb != null) {
                return fromDb;
            }
        }
        return userDAO.findByUsername(draft.getUsername());
    }

    @GetMapping("/oauth/google")
    public String googleLogin(HttpServletRequest request, Model model) throws Exception {

        if ("YOUR_GOOGLE_CLIENT_ID".equals(GG_CLIENT_ID)) {
            return "redirect:/login?error=google_config_missing";
        }

        String redirect = googleRedirect(request);
        String url = "https://accounts.google.com/o/oauth2/v2/auth?"
                + "client_id=" + URLEncoder.encode(GG_CLIENT_ID, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(redirect, "UTF-8")
                + "&response_type=code"
                + "&scope=" + URLEncoder.encode("openid email profile", "UTF-8")
                + "&access_type=offline";

        return "redirect:" + url;
    }

    @GetMapping("/login/oauth2/code/google")
    public String googleCallback(String code, HttpServletRequest request, HttpSession session) {

        if (code == null || code.trim().isEmpty()) {
            return "redirect:/login?error=google_denied";
        }

        try {
            String redirect = googleRedirect(request);
            String params = "code=" + URLEncoder.encode(code, "UTF-8")
                    + "&client_id=" + URLEncoder.encode(GG_CLIENT_ID, "UTF-8")
                    + "&client_secret=" + URLEncoder.encode(GG_CLIENT_SECRET, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(redirect, "UTF-8")
                    + "&grant_type=authorization_code";

            URL url = new URL("https://oauth2.googleapis.com/token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.getOutputStream().write(params.getBytes(StandardCharsets.UTF_8));

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)
            );

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            JsonObject json = JsonParser.parseString(response.toString()).getAsJsonObject();
            String accessToken = json.get("access_token").getAsString();

            URL userInfoUrl = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
            HttpURLConnection conn2 = (HttpURLConnection) userInfoUrl.openConnection();
            conn2.setRequestProperty("Authorization", "Bearer " + accessToken);

            BufferedReader reader2 = new BufferedReader(
                    new InputStreamReader(conn2.getInputStream(), StandardCharsets.UTF_8)
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
                User draft = new User();
                draft.setUsername(email);
                draft.setPassword(UUID.randomUUID().toString());
                draft.setFullName(name);
                draft.setEmail(email);
                if (userDAO.register(draft)) {
                    user = reloadAfterRegister(draft);
                }
            }

            if (user != null && user.getId() > 0) {
                putUserInSession(session, user);
                return "redirect:/";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/login?error=google_failed";
    }
}
