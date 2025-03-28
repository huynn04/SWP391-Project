package controller;

import dal.PasswordResetDAO;
import dal.UserDAO;
import utils.HashUtil;  // Import HashUtil để mã hóa mật khẩu

import java.io.IOException;
import java.util.Optional;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý yêu cầu đặt lại mật khẩu.
 */
public class ResetPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.isEmpty()) {
            request.setAttribute("errorMessage", "Invalid reset link.");
            request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("resetpassword.jsp?token=" + token).forward(request, response);
            return;
        }

        PasswordResetDAO resetDAO = new PasswordResetDAO();
        UserDAO userDAO = new UserDAO();

        // Kiểm tra token có hợp lệ không
        Optional<Integer> userIdOpt = resetDAO.getUserIdByToken(token);
        if (userIdOpt.isPresent()) {
            int userId = userIdOpt.get();

            // Mã hóa mật khẩu mới với MD5
            String hashedNewPassword = HashUtil.md5(newPassword);

            // Cập nhật mật khẩu mới
            boolean isUpdated = userDAO.updateUserPassword(userId, hashedNewPassword);
            if (isUpdated) {
                resetDAO.deleteToken(token); // Xóa token sau khi sử dụng
                request.setAttribute("successMessage", "Password reset successfully. You can now login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to reset password.");
                request.getRequestDispatcher("resetpassword.jsp?token=" + token).forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Invalid or expired token.");
            request.getRequestDispatcher("resetpassword.jsp").forward(request, response);
        }
    }
}
