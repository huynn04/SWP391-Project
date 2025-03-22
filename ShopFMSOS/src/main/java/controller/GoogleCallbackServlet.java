package controller;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.auth.oauth2.BearerToken;

import com.google.api.services.people.v1.PeopleService;
import com.google.api.services.people.v1.PeopleServiceScopes;
import com.google.api.services.people.v1.model.Person;

import dal.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.Optional;

@WebServlet("/callback")
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = "1096516353632-1h6nv5aigac6dr17ghph007vohfnjrh7.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/callback";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String code = request.getParameter("code");

            if (code == null || code.isEmpty()) {
                response.getWriter().write("Lỗi: Không có mã code từ Google.");
                return;
            }

            HttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();

            // Lấy access token từ code
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    transport,
                    JSON_FACTORY,
                    "https://oauth2.googleapis.com/token",
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    REDIRECT_URI
            ).execute();

            // Tạo Credential từ token
            Credential credential = new Credential(BearerToken.authorizationHeaderAccessMethod())
                    .setAccessToken(tokenResponse.getAccessToken());

            // Tạo PeopleService từ credential
            PeopleService peopleService = new PeopleService.Builder(
                    transport,
                    JSON_FACTORY,
                    credential
            ).setApplicationName("ShopFMSOS Login").build();

            // Lấy profile người dùng
            Person profile = peopleService.people()
                    .get("people/me")
                    .setPersonFields("names,emailAddresses")
                    .execute();

            String name = profile.getNames().get(0).getDisplayName();
            String email = profile.getEmailAddresses().get(0).getValue();

            System.out.println("[GoogleCallback] Tên: " + name);
            System.out.println("[GoogleCallback] Email: " + email);

            // Kiểm tra user trong DB
            UserDAO userDAO = new UserDAO();
            Optional<User> optionalUser = userDAO.getUserByEmail(email);

            User user;
            if (optionalUser.isPresent()) {
                user = optionalUser.get();
            } else {
                user = new User();
                user.setFullName(name);
                user.setEmail(email);
                user.setStatus(1);
                user.setRoleId(3); // customer
                user.setPassword("GOOGLE_USER"); // tạm thời đặt mật khẩu giả

                // ❗ BẮT BUỘC đặt giá trị cho các field null
//                user.setPhoneNumber("");
//                user.setAddress("Unknown");
//                user.setCity("Hồ Chí Minh");
//                user.setAvatar("");

                userDAO.insertUser(user);
                user = userDAO.getUserByEmail(email).orElse(user);
            }

            // ✅ Lưu session
            request.getSession().setAttribute("loggedInUser", user); // dùng đúng key
            request.getSession().setAttribute("canChangePasswordWithoutOld", true); // ⚡ Cho phép đổi mk không cần mật khẩu cũ


            System.out.println("[GoogleCallback] Session đã lưu: " + user.getEmail());

            // ✅ Redirect đến trang chính
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi bảo mật: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
}
