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
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5, // 5 MB
        maxRequestSize = 1024 * 1024 * 25 // 25 MB
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

        // Xử lý upload ảnh đại diện
        String img = user.getAvatar(); // Mặc định là avatar cũ
        try {
            Part part = request.getPart("avatar");
            if (part != null && part.getSize() > 0) {
                // Đường dẫn lưu ảnh vào thư mục src/main/webapp/image
                String picFolder = "src/main/webapp/image"; // Đưa trực tiếp vào source

                // Lấy đường dẫn thư mục gốc của project
                String projectPath = getServletContext().getRealPath("/").split("target")[0];

                // Đường dẫn tuyệt đối của thư mục image trong project
                String realPath = projectPath + picFolder;

                File uploadDir = new File(realPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // Tạo thư mục nếu chưa có
                }

                // Lấy tên file ảnh
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String savedFileName = System.currentTimeMillis() + "_" + fileName;

                // Lưu ảnh vào thư mục
                part.write(realPath + File.separator + savedFileName);

                // Lưu đường dẫn ảnh để hiển thị trên JSP
                img = "image/" + savedFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Cập nhật thông tin người dùng
        user.setFullName(fullName);
        user.setPhoneNumber(phone);
        user.setAddress(address);
        user.setAvatar(img); // Cập nhật ảnh đại diện mới

        // Gọi DAO để cập nhật thông tin người dùng vào DB
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateUserProfile(user);

        if (success) {
            session.setAttribute("loggedInUser", user); // Cập nhật lại thông tin người dùng trong session
            response.sendRedirect("viewProfile.jsp"); // Điều hướng đến trang View Profile
        } else {
            request.setAttribute("error", "Failed to update profile.");
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
        }
    }
}
