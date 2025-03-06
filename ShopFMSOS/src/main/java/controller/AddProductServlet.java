/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;
import dal.CategoryDAO;
import dal.ProductDAO;
import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
/**
 *
 * @author Tran Huy Lam CE180899 
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddProductServlet extends HttpServlet {

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
        // Lấy danh sách Category từ database
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);

        // Forward đến trang AddProduct.jsp
        request.getRequestDispatcher("AddProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String productName = request.getParameter("productName");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String detailDesc = request.getParameter("detailDesc");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            BigDecimal discount = new BigDecimal(request.getParameter("discount"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String target = request.getParameter("target");
            String factory = request.getParameter("factory");
            int status = Integer.parseInt(request.getParameter("status"));

            // Lấy category name từ categoryId
            String categoryName = categoryDAO.getCategoryNameById(categoryId);
            System.out.println("Category Name: " + categoryName);  // Debugging

            // Handle Image Upload
            Part filePart = request.getPart("image");
            String imageName = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
                imageName = "uploads/" + fileName;
            }

            // Tạo đối tượng Product
            Product product = new Product();
            product.setProductName(productName);
            product.setCategoryId(categoryId);
            product.setDetailDesc(detailDesc);
            product.setPrice(price);
            product.setDiscount(discount);
            product.setQuantity(quantity);
            product.setTarget(target);
            product.setFactory(factory);
            product.setStatus(status);
            product.setImage(imageName);

            // Thêm sản phẩm vào database
            boolean success = productDAO.addProduct(product);

            // Lấy danh sách Category để load lại trang
            List<Category> categoryList = categoryDAO.getAllCategories();
            request.setAttribute("categoryList", categoryList);

            if (success) {
                request.setAttribute("success", "✅ Product added successfully!");
            } else {
                request.setAttribute("error", "❌ Failed to add product. Please check the data.");
            }

            // Forward lại trang AddProduct.jsp
            request.getRequestDispatcher("AddProduct.jsp").forward(request, response);

        } catch (Exception e) {
            // Xử lý lỗi ngoại lệ và hiển thị lỗi
            e.printStackTrace();
            request.setAttribute("error", "❌ Error occurred: " + e.getMessage());

            // Load lại danh sách category khi có lỗi
            List<Category> categoryList = categoryDAO.getAllCategories();
            request.setAttribute("categoryList", categoryList);

            // Forward lại trang AddProduct.jsp
            request.getRequestDispatcher("AddProduct.jsp").forward(request, response);
        }
    }
}