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
import java.util.List;
import model.News;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class AllNewsServlet extends HttpServlet {

    private static final int NEWS_PER_PAGE = 10;  // Số bài viết mỗi trang

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AllNewsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AllNewsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String searchQuery = request.getParameter("search");
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);

        // Lấy đối tượng NewsDAO để truy vấn tin tức
        NewsDAO newsDAO = new NewsDAO();

        // Tính toán tổng số tin tức và số trang
        int totalNews = searchQuery != null ? newsDAO.countSearchNews(searchQuery) : newsDAO.countAllNews();
        int totalPages = (int) Math.ceil((double) totalNews / NEWS_PER_PAGE);

        // Lấy danh sách tin tức cho trang hiện tại
        List<News> newsList = searchQuery != null
                ? newsDAO.searchNews(searchQuery, currentPage, NEWS_PER_PAGE)
                : newsDAO.getAllNews(currentPage);

        // Truyền dữ liệu vào request để hiển thị trên JSP
        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchQuery);

        // Chuyển đến trang AllNews.jsp
        request.getRequestDispatcher("AllNews.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
