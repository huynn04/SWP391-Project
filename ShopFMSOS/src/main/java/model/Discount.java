package model;

import java.util.Date;

public class Discount {
    private int discountId;
    private String code;
    private double discountValue;
    private String discountType;
    private double minOrderValue; // Thêm thuộc tính này
    private Date expiryDate;
    private int status;

    public Discount(int discountId, String code, double discountValue, String discountType, double minOrderValue, Date expiryDate, int status) {
        this.discountId = discountId;
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.minOrderValue = minOrderValue; // Gán giá trị
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getMinOrderValue() { // Thêm phương thức này
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Discount{" +
                "discountId=" + discountId +
                ", code='" + code + '\'' +
                ", discountValue=" + discountValue +
                ", discountType='" + discountType + '\'' +
                ", minOrderValue=" + minOrderValue +
                ", expiryDate=" + expiryDate +
                ", status=" + status +
                '}';
    }
}
