package controller;

import dal.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 5,     // 5 MB
    maxRequestSize = 1024 * 1024 * 25  // 25 MB
)
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
        String phone = request.getParameter("phoneNumber");
        String address = request.getParameter("address");

        // Lấy phần ảnh tải lên
        Part filePart = request.getPart("avatar");  // Avatar file
        String avatarPath = user.getAvatar();  // Giữ avatar cũ nếu không chọn ảnh mới

        // Kiểm tra nếu người dùng chọn ảnh mới
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Định nghĩa thư mục lưu trữ ảnh
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();  // Tạo thư mục nếu chưa có
            }

            // Đổi tên file để tránh trùng lặp và lưu ảnh
            String savedFileName =fileName;
            File fileToSave = new File(uploadDir, savedFileName);
            filePart.write(fileToSave.getAbsolutePath());

            // Cập nhật đường dẫn ảnh vào avatarPath
            avatarPath = "/image/" + savedFileName;  // Đường dẫn tương đối
        }

        // Cập nhật thông tin người dùng
        user.setFullName(fullName);
        user.setAvatar(avatarPath);
        user.setPhoneNumber(phone);
        user.setAddress(address);

        // Gọi DAO để cập nhật thông tin người dùng trong database
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateUserProfile(user);

        if (success) {
            // Cập nhật lại thông tin người dùng trong session
            session.setAttribute("loggedInUser", user);  // Lưu lại thông tin mới của người dùng vào session

            response.sendRedirect("viewProfile.jsp");  // Điều hướng đến trang View Profile
        } else {
            request.setAttribute("error", "Failed to update profile.");
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
        }
    }
}
