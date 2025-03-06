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
import java.util.Optional;
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
public class EditStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy id từ request
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("StaffManager");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            UserDAO userDao = new UserDAO();
            Optional<User> optionalStaff = userDao.getUserById(id);
            
            if (optionalStaff.isPresent()) {
                User staff = optionalStaff.get();
                // Kiểm tra xem có phải Staff không (giả sử roleId == 2 là Staff)
                if (staff.getRoleId() == 2) {
                    request.setAttribute("staff", staff);
                    request.getRequestDispatcher("EditStaff.jsp").forward(request, response);
                } else {
                    response.sendRedirect("StaffManager");
                }
            } else {
                response.sendRedirect("StaffManager");
            }
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            response.sendRedirect("StaffManager");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo request được đọc dưới dạng UTF-8
        request.setCharacterEncoding("UTF-8");

        // Lấy userId và thông tin text từ form
        int userId = Integer.parseInt(request.getParameter("userId"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        int status = Integer.parseInt(request.getParameter("status"));
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        // Lấy thông tin staff hiện tại từ DB (để giữ lại avatar cũ nếu không upload mới)
        UserDAO userDao = new UserDAO();
        Optional<User> optionalStaff = userDao.getUserById(userId);
        if (!optionalStaff.isPresent()) {
            request.setAttribute("error", "Staff not found!");
            request.getRequestDispatcher("EditStaff.jsp").forward(request, response);
            return;
        }
        User currentStaff = optionalStaff.get();

        // Xử lý file upload cho avatar
        Part filePart = request.getPart("avatar"); 
        // Nếu filePart không null và có kích thước > 0 thì xử lý upload, ngược lại giữ lại avatar cũ
        String newAvatarPath = currentStaff.getAvatar();
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Xác định đường dẫn thư mục lưu file (ví dụ: thư mục "uploads" trong webapps)
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            // Tạo thư mục nếu chưa tồn tại
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Đổi tên file để tránh trùng lặp (ví dụ: sử dụng userId + "_" + fileName)
            String savedFileName = fileName;
            File fileToSave = new File(uploadDir, savedFileName);

            // Ghi file lên server
            filePart.write(fileToSave.getAbsolutePath());

            // Lưu đường dẫn tương đối (có thể thay đổi theo cấu trúc project)
            newAvatarPath = "/image/" + savedFileName;
        }

        // Cập nhật thời gian updatedAt
        Date updatedAt = new Date();

        // Tạo đối tượng User cập nhật (giữ lại các trường khác như password, createdAt nếu cần)
        User updatedStaff = new User();
        updatedStaff.setUserId(userId);
        updatedStaff.setFullName(fullName);
        updatedStaff.setEmail(email);
        updatedStaff.setPhoneNumber(phoneNumber);
        updatedStaff.setAddress(address);
        updatedStaff.setStatus(status);
        updatedStaff.setRoleId(roleId);
        updatedStaff.setUpdatedAt(updatedAt);
        updatedStaff.setAvatar(newAvatarPath); // Avatar mới (hoặc cũ nếu không upload)

        // Gọi DAO để cập nhật thông tin staff
        boolean success = userDao.updateStaff(updatedStaff);

        if (success) {
            response.sendRedirect("StaffManager");
        } else {
            request.setAttribute("error", "Cập nhật thông tin thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("EditStaff.jsp").forward(request, response);
        }
    }
}