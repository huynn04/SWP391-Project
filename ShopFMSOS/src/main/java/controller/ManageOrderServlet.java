package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Thêm annotation để ánh xạ URL
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Order;

public class ManageOrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = null;
        String filterType = request.getParameter("filterType");
        String filterValue = request.getParameter("filterValue");
        String sortOption = request.getParameter("sortOption");

        if (sortOption == null) {
            sortOption = "total-desc"; // Mặc định sắp xếp giảm dần theo total_price
        }

        try {
            // Kiểm tra filter và sort
            if (filterType != null && filterValue != null && !filterValue.trim().isEmpty()) {
                orders = orderDAO.searchOrdersSorted(filterType, filterValue, sortOption); // Tìm kiếm với sort
            } else {
                orders = orderDAO.getAllOrdersSorted(sortOption); // Lấy tất cả với sort
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Đặt dữ liệu vào request
        request.setAttribute("orders", orders);
        request.setAttribute("sortOption", sortOption); // Lưu sortOption để giữ trạng thái dropdown

        // Chuyển tiếp tới manageorder.jsp
        request.getRequestDispatcher("manageorder.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Chuyển POST sang GET để xử lý đồng nhất
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing orders";
    }
}