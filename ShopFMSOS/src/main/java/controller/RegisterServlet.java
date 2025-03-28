package controller;

import dal.UserDAO;
import dal.EmailService; // Import lớp EmailService để gửi email
import model.User;
import utils.HashUtil; // Import HashUtil để mã hóa mật khẩu
import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * RegisterServlet xử lý yêu cầu đăng ký tài khoản từ người dùng.
 */
public class RegisterServlet extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP POST (đăng ký).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra các trường không được để trống
        if (firstName == null || firstName.isEmpty() || lastName == null || lastName.isEmpty()
                || email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "First Name, Last Name, Email, and Password are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng email
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorMessage", "Invalid email format.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 số, 1 ký tự đặc biệt
        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.matches(".*[A-Z].*") || !password.matches(".*\\d.*") || !password.matches(".*\\W.*")) {
            request.setAttribute("errorMessage", "Password must contain at least 1 uppercase letter, 1 number, and 1 special character.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Password and Confirm Password do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Mã hóa mật khẩu người dùng nhập vào với MD5
        String hashedPassword = HashUtil.md5(password);

        String fullName = firstName + " " + lastName;
        int roleId = 3; // Giả định role mặc định là 3
        int status = 1; // 1 = Active
        Date createdAt = new Date();
        Date updatedAt = new Date();

        User user = new User(0, roleId, fullName, email, "", "", hashedPassword, "default-avatar.png", status, createdAt, updatedAt);
        UserDAO userDAO = new UserDAO();

        boolean isInserted = userDAO.insertUser(user);

        if (isInserted) {
            // Gửi email chào mừng
            String subject = "Welcome to ShopFMSOS!";
            String content = "Hello " + fullName + ",\n\n"
                    + "Thank you for signing up at ShopFMSOS!\n"
                    + "Your account has been successfully created.\n\n"
                    + "You can now log in using your email: " + email + "\n\n"
                    + "Best regards,\n"
                    + "ShopFMSOS Team";

            EmailService.sendEmail(email, subject, content);

            // Đăng nhập tự động sau khi đăng ký thành công
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            // Chuyển hướng sang trang home.jsp
            response.sendRedirect("home.jsp?userId=" + user.getUserId());
        } else {
            request.setAttribute("errorMessage", "Registration failed. Email might already be in use.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
