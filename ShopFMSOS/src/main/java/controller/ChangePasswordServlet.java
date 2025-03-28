package controller;

import dal.UserDAO;
import model.User;
import utils.HashUtil;  // Import HashUtil để mã hóa mật khẩu

import jakarta.servlet.ServletException;
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

        // Kiểm tra mật khẩu mới có đủ độ dài và chứa chữ hoa, số, ký tự đặc biệt không
        if (newPassword.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches(".*[A-Z].*") || !newPassword.matches(".*\\d.*") || !newPassword.matches(".*\\W.*")) {
            request.setAttribute("error", "Password must contain at least 1 uppercase letter, 1 number, and 1 special character.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra nếu mật khẩu mới và xác nhận mật khẩu trùng khớp
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        boolean allowWithoutOldPassword = Boolean.TRUE.equals(session.getAttribute("canChangePasswordWithoutOld"));
        UserDAO userDAO = new UserDAO();

        // Kiểm tra nếu người dùng không phải là GOOGLE_USER thì yêu cầu mật khẩu cũ
        if (!user.getPassword().equals("GOOGLE_USER")) {
            // Nếu không cho phép bỏ qua mật khẩu cũ thì phải xác minh
            if (!allowWithoutOldPassword) {
                // Mã hóa mật khẩu cũ nhập vào và so sánh với mật khẩu trong cơ sở dữ liệu
                String hashedCurrentPassword = HashUtil.md5(currentPassword);  // Mã hóa mật khẩu cũ

                // Xác minh mật khẩu cũ với cơ sở dữ liệu
                if (!userDAO.verifyPassword(user.getEmail(), hashedCurrentPassword)) {
                    request.setAttribute("error", "Current password is incorrect.");
                    request.getRequestDispatcher("changePassword.jsp").forward(request, response);
                    return;
                }
            }
        }

        // Mã hóa mật khẩu mới với MD5
        String hashedNewPassword = HashUtil.md5(newPassword);

        // Cập nhật mật khẩu mới vào cơ sở dữ liệu
        boolean updated = userDAO.updatePassword(user.getId(), hashedNewPassword);
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
