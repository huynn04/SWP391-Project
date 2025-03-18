package model;

import java.util.Date;

public class Category {
    private int categoryId;
    private String categoryName;
    private String description;
    private String image;
    private int status;
    private Date createdAt;
    private Date updatedAt;

    public Category(int categoryId, String categoryName, String description, String image, int status, Date createdAt, Date updatedAt) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Category() {}

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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

    @Override
    public String toString() {
        return "Category{" + "categoryId=" + categoryId + ", categoryName=" + categoryName + ", description=" + description + ", image=" + image + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
    
    
}
