package controller;

import dal.CategoryDAO;
import model.Category;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        if (categories != null && !categories.isEmpty()) {
            request.setAttribute("categories", categories);  // Gán đúng thuộc tính categories vào request
            request.getRequestDispatcher("/ManageCategory.jsp").forward(request, response);
        } else {
            // Xử lý trường hợp không có danh mục (optional)
            request.setAttribute("message", "No categories found.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("addCategory")) {
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            int status = Integer.parseInt(request.getParameter("status"));

            Category category = new Category();
            category.setCategoryName(categoryName);
            category.setDescription(description);
            category.setImage(image);
            category.setStatus(status);

            CategoryDAO categoryDAO = new CategoryDAO();
            categoryDAO.addCategory(category);

            response.sendRedirect("categoryList.jsp");
        }
    }

}
