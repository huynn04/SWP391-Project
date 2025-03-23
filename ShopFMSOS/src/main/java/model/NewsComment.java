package model;

import java.util.Date;

public class NewsComment {
    private int commentId;
    private int newsId;
    private int userId;
    private String content;
    private Date createdAt;
    private Date updatedAt;
    private User user;  // Thêm đối tượng User

    // Constructor không tham số
    public NewsComment() {}

    // Getter và Setter cho commentId
    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    // Getter và Setter cho newsId
    public int getNewsId() {
        return newsId;
    }

    public void setNewsId(int newsId) {
        this.newsId = newsId;
    }

    // Getter và Setter cho userId
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    // Getter và Setter cho content
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    // Getter và Setter cho createdAt
    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Getter và Setter cho updatedAt
    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Getter và Setter cho đối tượng User
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
