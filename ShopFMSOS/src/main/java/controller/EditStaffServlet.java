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
    maxFileSize = 1024 * 1024 * 5,     // 5 MB
    maxRequestSize = 1024 * 1024 * 25  // 25 MB
)
public class EditStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        request.setCharacterEncoding("UTF-8");

        int userId = Integer.parseInt(request.getParameter("userId"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        int status = Integer.parseInt(request.getParameter("status"));
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        UserDAO userDao = new UserDAO();
        Optional<User> optionalStaff = userDao.getUserById(userId);
        if (!optionalStaff.isPresent()) {
            request.setAttribute("error", "Staff not found!");
            request.getRequestDispatcher("EditStaff.jsp").forward(request, response);
            return;
        }
        User currentStaff = optionalStaff.get();

        // Handle avatar upload
        Part filePart = request.getPart("avatar"); 
        String newAvatarPath = currentStaff.getAvatar();
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "image";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String savedFileName = System.currentTimeMillis() + "_" + fileName;
            File fileToSave = new File(uploadDir, savedFileName);

            filePart.write(fileToSave.getAbsolutePath());
            newAvatarPath = "image/" + savedFileName; 
        }

        Date updatedAt = new Date();
        User updatedStaff = new User();
        updatedStaff.setUserId(userId);
        updatedStaff.setFullName(fullName);
        updatedStaff.setEmail(email);
        updatedStaff.setPhoneNumber(phoneNumber);
        updatedStaff.setAddress(address);
        updatedStaff.setStatus(status);
        updatedStaff.setRoleId(roleId);
        updatedStaff.setUpdatedAt(updatedAt);
        updatedStaff.setAvatar(newAvatarPath);

        boolean success = userDao.updateStaff(updatedStaff);

        if (success) {
            response.sendRedirect("StaffManager");
        } else {
            request.setAttribute("error", "Update failed. Please try again.");
            request.getRequestDispatcher("EditStaff.jsp").forward(request, response);
        }
    }
}
