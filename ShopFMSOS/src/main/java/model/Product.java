/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */

public class Product {
    private int product_id;
    private int category_id;
    private String product_name;
    private String detail_desc;
    private String image;
    private BigDecimal price;
    private BigDecimal discount;
    private int quantity;
    private int sold;
    private String target;
    private String factory;
    private int status;
    private Date created_at;
    private Date updated_at;

    public Product(int product_id, int category_id, String product_name, String detail_desc, String image, BigDecimal price, BigDecimal discount, int quantity, int sold, String target, String factory, int status, Date created_at, Date updated_at) {
        this.product_id = product_id;
        this.category_id = category_id;
        this.product_name = product_name;
        this.detail_desc = detail_desc;
        this.image = image;
        this.price = price;
        this.discount = discount;
        this.quantity = quantity;
        this.sold = sold;
        this.target = target;
        this.factory = factory;
        this.status = status;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    
    
    public Product() {}
    
    public int getProductId() {
        return product_id;
    }
    
    public void setProductId(int productId) {
        this.product_id = productId;
    }
    
    public int getCategoryId() {
        return category_id;
    }
    
    public void setCategoryId(int categoryId) {
        this.category_id = categoryId;
    }
    
    public String getProductName() {
        return product_name;
    }
    
    public void setProductName(String productName) {
        this.product_name = productName;
    }
    
    public String getDetailDesc() {
        return detail_desc;
    }
    
    public void setDetailDesc(String detailDesc) {
        this.detail_desc = detailDesc;
    }
    
    public String getImage() {
        return image;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public BigDecimal getDiscount() {
        return discount;
    }
    
    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getSold() {
        return sold;
    }
    
    public void setSold(int sold) {
        this.sold = sold;
    }
    
    public String getTarget() {
        return target;
    }
    
    public void setTarget(String target) {
        this.target = target;
    }
    
    public String getFactory() {
        return factory;
    }
    
    public void setFactory(String factory) {
        this.factory = factory;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public Date getCreatedAt() {
        return created_at;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.created_at = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updated_at;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updated_at = updatedAt;
    }
}