package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.util.Optional;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LoginServlet xử lý yêu cầu đăng nhập từ người dùng.
 */
public class LoginServlet extends HttpServlet {
    
    /**
     * Xử lý yêu cầu HTTP POST (đăng nhập).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        Optional<User> userOpt = userDAO.validateUser(email, password);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            if (user.getStatus() == 0) { // Nếu tài khoản bị khóa
                request.setAttribute("errorMessage", "Your account has been blocked.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Tạo session khi đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user); // Lưu thông tin người dùng vào session
            session.setAttribute("userRole", user.getRoleId()); // Lưu role để phân quyền
            
            response.sendRedirect("home"); // Chuyển hướng đến trang chủ
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý yêu cầu HTTP GET (ngăn chặn người dùng đã đăng nhập vào trang login).
     * Nếu người dùng đã đăng nhập, chuyển hướng đến trang chủ.
     * Nếu chưa đăng nhập, hiển thị trang đăng nhập.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect("home.jsp"); // Nếu đã đăng nhập, chuyển về home
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}