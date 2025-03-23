package dal;

import model.NewsComment;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsCommentDAO extends DBContext {

    // Thêm bình luận mới vào cơ sở dữ liệu
    public boolean addComment(NewsComment comment) {
        String sql = "INSERT INTO news_comments (news_id, user_id, content, created_at, updated_at) "
                + "VALUES (?, ?, ?, GETDATE(), GETDATE())";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comment.getNewsId());
            ps.setInt(2, comment.getUserId());
            ps.setString(3, comment.getContent());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả bình luận từ cơ sở dữ liệu
    public List<NewsComment> getAllComments() {
        List<NewsComment> commentList = new ArrayList<>();
        String sql = "SELECT nc.comment_id, nc.news_id, nc.user_id, nc.content, nc.created_at, nc.updated_at, u.email "
                + "FROM news_comments nc "
                + "JOIN users u ON nc.user_id = u.user_id "
                + "ORDER BY nc.created_at DESC"; // Sắp xếp theo thời gian tạo

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NewsComment comment = new NewsComment();
                    comment.setCommentId(rs.getInt("comment_id"));
                    comment.setNewsId(rs.getInt("news_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    comment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán email
                    User user = new User();
                    user.setEmail(rs.getString("email"));
                    comment.setUser(user);  // Gán đối tượng User vào NewsComment

                    commentList.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return commentList;
    }

    // Lấy bình luận theo newsId
    public List<NewsComment> getCommentsByNewsId(int newsId) {
        List<NewsComment> commentList = new ArrayList<>();
        String sql = "SELECT nc.comment_id, nc.news_id, nc.user_id, nc.content, nc.created_at, nc.updated_at, u.email "
                + "FROM news_comments nc "
                + "JOIN users u ON nc.user_id = u.user_id "
                + "WHERE nc.news_id = ? "
                + "ORDER BY nc.created_at DESC"; // Sắp xếp theo thời gian tạo

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newsId); // Set the newsId parameter

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NewsComment comment = new NewsComment();
                    comment.setCommentId(rs.getInt("comment_id"));
                    comment.setNewsId(rs.getInt("news_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    comment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán email
                    User user = new User();
                    user.setEmail(rs.getString("email"));
                    comment.setUser(user);  // Gán đối tượng User vào NewsComment

                    commentList.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return commentList;
    }

    // Lấy thông tin chi tiết bình luận theo ID bình luận
    public NewsComment getCommentById(int commentId) {
        String sql = "SELECT nc.comment_id, nc.news_id, nc.user_id, nc.content, nc.created_at, nc.updated_at, u.username "
                + "FROM news_comments nc "
                + "JOIN users u ON nc.user_id = u.user_id "
                + "WHERE nc.comment_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NewsComment comment = new NewsComment();
                    comment.setCommentId(rs.getInt("comment_id"));
                    comment.setNewsId(rs.getInt("news_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    comment.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán thông tin vào NewsComment
                    User user = new User();
                    user.setEmail(rs.getString("username")); // Hoặc sử dụng thông tin phù hợp từ cơ sở dữ liệu
                    comment.setUser(user);  // Gán đối tượng User vào NewsComment

                    return comment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Xóa bình luận theo commentId
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM news_comments WHERE comment_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật bình luận
    public boolean updateComment(NewsComment comment) {
        String sql = "UPDATE news_comments SET content = ?, updated_at = GETDATE() WHERE comment_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, comment.getContent());
            ps.setInt(2, comment.getCommentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
