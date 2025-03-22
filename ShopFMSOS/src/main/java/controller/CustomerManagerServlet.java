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
public class CustomerManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạo đối tượng UserDAO
        UserDAO userDAO = new UserDAO();

        // Lấy tham số tìm kiếm và sắp xếp từ request (nếu có)
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        List<User> customerList;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Nếu có từ khóa tìm kiếm, gọi phương thức tìm kiếm và sắp xếp
            customerList = userDAO.searchAndSortCustomers(searchQuery, searchBy, sortBy);
        } else {
            // Nếu không có tìm kiếm, chỉ sắp xếp theo yêu cầu
            customerList = userDAO.getAllCustomers(sortBy);
        }

        // Đưa danh sách khách hàng vào request attribute
        request.setAttribute("customerList", customerList);

        // Forward đến trang CustomerManager.jsp
        request.getRequestDispatcher("CustomerManager.jsp").forward(request, response);
    }

}
