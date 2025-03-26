package controller;

import dal.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String avatar = request.getParameter("avatar");
        String phone = request.getParameter("phoneNumber");
        String address = request.getParameter("address");

        // Cập nhật user
        user.setFullName(fullName);
        user.setAvatar(avatar);
        user.setPhoneNumber(phone);
        user.setAddress(address);

        // Gọi DAO để cập nhật database
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateUserProfile(user);

        if (success) {
            // ✅ Cập nhật lại thông tin người dùng trong session
            session.setAttribute("loggedInUser", user); // Lưu lại thông tin mới của người dùng vào session

            response.sendRedirect("viewProfile.jsp"); // Điều hướng đến trang View Profile để hiển thị thông tin mới
        } else {
            request.setAttribute("error", "Failed to update profile.");
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
        }
    }
}
