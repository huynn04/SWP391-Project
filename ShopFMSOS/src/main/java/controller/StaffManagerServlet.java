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
import java.util.List;
import model.User;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class StaffManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các tham số tìm kiếm và sắp xếp từ request (nếu có)
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        // Khởi tạo đối tượng DAO
        UserDAO userDao = new UserDAO();
        List<User> staffList;

        // Nếu có từ khóa tìm kiếm thì dùng phương thức searchAndSortStaff, ngược lại dùng getAllStaff
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            staffList = userDao.searchAndSortStaff(searchQuery, searchBy, sortBy);
        } else {
            staffList = userDao.getAllStaff(sortBy);
        }

        // Đưa danh sách staff vào request attribute
        request.setAttribute("staffList", staffList);

        // Chuyển tiếp request đến JSP để hiển thị danh sách
        request.getRequestDispatcher("StaffManager.jsp").forward(request, response);
    }

}
