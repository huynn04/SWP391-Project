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
        
        // Nếu có tham số "selectedId" nghĩa là người dùng đã chọn một khách hàng để chuyển thành Staff
        String selectedId = request.getParameter("selectedId");
        if (selectedId != null && !selectedId.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(selectedId);
                // Lấy thông tin khách hàng từ DB (role_id = 3)
                User customer = userDao.getUserById(customerId).orElse(null);
                if (customer != null) {
                    // Cập nhật role thành Staff (role_id = 2)
                    customer.setRoleId(2);
                    customer.setUpdatedAt(new Date());
                    // Gọi phương thức updateStaff để cập nhật thông tin (DAO updateStaff đã hỗ trợ cập nhật role_id)
                    boolean updated = userDao.updateStaff(customer);
                    if (updated) {
                        // Sau khi cập nhật thành công, chuyển hướng đến trang quản lý Staff
                        response.sendRedirect("StaffManager");
                        return;
                    } else {
                        request.setAttribute("error", "Có lỗi trong quá trình cập nhật thông tin.");
                    }
                } else {
                    request.setAttribute("error", "Không tìm thấy khách hàng với id: " + selectedId);
                }
            } catch (NumberFormatException ex) {
                request.setAttribute("error", "Id không hợp lệ!");
            }
            // Nếu có lỗi, chuyển tiếp về trang SelectStaff để hiển thị thông báo lỗi.
            request.getRequestDispatcher("SelectStaff.jsp").forward(request, response);
            return;
        }
        
        // Nếu không có tham số selectedId, hiển thị danh sách khách hàng để chọn
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");
        
        List<User> customerList;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customerList = userDao.searchAndSortCustomers(searchQuery, searchBy, sortBy);
        } else {
            customerList = userDao.getAllCustomers(sortBy);
        }
        
        // Đưa danh sách khách hàng vào request attribute (đặt tên là customerList để rõ ràng)
        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("SelectStaff.jsp").forward(request, response);
    }
}
