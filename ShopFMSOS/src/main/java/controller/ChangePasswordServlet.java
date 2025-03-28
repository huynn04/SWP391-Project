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


public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy các tham số từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        boolean allowWithoutOldPassword = Boolean.TRUE.equals(session.getAttribute("canChangePasswordWithoutOld"));
        UserDAO userDAO = new UserDAO();

        // Nếu không cho phép bỏ qua mật khẩu cũ thì phải xác minh
        if (!allowWithoutOldPassword) {
            if (!userDAO.verifyPassword(user.getEmail(), currentPassword)) {
                request.setAttribute("error", "Current password is incorrect.");
                request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                return;
            }
        }

        boolean updated = userDAO.updatePassword(user.getId(), newPassword);
        if (updated) {
            request.setAttribute("message", "Password updated successfully.");

            // Sau khi đổi mật khẩu thành công, xoá quyền "được bỏ qua mật khẩu cũ"
            session.removeAttribute("canChangePasswordWithoutOld");
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
        }

        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
}
