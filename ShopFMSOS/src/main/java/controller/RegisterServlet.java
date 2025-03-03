package controller;

import dal.UserDAO;
import dal.EmailService; // Import lớp EmailService để gửi email
import model.User;
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
        
        if (firstName == null || lastName == null || email == null || password == null ||
            firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "First Name, Last Name, Email, and Password are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        String fullName = firstName + " " + lastName;
        int roleId = 3; // Giả định role mặc định là 3
        int status = 1; // 1 = Active
        Date createdAt = new Date();
        Date updatedAt = new Date();
        
        User user = new User(0, roleId, fullName, email, "", "", password, "default-avatar.png", status, createdAt, updatedAt);
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
            response.sendRedirect("login.jsp?success=1");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Email might already be in use.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý yêu cầu HTTP GET (chuyển hướng đến trang đăng ký nếu cần).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
