package controller;

import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

import java.io.IOException;
import java.util.List;

public class ViewProductByCateServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy categoryId từ URL
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Truy vấn tất cả sản phẩm thuộc categoryId này
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getProductsByCategoryId(categoryId);

        // Gửi danh sách sản phẩm vào JSP để hiển thị
        request.setAttribute("products", products);
        request.setAttribute("categoryId", categoryId);  // Thêm categoryId để dùng khi cần
        request.getRequestDispatcher("viewproductsbycate.jsp").forward(request, response);
    }
}