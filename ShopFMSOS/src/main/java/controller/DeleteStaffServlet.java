/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class DeleteStaffServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the userId from query string
        String userIdParam = request.getParameter("id");
        if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);

            // Create UserDAO object to perform role change
            UserDAO userDAO = new UserDAO();

            // Change staff role to customer (role_id = 3 for customer)
            boolean isUpdated = userDAO.changeRoleToCustomer(userId);

            // Check result and redirect to Staff Manager page
            if (isUpdated) {
                response.sendRedirect("StaffManager"); // Redirect back to StaffManager if successful
            } else {
                // If update fails, show an error message
                request.setAttribute("errorMessage", "Unable to change the staff role to customer.");
                request.getRequestDispatcher("StaffManager.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("StaffManager"); // If no id is provided, redirect back to StaffManager
        }
    }

}
