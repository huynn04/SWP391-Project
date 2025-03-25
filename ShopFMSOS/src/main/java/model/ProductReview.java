/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class ProductReview {
    private int reviewId;
    private int orderDetailId;
    private int productId;
    private int userId;
    private String reviewContent;
    private int rating;
    private int status;
    private Date createdAt;
    private Date updatedAt;
    private User user;  // Thêm đối tượng User

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ProductReview(int reviewId, int orderDetailId, int productId, int userId, String reviewContent, int rating, String title, int likes, int status, Date createdAt, Date updatedAt) {
        this.reviewId = reviewId;
        this.orderDetailId = orderDetailId;
        this.productId = productId;
        this.userId = userId;
        this.reviewContent = reviewContent;
        this.rating = rating;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public ProductReview() {}
    
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public int getOrderDetailId() {
        return orderDetailId;
    }
    
    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getReviewContent() {
        return reviewContent;
    }
    
    public void setReviewContent(String reviewContent) {
        this.reviewContent = reviewContent;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}

