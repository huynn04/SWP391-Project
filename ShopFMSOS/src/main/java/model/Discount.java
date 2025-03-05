package model;

import java.util.Date;

public class Discount {
    private int discountId;
    private String code;
    private double discountValue;
    private String discountType;
    private double minOrderValue;
    private Date expiryDate;
    private int status;

    public Discount(int discountId, String code, double discountValue, String discountType, double minOrderValue, Date expiryDate, int status) {
        this.discountId = discountId;
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.minOrderValue = minOrderValue;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getDiscountId() {
        return discountId;
    }

    public String getCode() {
        return code;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public String getDiscountType() {
        return discountType;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public int getStatus() {
        return status;
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
