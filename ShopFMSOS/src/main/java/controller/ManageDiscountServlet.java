package controller;

import dal.DiscountDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Discount;

import java.io.IOException;
import java.util.List;


public class ManageDiscountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        // Mặc định giá trị cho searchBy và sortBy nếu không có
        if (searchBy == null || searchBy.isEmpty()) searchBy = "code";  // Tìm kiếm theo mã giảm giá mặc định
        if (sortBy == null || sortBy.isEmpty()) sortBy = "code";        // Sắp xếp theo mã giảm giá mặc định

        DiscountDAO discountDAO = new DiscountDAO();
        
        // Lấy danh sách mã giảm giá từ cơ sở dữ liệu với các tham số tìm kiếm và sắp xếp
        List<Discount> discountList = discountDAO.searchDiscounts(searchQuery, searchBy, sortBy);

        // Gửi dữ liệu đến JSP
        request.setAttribute("discountList", discountList);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("sortBy", sortBy);

        // Chuyển hướng đến trang ManageDiscount.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/ManageDiscount.jsp");
        dispatcher.forward(request, response);
    }
}
