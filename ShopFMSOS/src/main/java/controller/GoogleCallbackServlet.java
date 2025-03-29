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
import utils.HashUtil;  // Import HashUtil to hash passwords if needed

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Optional;

public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = "1096516353632-1h6nv5aigac6dr17ghph007vohfnjrh7.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/FMSOS/callback"; // Ensure the URL is correct
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Receive the authorization code from Google
            String code = request.getParameter("code");

            if (code == null || code.isEmpty()) {
                response.getWriter().write("Error: No authorization code received from Google.");
                return;
            }

            // Send the authorization code to get the access token
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

            // Retrieve user information from Google
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

            System.out.println("[GoogleCallback] Logged in with Google:");
            System.out.println("Name: " + name);
            System.out.println("Email: " + email);

            UserDAO userDAO = new UserDAO();
            Optional<User> optionalUser = userDAO.getUserByEmail(email);

            User user;

            if (optionalUser.isPresent()) {
                // ✅ User already exists → retain the role_id from the database
                user = optionalUser.get();
                System.out.println("[GoogleCallback] User already exists, role ID: " + user.getRoleId());
            } else {
                // ❌ User doesn't exist → create new user and set the default role to 3
                user = new User();
                user.setFullName(name);
                user.setEmail(email);
                user.setStatus(1);
                user.setRoleId(3); // Default is customer
                user.setPassword("GOOGLE_USER"); // Temporary placeholder

                userDAO.insertUser(user);
                System.out.println("[GoogleCallback] Created new user with role ID: 3");
            }

            // Retrieve the user from the database to ensure consistency after insert
            user = userDAO.getUserByEmail(email).orElseThrow();

            // Store login information in the session
            request.getSession().setAttribute("loggedInUser", user);
            request.getSession().setAttribute("canChangePasswordWithoutOld", true);

            System.out.println("[GoogleCallback] Login successful with role: " + user.getRoleId());

            // Redirect to the home page
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.getWriter().write("Security error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("System error: " + e.getMessage());
        }
    }
}
