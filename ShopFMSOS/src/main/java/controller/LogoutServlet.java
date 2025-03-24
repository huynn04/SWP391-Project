package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xử lý đăng xuất người dùng.
 */
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại, nếu có
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session
        }
        // Chuyển hướng về trang đăng nhập
        response.sendRedirect("login.jsp");
    }
}
