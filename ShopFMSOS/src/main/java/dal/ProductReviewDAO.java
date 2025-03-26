/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.ProductReview;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class ProductReviewDAO extends DBContext {

    // Thêm đánh giá sản phẩm mới vào cơ sở dữ liệu
    public boolean addReview(ProductReview review) {
        String sql = "INSERT INTO product_reviews (order_detail_id, product_id, user_id, review_content, rating, title, likes, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getOrderDetailId());
            ps.setInt(2, review.getProductId());
            ps.setInt(3, review.getUserId());
            ps.setString(4, review.getReviewContent());
            ps.setInt(5, review.getRating());
            ps.setString(6, review.getTitle());
            ps.setInt(7, review.getLikes());
            ps.setInt(8, review.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả các đánh giá từ cơ sở dữ liệu
    public List<ProductReview> getAllReviews() {
        List<ProductReview> reviewList = new ArrayList<>();
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.title, pr.likes, pr.status, pr.created_at, pr.updated_at, u.email "
                + "FROM product_reviews pr "
                + "JOIN users u ON pr.user_id = u.user_id "
                + "ORDER BY pr.created_at DESC"; // Sắp xếp theo thời gian tạo

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReview review = new ProductReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setOrderDetailId(rs.getInt("order_detail_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setReviewContent(rs.getString("review_content"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setLikes(rs.getInt("likes"));
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán email
                    User user = new User();
                    user.setEmail(rs.getString("email"));
                    review.setUser(user);  // Gán đối tượng User vào ProductReview

                    reviewList.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviewList;
    }

    // Lấy đánh giá sản phẩm theo productId
    public List<ProductReview> getReviewsByProductId(int productId) {
        List<ProductReview> reviewList = new ArrayList<>();
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.title, pr.likes, pr.status, pr.created_at, pr.updated_at, u.email "
                + "FROM product_reviews pr "
                + "JOIN users u ON pr.user_id = u.user_id "
                + "WHERE pr.product_id = ? "
                + "ORDER BY pr.created_at DESC"; // Sắp xếp theo thời gian tạo

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId); // Set the productId parameter

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReview review = new ProductReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setOrderDetailId(rs.getInt("order_detail_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setReviewContent(rs.getString("review_content"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setLikes(rs.getInt("likes"));
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán email
                    User user = new User();
                    user.setEmail(rs.getString("email"));
                    review.setUser(user);  // Gán đối tượng User vào ProductReview

                    reviewList.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviewList;
    }

    // Lấy thông tin chi tiết đánh giá theo ID đánh giá
    public ProductReview getReviewById(int reviewId) {
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.title, pr.likes, pr.status, pr.created_at, pr.updated_at, u.username "
                + "FROM product_reviews pr "
                + "JOIN users u ON pr.user_id = u.user_id "
                + "WHERE pr.review_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductReview review = new ProductReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setOrderDetailId(rs.getInt("order_detail_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setReviewContent(rs.getString("review_content"));
                    review.setRating(rs.getInt("rating"));
                    review.setTitle(rs.getString("title"));
                    review.setLikes(rs.getInt("likes"));
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Tạo đối tượng User và gán thông tin vào ProductReview
                    User user = new User();
                    user.setEmail(rs.getString("username"));
                    review.setUser(user);  // Gán đối tượng User vào ProductReview

                    return review;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Xóa đánh giá theo reviewId
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM product_reviews WHERE review_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật đánh giá sản phẩm
    public boolean updateReview(ProductReview review) {
        String sql = "UPDATE product_reviews SET review_content = ?, rating = ?, title = ?, likes = ?, status = ?, updated_at = GETDATE() WHERE review_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, review.getReviewContent());
            ps.setInt(2, review.getRating());
            ps.setString(3, review.getTitle());
            ps.setInt(4, review.getLikes());
            ps.setInt(5, review.getStatus());
            ps.setInt(6, review.getReviewId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
