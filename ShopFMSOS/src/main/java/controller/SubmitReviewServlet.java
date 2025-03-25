/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.Date;
import model.ProductReview;

/**
 *
 * @author Tran Huy Lam CE180899 
 */
public class SubmitReviewServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SubmitReviewServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubmitReviewServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data from the request
        int orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        int userId = Integer.parseInt(request.getParameter("userId")); // Assuming user ID is stored in session
        String reviewContent = request.getParameter("reviewContent");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int status = 1; // Assuming the review is active by default
        
        // Create a ProductReview object
        ProductReview review = new ProductReview();
        review.setOrderDetailId(orderDetailId);
        review.setProductId(productId);
        review.setUserId(userId);
        review.setReviewContent(reviewContent);
        review.setRating(rating);
        review.setStatus(status);
        review.setCreatedAt(new Timestamp(new Date().getTime()));
        review.setUpdatedAt(new Timestamp(new Date().getTime()));
        
        // Initialize DAO and save the review to the database
        ProductReviewDAO reviewDAO = new ProductReviewDAO();
        boolean result = reviewDAO.addReview(review);
        
        // Redirect or show a message based on the result
        if (result) {
            // Redirect to a success page or back to the product page
            response.sendRedirect("productDetails?productId=" + productId + "&message=Review added successfully.");
        } else {
            // Display an error message
            response.sendRedirect("productDetails?productId=" + productId + "&error=Error while adding the review.");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
