/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.NewsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Tran Huy Lam CE180899 
 */
public class DeleteNewsServlet extends HttpServlet {

    private NewsDAO newsDAO;

    @Override
    public void init() {
        newsDAO = new NewsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy ID tin tức từ request
        int newsId = Integer.parseInt(request.getParameter("id"));

        // Xóa tin tức
        boolean success = newsDAO.deleteNews(newsId);

        // Thêm thông báo vào request
        if (success) {
            request.setAttribute("success", "✅ News deleted successfully!");
        } else {
            request.setAttribute("error", "❌ Failed to delete news.");
        }

        // Quay lại trang quản lý tin tức
        request.getRequestDispatcher("ManageNews").forward(request, response);
    }
}