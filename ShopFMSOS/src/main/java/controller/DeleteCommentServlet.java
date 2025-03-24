package controller;

import dal.NewsCommentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.NewsComment;
import model.User;

public class DeleteCommentServlet extends HttpServlet {

    private NewsCommentDAO commentDAO;

    @Override
    public void init() {
        commentDAO = new NewsCommentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            boolean isDeleted = commentDAO.deleteComment(commentId);

            if (isDeleted) {
                response.sendRedirect("ViewNews?id=" + request.getParameter("newsId"));
            } else {
                request.setAttribute("error", "❌ Không thể xóa bình luận.");
                request.getRequestDispatcher("/ViewNews?id=" + request.getParameter("newsId")).forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Lỗi khi xóa bình luận.");
            request.getRequestDispatcher("/ViewNews?id=" + request.getParameter("newsId")).forward(request, response);
        }
    }
}