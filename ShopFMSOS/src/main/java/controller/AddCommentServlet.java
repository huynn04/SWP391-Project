package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.NewsCommentDAO;
import dal.NewsDAO;
import model.NewsComment;
import model.User;

/**
 * Servlet xử lý việc thêm bình luận vào bài viết
 */
public class AddCommentServlet extends HttpServlet {

    /**
     * Xử lý các yêu cầu HTTP POST
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String errorMessage = null;

        // Lấy tham số từ request
        String newsIdStr = request.getParameter("newsId");
        String content = request.getParameter("content");

        // Kiểm tra người dùng đã đăng nhập chưa
        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");

        // Nếu người dùng chưa đăng nhập, chuyển hướng đến trang đăng nhập
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Kiểm tra các tham số đầu vào
        if (newsIdStr == null || newsIdStr.isEmpty() || content == null || content.isEmpty()) {
            errorMessage = "Không thể thêm bình luận. Các trường không được để trống.";
        }

        int newsId = -1;
        try {
            newsId = Integer.parseInt(newsIdStr);  // Chuyển đổi newsId sang kiểu số
        } catch (NumberFormatException e) {
            errorMessage = "ID bài viết không hợp lệ.";
        }

        if (errorMessage != null) {
            // Nếu có lỗi, hiển thị thông báo và chuyển hướng lại trang chi tiết bài viết
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/ViewNews?id=" + newsId).forward(request, response);
            return;
        }

        // Tạo đối tượng NewsComment và gán các thuộc tính
        NewsComment comment = new NewsComment();
        comment.setNewsId(newsId);
        comment.setUserId(loggedInUser.getUserId());
        comment.setContent(content);

        // Thực hiện thêm bình luận vào cơ sở dữ liệu
        NewsDAO newsDAO = new NewsDAO();
        NewsCommentDAO commentDAO = new NewsCommentDAO();

        if (commentDAO.addComment(comment)) {
            // Sau khi thêm bình luận thành công, forward lại trang xem chi tiết bài viết
            request.setAttribute("news", newsDAO.getNewsById(newsId));
            request.setAttribute("newsComments", commentDAO.getCommentsByNewsId(newsId));
            response.sendRedirect("ViewNews?id=" + newsId); // Chuyển hướng về trang chi tiết bài viết
        } else {
            // Nếu thêm bình luận không thành công, thông báo lỗi và chuyển lại trang chi tiết bài viết
            request.setAttribute("error", "Không thể thêm bình luận vào cơ sở dữ liệu.");
            request.getRequestDispatcher("/ViewNews?id=" + newsId).forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet thêm bình luận vào bài viết";
    }
}
