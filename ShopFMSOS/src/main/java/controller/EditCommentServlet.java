package controller;

import dal.NewsCommentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.NewsComment;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class EditCommentServlet extends HttpServlet {

    private NewsCommentDAO commentDAO;

    @Override
    public void init() {
        commentDAO = new NewsCommentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            String content = request.getParameter("content");
            int newsId = Integer.parseInt(request.getParameter("newsId")); // Lấy newsId từ request

            NewsComment comment = new NewsComment();
            comment.setCommentId(commentId);
            comment.setContent(content);

            boolean isUpdated = commentDAO.updateComment(comment);

            if (isUpdated) {
                // Sau khi cập nhật thành công, chuyển hướng về ViewNews với newsId
                response.sendRedirect("ViewNews?id=" + newsId); 
            } else {
                request.setAttribute("error", "❌ Không thể cập nhật bình luận.");
                request.getRequestDispatcher("/ViewNews?id=" + newsId).forward(request, response); // Chuyển hướng về ViewNews với newsId
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Lỗi khi cập nhật bình luận.");
            request.getRequestDispatcher("/ViewNews?id=" + request.getParameter("newsId")).forward(request, response);
        }
    }
}
