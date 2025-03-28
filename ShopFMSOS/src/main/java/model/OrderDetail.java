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
public class OrderDetail {

    private int orderDetailId;
    private int orderId;
    private int productId;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal;
    private BigDecimal tax;
    private Product product;

    public OrderDetail(int orderDetailId, int orderId, int productId, int quantity, BigDecimal price, BigDecimal subtotal, BigDecimal tax) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.tax = tax;
    }

    public OrderDetail(int orderDetailId, int orderId, int productId, int quantity,
            BigDecimal price, BigDecimal subtotal, BigDecimal tax, Product product) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
        this.tax = tax;
        this.product = product;
    }

    public OrderDetail() {
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public BigDecimal getTax() {
        // Thuế luôn luôn bằng 1.25$
        return BigDecimal.valueOf(1.25).setScale(2, BigDecimal.ROUND_HALF_UP);
    }


    public void setTax(BigDecimal tax) {
        this.tax = tax;
    }

    // Getter & Setter cho Product
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

 public BigDecimal getSubtotal() {
        // Kiểm tra và gán giá trị mặc định nếu price hoặc quantity là null
        BigDecimal price = this.price != null ? this.price : BigDecimal.ZERO;

        // Nếu quantity là kiểu int hoặc Integer, chuyển trực tiếp sang BigDecimal
        BigDecimal quantity = BigDecimal.valueOf(this.quantity); // Không cần kiểm tra null nếu quantity là kiểu int

        // Tính subtotal = quantity * price + 1.25 (thuế cố định)
        BigDecimal subtotal = quantity.multiply(price).add(BigDecimal.valueOf(1.25));

        // Đảm bảo kết quả chỉ có 2 chữ số thập phân
        return subtotal.setScale(2, BigDecimal.ROUND_HALF_UP); // Làm tròn kết quả sau dấu thập phân
    }
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}
