/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import model.User;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Date;
import java.util.Optional;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 5,     // 5 MB
    maxRequestSize = 1024 * 1024 * 25  // 25 MB
)
public class EditCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("CustomerManager");
            return;
        }
        int userId = Integer.parseInt(idStr);

        UserDAO userDAO = new UserDAO();
        Optional<User> optUser = userDAO.getUserById(userId);
        if (!optUser.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }

        // Gửi thông tin user sang trang EditCustomer.jsp
        request.setAttribute("customer", optUser.get());
        request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo request được đọc dưới dạng UTF-8
        request.setCharacterEncoding("UTF-8");

        // Lấy userId
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new ServletException("UserId is missing!");
        }
        int userId = Integer.parseInt(userIdStr);

        // Lấy thông tin text
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        int status = Integer.parseInt(request.getParameter("status"));

        // Lấy thông tin user hiện tại từ DB (để giữ lại avatar cũ nếu không upload mới)
        UserDAO userDAO = new UserDAO();
        Optional<User> optUser = userDAO.getUserById(userId);
        if (!optUser.isPresent()) {
            // Nếu không tìm thấy user, báo lỗi
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
            return;
        }
        User currentUser = optUser.get();

        // Lấy file upload (avatar)
        Part filePart = request.getPart("avatar"); 
        // filePart có thể null nếu form không có input type="file",
        // hoặc size = 0 nếu không chọn file nào

        String newAvatarPath = currentUser.getAvatar(); // Mặc định giữ avatar cũ
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc (nếu cần)
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Định nghĩa đường dẫn thư mục để lưu file
            // Giả sử bạn có thư mục "uploads" trong thư mục gốc (webapps/YourProject/uploads)
            // Hoặc tuyệt đối: "C:/path/to/uploads"
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            // Tạo thư mục nếu chưa có
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Tạo file đích (nên đổi tên file để tránh trùng lặp)
            // Ở đây mình dùng userId + "_" + tên file gốc
            String savedFileName = fileName;
            File fileToSave = new File(uploadDir, savedFileName);

            // Ghi file lên server
            filePart.write(fileToSave.getAbsolutePath());

            // Lưu đường dẫn vào DB (chỉ cần lưu relative path nếu muốn)
            // Ví dụ: "/uploads/3_avatar.png"
            newAvatarPath = "/image/" + savedFileName;
        }

        // Tạo đối tượng User để update
        User updatedUser = new User();
        updatedUser.setUserId(userId);
        updatedUser.setFullName(fullName);
        updatedUser.setEmail(email);
        updatedUser.setPhoneNumber(phoneNumber);
        updatedUser.setAddress(address);
        updatedUser.setStatus(status);
        updatedUser.setUpdatedAt(new Date());
        updatedUser.setAvatar(newAvatarPath); // Gán avatar mới (hoặc cũ nếu không upload)

        // Gọi DAO để cập nhật
        boolean success = userDAO.updateUser(updatedUser);

        if (success) {
            response.sendRedirect("CustomerManager");
        } else {
            request.setAttribute("error", "Cập nhật thông tin khách hàng thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
        }
    }
}