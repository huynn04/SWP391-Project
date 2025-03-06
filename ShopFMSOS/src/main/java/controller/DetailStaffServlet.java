/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Optional;
import model.User;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class DetailStaffServlet extends HttpServlet {
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số id từ request
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("StaffManager"); // Nếu không có id, chuyển hướng về trang quản lý staff
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            UserDAO userDao = new UserDAO();
            Optional<User> staffOpt = userDao.getUserById(id);
            
            if (staffOpt.isPresent()) {
                User staff = staffOpt.get();
                // Kiểm tra roleId có phải của nhân viên không (ví dụ: roleId == 2)
                if (staff.getRoleId() == 2) {
                    request.setAttribute("staff", staff);
                    request.getRequestDispatcher("DetailStaff.jsp").forward(request, response);
                } else {
                    // Nếu không phải nhân viên, chuyển hướng hoặc hiển thị thông báo lỗi
                    response.sendRedirect("StaffManager");
                }
            } else {
                // Nếu không tìm thấy staff, chuyển hướng về trang quản lý staff
                response.sendRedirect("StaffManager");
            }
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            response.sendRedirect("StaffManager");
        }
    }

}
