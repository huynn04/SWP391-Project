package controller;

import dal.UserDAO;
import model.User;
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

        request.setAttribute("customer", optUser.get());
        request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new ServletException("UserId is missing!");
        }
        int userId = Integer.parseInt(userIdStr);

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        int status = Integer.parseInt(request.getParameter("status"));

        UserDAO userDAO = new UserDAO();
        Optional<User> optUser = userDAO.getUserById(userId);
        if (!optUser.isPresent()) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
            return;
        }
        User currentUser = optUser.get();

        Part filePart = request.getPart("avatar");
        String avatarPath = currentUser.getAvatar();

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
                String savedFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;

                filePart.write(realPath + File.separator + savedFileName);

                avatarPath = "image/" + savedFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        User updatedUser = new User();
        updatedUser.setUserId(userId);
        updatedUser.setFullName(fullName);
        updatedUser.setEmail(email);
        updatedUser.setPhoneNumber(phoneNumber);
        updatedUser.setAddress(address);
        updatedUser.setStatus(status);
        updatedUser.setUpdatedAt(new Date());
        updatedUser.setAvatar(avatarPath);

        boolean success = userDAO.updateUser(updatedUser);

        if (success) {
            response.sendRedirect("CustomerManager");
        } else {
            request.setAttribute("error", "Cập nhật thông tin khách hàng thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("EditCustomer.jsp").forward(request, response);
        }
    }
}
