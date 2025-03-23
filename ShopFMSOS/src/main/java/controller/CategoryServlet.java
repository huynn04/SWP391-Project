package controller;

import dal.CategoryDAO;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch all categories from CategoryDAO
        List<Category> categories = categoryDAO.getAllCategories();
        
        // Set the categories as a request attribute
        request.setAttribute("categoryList", categories);

        // Forward the request to the JSP page
        request.getRequestDispatcher("/ManageCategory.jsp").forward(request, response);
    }

}
