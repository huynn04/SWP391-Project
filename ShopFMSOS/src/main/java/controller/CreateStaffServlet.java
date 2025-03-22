/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.User;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 25    // 25 MB
)
public class CreateStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển tiếp đến trang CreateStaff.jsp
        request.getRequestDispatcher("CreateStaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo đọc dữ liệu UTF-8
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        int status = Integer.parseInt(request.getParameter("status"));
        // Role mặc định cho staff là 2
        int roleId = 2;

        // Xử lý file upload cho avatar
        Part filePart = request.getPart("avatar");
        String avatarPath = "";
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Xác định thư mục upload: ví dụ thư mục "uploads" trong thư mục gốc của ứng dụng
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Đổi tên file để tránh trùng lặp: sử dụng thời gian hiện tại làm định danh
            String savedFileName = roleId + "_" + System.currentTimeMillis() + "_" + fileName;
            File fileToSave = new File(uploadDir, savedFileName);
            
            // Ghi file lên server
            filePart.write(fileToSave.getAbsolutePath());
            
            // Lưu đường dẫn tương đối (cấu trúc của project)
            avatarPath = "/uploads/" + savedFileName;
        } else {
            // Nếu không chọn file, sử dụng avatar mặc định (đảm bảo đường dẫn này đúng trong CSDL)
            avatarPath = "image/avatarnull.jpg";
        }

        // Thiết lập thời gian tạo và cập nhật
        Date now = new Date();

        // Tạo đối tượng User mới
        User newStaff = new User();
        newStaff.setFullName(fullName);
        newStaff.setEmail(email);
        newStaff.setPhoneNumber(phoneNumber);
        newStaff.setAddress(address);
        newStaff.setPassword(password);
        newStaff.setAvatar(avatarPath);
        newStaff.setStatus(status);
        newStaff.setRoleId(roleId);
        newStaff.setCreatedAt(now);
        newStaff.setUpdatedAt(now);

        // Gọi DAO để thêm user
        UserDAO userDao = new UserDAO();
        boolean inserted = userDao.insertUser(newStaff);

        if (inserted) {
            // Nếu tạo thành công, chuyển hướng đến trang quản lý nhân viên
            response.sendRedirect("StaffManager");
        } else {
            // Nếu tạo thất bại, hiển thị thông báo lỗi
            request.setAttribute("error", "Failed to create staff. Please try again.");
            request.getRequestDispatcher("CreateStaff.jsp").forward(request, response);
        }
    }
}