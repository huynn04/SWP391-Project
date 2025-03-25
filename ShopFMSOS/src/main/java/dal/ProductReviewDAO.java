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
        String sql = "INSERT INTO product_reviews (order_detail_id, product_id, user_id, review_content, rating, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getOrderDetailId());
            ps.setInt(2, review.getProductId());
            ps.setInt(3, review.getUserId());
            ps.setString(4, review.getReviewContent());
            ps.setInt(5, review.getRating());
            ps.setInt(6, review.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy tất cả các đánh giá từ cơ sở dữ liệu
    public List<ProductReview> getAllReviews() {
        List<ProductReview> reviewList = new ArrayList<>();
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.status, pr.created_at, pr.updated_at, u.full_name "
                + "FROM product_reviews pr "
                + "JOIN users u ON pr.user_id = u.user_id "
                + "ORDER BY pr.created_at DESC";

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
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    User user = new User();
                    user.setFullName(rs.getString("full_name"));  // Sửa thành full_name
                    review.setUser(user);

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
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.status, pr.created_at, pr.updated_at, u.full_name "
                + "FROM product_reviews pr "
                + "JOIN users u ON pr.user_id = u.user_id "
                + "WHERE pr.product_id = ? "
                + "ORDER BY pr.created_at DESC";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReview review = new ProductReview();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setOrderDetailId(rs.getInt("order_detail_id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setReviewContent(rs.getString("review_content"));
                    review.setRating(rs.getInt("rating"));
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    User user = new User();
                    user.setFullName(rs.getString("full_name"));  // Sửa thành full_name
                    review.setUser(user);

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
        String sql = "SELECT pr.review_id, pr.order_detail_id, pr.product_id, pr.user_id, pr.review_content, pr.rating, pr.status, pr.created_at, pr.updated_at, u.full_name "
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
                    review.setStatus(rs.getInt("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));

                    User user = new User();
                    user.setFullName(rs.getString("full_name"));  // Sửa thành full_name
                    review.setUser(user);

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
            ps.setInt(1, reviewId); // Set reviewId vào câu lệnh SQL
            return ps.executeUpdate() > 0; // Nếu có bản ghi bị xóa, trả về true
        } catch (SQLException e) {
            e.printStackTrace(); // Xử lý lỗi nếu có
            return false;
        }
    }

}
