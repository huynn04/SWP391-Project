package controller;

import dal.CategoryDAO;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 5,     // 5 MB
    maxRequestSize = 1024 * 1024 * 25  // 25 MB
)
public class AddCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward đến trang addcategory.jsp khi yêu cầu GET được gửi
        request.getRequestDispatcher("addcategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String image = null;

        // Lấy phần ảnh tải lên từ form (nếu có)
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            // Lấy tên file gốc và tạo tên duy nhất
            String fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Định nghĩa đường dẫn lưu ảnh vào thư mục src/main/webapp/image
            String picFolder = "src/main/webapp/image"; // thư mục lưu ảnh
            String projectPath = getServletContext().getRealPath("/").split("target")[0]; // Đường dẫn gốc
            String realPath = projectPath + picFolder;

            // Tạo thư mục nếu chưa có
            File uploadDir = new File(realPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();  // Tạo thư mục nếu chưa có
            }

            // Lưu ảnh lên server
            File fileToSave = new File(uploadDir, fileName);
            filePart.write(fileToSave.getAbsolutePath());

            // Lưu đường dẫn ảnh
            image = "image/" + fileName;  // Đường dẫn ảnh trong thư mục image
        }

        // Lấy trạng thái
        int status = Integer.parseInt(request.getParameter("status"));

        // Tạo đối tượng Category mới
        Category newCategory = new Category();
        newCategory.setCategoryName(categoryName);
        newCategory.setDescription(description);
        newCategory.setImage(image);  // Set ảnh nếu có
        newCategory.setStatus(status);

        // Lưu vào cơ sở dữ liệu thông qua CategoryDAO
        CategoryDAO categoryDAO = new CategoryDAO();
        boolean isAdded = categoryDAO.addCategory(newCategory);

        // Kiểm tra nếu thêm thành công, chuyển đến trang danh sách
        if (isAdded) {
            response.sendRedirect("CategoryServlet");
        } else {
            response.sendRedirect("AddCategory");
        }
    }
}
