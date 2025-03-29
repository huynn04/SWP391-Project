package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class DeleteCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        // Cập nhật category_id của tất cả các sản phẩm thuộc danh mục này thành 13
        ProductDAO productDAO = new ProductDAO();
        boolean isUpdated = productDAO.updateProductCategory(categoryId); // Cập nhật tất cả sản phẩm có category_id = categoryId thành category_id = 13

        if (isUpdated) {
            // Sau khi tất cả các sản phẩm đã được chuyển sang category_id = 13, tiến hành xóa danh mục
            CategoryDAO categoryDAO = new CategoryDAO();
            boolean isDeleted = categoryDAO.deleteCategory(categoryId); // Xóa danh mục khỏi bảng categories

            if (isDeleted) {
                response.sendRedirect("CategoryServlet"); // Sau khi xóa danh mục, chuyển hướng về danh sách danh mục
            } else {
                response.sendRedirect("CategoryServlet?error=deleteFailed"); // Nếu xóa danh mục thất bại
            }
        } else {
            response.sendRedirect("CategoryServlet?error=updateFailed"); // Nếu cập nhật sản phẩm thất bại
        }
    }
}
