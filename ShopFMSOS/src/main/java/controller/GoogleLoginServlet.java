package controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Arrays;


public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID = "1096516353632-1h6nv5aigac6dr17ghph007vohfnjrh7.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/FMSOS/callback";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    JSON_FACTORY,
                    CLIENT_ID,
                    CLIENT_SECRET,
                    Arrays.asList(
                        "https://www.googleapis.com/auth/userinfo.profile",
                        "https://www.googleapis.com/auth/userinfo.email"
                    )
            )
            .setAccessType("offline")
            .build();

            // Tạo URL đăng nhập Google
            String authorizationUrl = flow.newAuthorizationUrl()
                    .setRedirectUri(REDIRECT_URI)
                    .build();

            response.sendRedirect(authorizationUrl);

        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi bảo mật: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
}
