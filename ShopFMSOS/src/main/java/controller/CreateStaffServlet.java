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
import utils.HashUtil;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5, // 5 MB
        maxRequestSize = 1024 * 1024 * 25 // 25 MB
)
public class CreateStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("CreateStaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        int status = Integer.parseInt(request.getParameter("status"));
        int roleId = 2;

        // Mã hóa mật khẩu bằng MD5
        String hashedPassword = HashUtil.md5(password);

        // Xử lý upload avatar vào src/main/webapp/image
        Part filePart = request.getPart("avatar");
        String avatarPath = "NULL"; // Mặc định

        try {
            if (filePart != null && filePart.getSize() > 0) {
                String picFolder = "src/main/webapp/image";
                String projectPath = getServletContext().getRealPath("/").split("target")[0];
                String realPath = projectPath + picFolder;

                File uploadDir = new File(realPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String savedFileName = roleId + "_" + System.currentTimeMillis() + "_" + fileName;

                filePart.write(realPath + File.separator + savedFileName);

                avatarPath = "image/" + savedFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Date now = new Date();

        // Tạo đối tượng User và set thông tin đã được mã hóa mật khẩu
        User newStaff = new User();
        newStaff.setFullName(fullName);
        newStaff.setEmail(email);
        newStaff.setPhoneNumber(phoneNumber);
        newStaff.setAddress(address);
        newStaff.setPassword(hashedPassword);  // Lưu mật khẩu đã mã hóa
        newStaff.setAvatar(avatarPath);
        newStaff.setStatus(status);
        newStaff.setRoleId(roleId);
        newStaff.setCreatedAt(now);
        newStaff.setUpdatedAt(now);

        UserDAO userDao = new UserDAO();
        boolean inserted = userDao.insertUser(newStaff);

        if (inserted) {
            response.sendRedirect("StaffManager");
        } else {
            request.setAttribute("error", "Failed to create staff. Please try again.");
            request.getRequestDispatcher("CreateStaff.jsp").forward(request, response);
        }
    }

}
