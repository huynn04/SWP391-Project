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

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class DeleteStaffServlet extends HttpServlet {
   
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy userId từ query string
        String userIdParam = request.getParameter("id");
        if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);

            // Tạo đối tượng UserDAO để thực hiện xóa
            UserDAO userDAO = new UserDAO();

            // Xóa nhân viên khỏi cơ sở dữ liệu
            boolean isDeleted = userDAO.deleteUser(userId);

            // Kiểm tra kết quả và chuyển hướng đến trang StaffManager
            if (isDeleted) {
                response.sendRedirect("StaffManager"); // Chuyển hướng lại trang StaffManager nếu xóa thành công
            } else {
                // Nếu xóa thất bại, có thể hiển thị thông báo lỗi
                request.setAttribute("errorMessage", "Unable to delete the staff member.");
                request.getRequestDispatcher("StaffManager.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("StaffManager"); // Nếu không có id, chuyển hướng về trang StaffManager
        }
    }

}
