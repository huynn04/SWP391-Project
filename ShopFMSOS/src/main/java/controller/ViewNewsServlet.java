/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NewsCommentDAO;
import dal.NewsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.News;
import model.NewsComment;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class ViewNewsServlet extends HttpServlet {

    private NewsDAO newsDAO;
    private NewsCommentDAO commentDAO;

    @Override
    public void init() {
        newsDAO = new NewsDAO();
        commentDAO = new NewsCommentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int newsId = Integer.parseInt(request.getParameter("id"));
            News news = newsDAO.getNewsById(newsId);

            // Lấy bình luận của bài viết cụ thể
            List<NewsComment> newsComments = commentDAO.getCommentsByNewsId(newsId);

            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1; // Default to page 1 if the page parameter is invalid
                }
            }

            List<News> allNews = newsDAO.getAllNews(page);
            List<News> limitedNews = allNews.size() > 4 ? allNews.subList(0, 4) : allNews;

            if (news != null) {
                // Log debug information
                System.out.println("Fetched News Title: " + news.getTitle());
                System.out.println("Fetched News Content: " + news.getContent());

                if (newsComments.isEmpty()) {
                    System.out.println("No comments found.");
                } else {
                    System.out.println("Found " + newsComments.size() + " comments.");
                }

                // Truyền các thuộc tính cần thiết vào request
                request.setAttribute("news", news);
                request.setAttribute("newsComments", newsComments);
                request.setAttribute("relatedPosts", limitedNews);
                request.setAttribute("currentPage", page);
                request.getRequestDispatcher("/ViewNews.jsp").forward(request, response);
            } else {
                // Nếu không tìm thấy bài viết
                request.setAttribute("error", "❌ Tin tức không tồn tại.");
                request.getRequestDispatcher("/ManageNews").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Lỗi ID tin tức không hợp lệ.");
            request.getRequestDispatcher("/ManageNews").forward(request, response);
        }
    }
}
