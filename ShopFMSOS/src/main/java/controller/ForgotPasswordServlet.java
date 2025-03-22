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

        // Kiểm tra nếu email rỗng
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu không
        UserDAO userDAO = new UserDAO();
        Optional<User> userOpt = userDAO.getUserByEmail(email);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            System.out.println("📌 Found user: " + user.getFullName());

            // Tạo mã token cho reset mật khẩu
            String token = UUID.randomUUID().toString();
            PasswordResetDAO resetDAO = new PasswordResetDAO();
            resetDAO.createPasswordResetToken(user.getUserId(), token);

            // Tạo liên kết reset mật khẩu
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

            // Gửi thông báo thành công tới người dùng
            request.setAttribute("successMessage", "A password reset link has been sent to your email.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
        } else {
            // Nếu email không tồn tại, báo lỗi cho người dùng
            request.setAttribute("errorMessage", "The email you entered is not registered. Please check again or sign up.");
            request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
        }
    }
}
