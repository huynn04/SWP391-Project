/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.News;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class NewsDAO extends DBContext {

    // Lấy tất cả tin tức
    public List<News> getAllNews(int page) {
        List<News> newsList = new ArrayList<>();
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        String sql = "WITH NewsWithRow AS ("
                + "   SELECT news_id, user_id, title, content, image, status, created_at, updated_at, "
                + "          ROW_NUMBER() OVER (ORDER BY created_at DESC) AS RowNum "
                + "   FROM news "
                + "   WHERE status = 1 " // Lọc chỉ những bài tin có status = 1
                + ") "
                + "SELECT news_id, user_id, title, content, image, status, created_at, updated_at "
                + "FROM NewsWithRow "
                + "WHERE RowNum BETWEEN ? AND ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset + 1);  // Bắt đầu từ bài viết thứ (offset + 1)
            ps.setInt(2, offset + pageSize);  // Kết thúc tại bài viết thứ (offset + pageSize)

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News(
                            rs.getInt("news_id"),
                            rs.getInt("user_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getInt("status"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    );
                    newsList.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newsList;
    }

    // Lấy chi tiết tin tức theo newsId
    public News getNewsById(int newsId) {
        String sql = "SELECT news_id, user_id, title, content, image, status, created_at, updated_at FROM news WHERE news_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newsId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new News(
                            rs.getInt("news_id"),
                            rs.getInt("user_id"),
                            rs.getString("title"),
                            rs.getString("content"), // Dữ liệu HTML giữ nguyên
                            rs.getString("image"),
                            rs.getInt("status"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đếm số lượng tin tức
    public int countAllNews() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM news";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Kiểm tra tin tức có trùng tiêu đề hay không
    public boolean checkNewsTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM news WHERE title = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // Tiêu đề tin tức đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm tin tức mới
    public boolean addNews(News news) {
        String sql = "INSERT INTO news (user_id, title, content, image, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, news.getUserId());
            ps.setString(2, news.getTitle());
            ps.setString(3, news.getContent()); // Lưu nội dung HTML
            ps.setString(4, news.getImage());
            ps.setInt(5, news.getStatus());

            // In debug SQL để kiểm tra
            System.out.println("Executing Query: " + ps.toString());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật tin tức
    public boolean updateNews(News news) {
        String sql = "UPDATE news SET user_id = ?, title = ?, content = ?, image = ?, status = ?, updated_at = GETDATE() WHERE news_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, news.getUserId());
            ps.setString(2, news.getTitle());
            ps.setString(3, news.getContent()); // Lưu dữ liệu HTML từ TinyMCE
            ps.setString(4, news.getImage());
            ps.setInt(5, news.getStatus());
            ps.setInt(6, news.getNewsId());

            System.out.println("Executing Update Query: " + ps.toString());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa tin tức
    public boolean deleteNews(int newsId) {
        String sql = "DELETE FROM news WHERE news_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<News> searchNews(String searchQuery, int currentPage, int newsPerPage) {
        List<News> newsList = new ArrayList<>();
        int offset = (currentPage - 1) * newsPerPage; // Tính toán offset để phân trang
        String sql = "WITH NewsWithRow AS ("
                + "   SELECT news_id, user_id, title, content, image, status, created_at, updated_at, "
                + "          ROW_NUMBER() OVER (ORDER BY created_at DESC) AS RowNum "
                + "   FROM news "
                + "   WHERE LOWER(title) LIKE LOWER(?) "
                + ") "
                + "SELECT news_id, user_id, title, content, image, status, created_at, updated_at "
                + "FROM NewsWithRow "
                + "WHERE RowNum BETWEEN ? AND ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + searchQuery + "%");
            ps.setInt(2, offset + 1);  // Bắt đầu từ bài viết thứ (offset + 1)
            ps.setInt(3, offset + newsPerPage);  // Kết thúc tại bài viết thứ (offset + newsPerPage)

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    News news = new News(
                            rs.getInt("news_id"),
                            rs.getInt("user_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getInt("status"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    );
                    newsList.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newsList;
    }

    public List<News> getRecentNews() {
        List<News> newsList = new ArrayList<>();

        // Cập nhật câu truy vấn để lấy thêm cột status
        String sql = "SELECT TOP 6 news_id, title, content, image, status, created_at FROM news WHERE status = 1 ORDER BY created_at DESC";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                News news = new News();
                // Gán giá trị vào các thuộc tính của đối tượng News
                news.setNewsId(rs.getInt("news_id"));
                news.setTitle(rs.getString("title"));
                news.setContent(rs.getString("content"));
                news.setImage(rs.getString("image"));
                news.setStatus(rs.getInt("status"));  // Gán giá trị status từ cơ sở dữ liệu
                news.setCreatedAt(rs.getTimestamp("created_at"));
                newsList.add(news);  // Thêm đối tượng News vào danh sách
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newsList;
    }

    // Đếm tổng số bài viết phù hợp với tìm kiếm
    public int countSearchNews(String searchQuery) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM news WHERE LOWER(title) LIKE LOWER(?)";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + searchQuery + "%");
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

}
