/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class ProductServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạo đối tượng DAO và lấy danh sách sản phẩm
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts();
        
        // Đưa danh sách sản phẩm vào request attribute để chuyển sang JSP
        request.setAttribute("products", products);
        
        // Chuyển tiếp request sang trang JSP (ví dụ: product.jsp)
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }

}
