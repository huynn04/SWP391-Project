package model;

import java.util.Date;

public class Cart {
    private int cartId;
    private int userId;
    private Date createdAt;
    private Date updatedAt;
    private Discount discount; // Thêm thuộc tính discount

    // Constructor có discount
    public Cart(int cartId, int userId, Date createdAt, Date updatedAt, Discount discount) {
        this.cartId = cartId;
        this.userId = userId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.discount = discount;
    }

    // Constructor không có discount (dùng khi không áp dụng mã giảm giá)
    public Cart(int cartId, int userId, Date createdAt, Date updatedAt) {
        this(cartId, userId, createdAt, updatedAt, null); // Gọi constructor chính, discount mặc định là null
    }

    public Cart() {}

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public Discount getDiscount() { // Getter cho discount
        return discount;
    }

    public void setDiscount(Discount discount) { // Setter cho discount
        this.discount = discount;
    }

    public Object getItems() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Iterable<Product> getProducts() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


}
