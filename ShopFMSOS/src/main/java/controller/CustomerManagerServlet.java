package controller;

import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * CustomerManagerServlet xử lý yêu cầu quản lý danh sách khách hàng.
 * Hỗ trợ tìm kiếm, sắp xếp và hiển thị danh sách khách hàng.
 */
public class CustomerManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạo đối tượng UserDAO để truy cập dữ liệu người dùng
        UserDAO userDAO = new UserDAO();

        // Lấy các tham số tìm kiếm và sắp xếp từ request (nếu có)
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        // Danh sách khách hàng
        List<User> customerList;

        // Nếu có từ khóa tìm kiếm, gọi phương thức tìm kiếm và sắp xếp
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customerList = userDAO.searchAndSortCustomers(searchQuery, searchBy, sortBy);
        } else {
            // Nếu không có tìm kiếm, chỉ sắp xếp theo yêu cầu
            customerList = userDAO.getAllCustomers(sortBy);
        }

        // Đưa danh sách khách hàng vào request attribute để hiển thị trên JSP
        request.setAttribute("customerList", customerList);

        // Chuyển hướng tới trang CustomerManager.jsp để hiển thị kết quả
        request.getRequestDispatcher("CustomerManager.jsp").forward(request, response);
    }
}
