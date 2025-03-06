/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class CartDetail {
    private int cartDetailId;
    private int cartId;
    private int productId;
    private int quantity;
    private BigDecimal price;
    
    public CartDetail() {}

    public CartDetail(int cartDetailId, int cartId, int productId, int quantity, BigDecimal price) {
        this.cartDetailId = cartDetailId;
        this.cartId = cartId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }
    
    public int getCartDetailId() {
        return cartDetailId;
    }
    
    public void setCartDetailId(int cartDetailId) {
        this.cartDetailId = cartDetailId;
    }
    
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
