/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import model.Product;
/**
 *
 * @author Tran Huy Lam CE180899 
 */

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 5,     // 5 MB
    maxRequestSize = 1024 * 1024 * 25  // 25 MB
)
public class EditProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy id từ request
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("ManageProduct");
            return;
        }
        try {
            int productId = Integer.parseInt(idParam);
            ProductDAO productDao = new ProductDAO();
            Product product = productDao.getProductById(productId);

            if (product != null) {
                // Lấy tất cả danh mục sản phẩm để hiển thị trong dropdown
                CategoryDAO categoryDao = new CategoryDAO();  // Khởi tạo CategoryDAO để lấy danh sách category
                request.setAttribute("product", product);
                request.setAttribute("categoryList", categoryDao.getAllCategories());  // Lấy danh sách category
                request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect("ManageProduct");
            }
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
            response.sendRedirect("ManageProduct");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đảm bảo request được đọc dưới dạng UTF-8
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin sản phẩm từ form
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String detailDesc = request.getParameter("detailDesc");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");
        String quantityStr = request.getParameter("quantity");
        int status = Integer.parseInt(request.getParameter("status"));

        // Lấy thông tin sản phẩm hiện tại từ DB (để giữ lại ảnh cũ nếu không upload mới)
        ProductDAO productDao = new ProductDAO();
        Product product = productDao.getProductById(productId);
        if (product == null) {
            request.setAttribute("error", "Product not found!");
            request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
            return;
        }

        // Xử lý file upload cho ảnh sản phẩm
        Part filePart = request.getPart("image");
        String newImagePath = product.getImage(); // Giữ lại ảnh cũ nếu không upload mới
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Xác định đường dẫn thư mục lưu file (ví dụ: thư mục "uploads" trong webapps)
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            // Tạo thư mục nếu chưa tồn tại
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Đổi tên file để tránh trùng lặp (ví dụ: sử dụng productId + "_" + fileName)
            String savedFileName = productId + "_" + fileName;
            File fileToSave = new File(uploadDir, savedFileName);

            // Ghi file lên server
            filePart.write(fileToSave.getAbsolutePath());

            // Lưu đường dẫn tương đối (có thể thay đổi theo cấu trúc project)
            newImagePath = "/uploads/" + savedFileName;
        }

        // Chuyển đổi giá trị từ String sang BigDecimal
        BigDecimal price = new BigDecimal(priceStr);
        BigDecimal discount = new BigDecimal(discountStr);
        int quantity = Integer.parseInt(quantityStr);

        // Cập nhật thông tin sản phẩm
        product.setProductName(productName);
        product.setCategoryId(categoryId);
        product.setDetailDesc(detailDesc);
        product.setPrice(price);
        product.setDiscount(discount);
        product.setQuantity(quantity);
        product.setStatus(status);
        product.setImage(newImagePath);  // Cập nhật ảnh sản phẩm mới (hoặc cũ nếu không thay đổi)

        boolean success = productDao.updateProduct(product);

        if (success) {
            response.sendRedirect("ManageProduct");
        } else {
            request.setAttribute("error", "Product update failed. Please try again.");
            request.setAttribute("categoryList", new CategoryDAO().getAllCategories());  // Lấy lại danh sách category
            request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
        }
    }
}