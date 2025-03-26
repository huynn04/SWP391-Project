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
        // Créer un objet DAO et obtenir la liste des produits
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts();

        // Calculer le total des produits et le nombre de pages
        int totalProducts = products.size();  // Taille totale des produits
        int pageSize = 6;  // Nombre de produits par page
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);  // Nombre total de pages
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;  // Page actuelle

        // Calculer les indices de début et de fin des produits pour la page actuelle
        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalProducts);

        // Ajouter la liste des produits dans la requête
        request.setAttribute("products", products.subList(start, end));  // Passer la sous-liste des produits
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);

        // Rediriger vers la page JSP
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }

}
