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
            // Nhận mã code từ Google
            String code = request.getParameter("code");

            if (code == null || code.isEmpty()) {
                response.getWriter().write("Lỗi: Không có mã code từ Google.");
                return;
            }

            // Gửi mã code để lấy access token
            HttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();

            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    transport,
                    JSON_FACTORY,
                    "https://oauth2.googleapis.com/token",
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    REDIRECT_URI
            ).execute();

            Credential credential = new Credential(BearerToken.authorizationHeaderAccessMethod())
                    .setAccessToken(tokenResponse.getAccessToken());

            // Lấy thông tin người dùng từ Google
            PeopleService peopleService = new PeopleService.Builder(
                    transport,
                    JSON_FACTORY,
                    credential
            ).setApplicationName("ShopFMSOS Login").build();

            Person profile = peopleService.people()
                    .get("people/me")
                    .setPersonFields("names,emailAddresses")
                    .execute();

            String name = profile.getNames().get(0).getDisplayName();
            String email = profile.getEmailAddresses().get(0).getValue();

            System.out.println("[GoogleCallback] Đăng nhập từ Google:");
            System.out.println("Tên: " + name);
            System.out.println("Email: " + email);

            UserDAO userDAO = new UserDAO();
            Optional<User> optionalUser = userDAO.getUserByEmail(email);

            User user;

            if (optionalUser.isPresent()) {
                // ✅ User đã tồn tại → giữ nguyên role_id từ database
                user = optionalUser.get();
                System.out.println("[GoogleCallback] Đã tồn tại user, role ID: " + user.getRoleId());
            } else {
                // ❌ User chưa tồn tại → tạo mới và đặt role mặc định là 3
                user = new User();
                user.setFullName(name);
                user.setEmail(email);
                user.setStatus(1);
                user.setRoleId(3); // Mặc định là customer
                user.setPassword("GOOGLE_USER"); // Tạm placeholder

                userDAO.insertUser(user);
                System.out.println("[GoogleCallback] Đã tạo mới user với role ID: 3");
            }

            // Lấy lại thông tin user từ DB (đảm bảo chuẩn nhất sau khi insert)
            user = userDAO.getUserByEmail(email).orElseThrow();

            // Lưu thông tin đăng nhập vào session
            request.getSession().setAttribute("loggedInUser", user);
            request.getSession().setAttribute("canChangePasswordWithoutOld", true);

            System.out.println("[GoogleCallback] Đăng nhập thành công với vai trò: " + user.getRoleId());

            // Chuyển hướng đến trang chính
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi bảo mật: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi hệ thống: " + e.getMessage());
        }
    }
}
