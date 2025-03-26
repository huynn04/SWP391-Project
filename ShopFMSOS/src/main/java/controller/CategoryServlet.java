package controller;

import dal.CategoryDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Thêm annotation để ánh xạ URL
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;

public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortOption = request.getParameter("sortOption");
        if (sortOption == null) {
            sortOption = "name-asc"; // Mặc định sắp xếp A-Z
        }

        // Lấy danh sách category đã sắp xếp
        List<Category> categories = categoryDAO.getAllCategoriesSorted(sortOption);

        request.setAttribute("categories", categories); // Đưa danh sách vào request
        request.setAttribute("sortOption", sortOption); // Lưu sortOption để giữ trạng thái dropdown
        RequestDispatcher dispatcher = request.getRequestDispatcher("categories.jsp");
        dispatcher.forward(request, response);
    }
}