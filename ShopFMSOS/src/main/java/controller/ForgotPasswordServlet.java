package controller;

import dal.PasswordResetDAO;
import dal.UserDAO;
import dal.EmailService;  // Thêm import này
import model.User;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý yêu cầu quên mật khẩu.
 */
public class ForgotPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("📌 ForgotPasswordServlet received a request!");

        String email = request.getParameter("email");
        System.out.println("📌 Received email: " + email);

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        Optional<User> userOpt = userDAO.getUserByEmail(email);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            System.out.println("📌 Found user: " + user.getFullName());

            // Tạo mã token
            String token = UUID.randomUUID().toString();
            PasswordResetDAO resetDAO = new PasswordResetDAO();
            resetDAO.createPasswordResetToken(user.getUserId(), token);

            // Tạo link đặt lại mật khẩu
            String resetLink = "http://localhost:8080/resetpassword.jsp?token=" + token;
            System.out.println("📌 Reset link: " + resetLink);

            // Gửi email qua EmailService
            String subject = "Password Reset Request";
            String content = "Hello " + user.getFullName() + ",\n\n"
                    + "We received a request to reset your password. Click the link below to reset it:\n"
                    + resetLink + "\n\n"
                    + "If you did not request this, please ignore this email.\n\n"
                    + "Best regards,\nShopFMSOS Team";

            EmailService.sendEmail(email, subject, content);

            request.setAttribute("successMessage", "A password reset link has been sent to your email.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Email not found.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
        }
    }
}
