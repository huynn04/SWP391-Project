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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("AddProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Map<String, String> errors = new HashMap<>();
        try {
            // Retrieve data from the form
            String productName = request.getParameter("productName");
            String categoryIdStr = request.getParameter("categoryId");
            String detailDesc = request.getParameter("detailDesc");
            String priceStr = request.getParameter("price");
            String discountStr = request.getParameter("discount");
            String quantityStr = request.getParameter("quantity");
            String target = request.getParameter("target");
            String factory = request.getParameter("factory");
            String statusStr = request.getParameter("status");

            // Server-side validation
            if (productName == null || productName.trim().isEmpty()) {
                errors.put("productNameError", "Product name is required.");
            } else if (productDAO.checkProductNameExists(productName)) {
                errors.put("productNameError", "Product name already exists.");
            }

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                errors.put("categoryIdError", "Invalid category.");
                categoryId = -1;
            }

            if (detailDesc == null || detailDesc.trim().isEmpty()) {
                errors.put("detailDescError", "Description is required.");
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    errors.put("priceError", "Price must be a positive number.");
                }
            } catch (NumberFormatException e) {
                errors.put("priceError", "Invalid price format.");
                price = BigDecimal.ZERO;
            }

            BigDecimal discount;
            try {
                discount = new BigDecimal(discountStr);
                if (discount.compareTo(BigDecimal.ZERO) < 0 || discount.compareTo(new BigDecimal("100")) > 0) {
                    errors.put("discountError", "Discount must be between 0 and 100.");
                }
            } catch (NumberFormatException e) {
                errors.put("discountError", "Invalid discount format.");
                discount = BigDecimal.ZERO;
            }

            int quantity;
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity < 0) {
                    errors.put("quantityError", "Quantity must be a non-negative number.");
                }
            } catch (NumberFormatException e) {
                errors.put("quantityError", "Invalid quantity format.");
                quantity = 0;
            }

            int status;
            try {
                status = Integer.parseInt(statusStr);
                if (status != 0 && status != 1) {
                    errors.put("statusError", "Status must be 0 or 1.");
                }
            } catch (NumberFormatException e) {
                errors.put("statusError", "Invalid status format.");
                status = 1;
            }

            // Handle Image Upload
            Part filePart = request.getPart("image");
            String imageName = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String fileType = filePart.getContentType();
                if (!fileType.equals("image/png") && !fileType.equals("image/jpeg")) {
                    errors.put("imageError", "Only PNG and JPEG images are allowed.");
                } else {
                    fileName = System.currentTimeMillis() + "_" + fileName;
                    
                    // Define path to save image directly into src/main/webapp/image
                    String picFolder = "src/main/webapp/image"; // The folder for image
                    String projectPath = getServletContext().getRealPath("/").split("target")[0];
                    String realPath = projectPath + picFolder;

                    File uploadDir = new File(realPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    filePart.write(realPath + File.separator + fileName);
                    imageName = "image/" + fileName;
                }
            }

            // If there are errors, return to the input page with error messages
            if (!errors.isEmpty()) {
                List<Category> categoryList = categoryDAO.getAllCategories();
                request.setAttribute("categoryList", categoryList);
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("AddProduct.jsp").forward(request, response);
                return;
            }

            // Create a Product object
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

            // Add product to the database
            boolean success = productDAO.addProduct(product);

            // Reload the category list
            List<Category> categoryList = categoryDAO.getAllCategories();
            request.setAttribute("categoryList", categoryList);

            if (success) {
                request.setAttribute("success", "✅ Product added successfully!");
            } else {
                errors.put("generalError", "❌ Failed to add product. Please check the data.");
                request.setAttribute("errors", errors);
            }
            request.getRequestDispatcher("AddProduct.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            errors.put("generalError", "❌ Error occurred: " + e.getMessage());
            List<Category> categoryList = categoryDAO.getAllCategories();
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("AddProduct.jsp").forward(request, response);
        }
    }
}
