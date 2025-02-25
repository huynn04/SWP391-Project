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
import model.Product;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class ProductDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        if (productIdParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam);
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(productId);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                }
            } catch (NumberFormatException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product id");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product id is missing");
        }
    }

}
