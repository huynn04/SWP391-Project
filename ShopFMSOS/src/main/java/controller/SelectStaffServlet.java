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
import java.util.Date;
import java.util.List;
import model.User;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
   
public class SelectStaffServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDao = new UserDAO();

        String selectedId = request.getParameter("selectedId");
        if (selectedId != null && !selectedId.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(selectedId);
                User customer = userDao.getUserById(customerId).orElse(null);
                if (customer == null) {
                    request.setAttribute("error", "Không tìm thấy khách hàng với ID: " + selectedId);
                } else if (customer.getRoleId() != 3) {
                    request.setAttribute("error", "Người dùng với ID: " + selectedId + " không phải là khách hàng!");
                } else {
                    customer.setRoleId(2); // Change to Staff
                    customer.setUpdatedAt(new Date());
                    boolean updated = userDao.updateStaff(customer);
                    if (updated) {
                        response.sendRedirect("StaffManager");
                        return;
                    } else {
                        request.setAttribute("error", "Cập nhật vai trò thất bại!");
                    }
                }
            } catch (NumberFormatException ex) {
                request.setAttribute("error", "ID không hợp lệ: " + selectedId);
            }
            request.getRequestDispatcher("SelectStaff.jsp").forward(request, response);
            return;
        }

        // Display customer list if no selection
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        List<User> customerList;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customerList = userDao.searchAndSortCustomers(searchQuery, searchBy, sortBy);
        } else {
            customerList = userDao.getAllCustomers(sortBy);
        }

        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("SelectStaff.jsp").forward(request, response);
    }
}
