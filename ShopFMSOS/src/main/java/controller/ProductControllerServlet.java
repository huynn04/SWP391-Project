package controller;

import dal.ProductDAO;
import dal.CategoryDAO;
import model.Product;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductControllerServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ request
        String searchQuery = request.getParameter("searchQuery");
        String[] selectedCategories = request.getParameterValues("categoryId");

        // Lấy danh sách danh mục và sản phẩm
        List<Category> categories = categoryDAO.getAllCategories();
        List<Product> products = productDAO.getFilteredProducts(searchQuery, selectedCategories);

        // Truyền dữ liệu vào JSP
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("selectedCategories", selectedCategories);

        // Điều hướng đến trang JSP
        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }
}
