package model;

import java.math.BigDecimal;
import java.util.Date;

public class Discount {
    private int discountId;
    private String code;
    private double discountValue;
    private String discountType;
    private Date expiryDate;
    private int status;

    public Discount(int discountId, String code, double discountValue, String discountType, Date expiryDate, int status) {
        this.discountId = discountId;
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
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
        return "Discount{" + "discountId=" + discountId + ", code=" + code + ", discountValue=" + discountValue + ", discountType=" + discountType + ", expiryDate=" + expiryDate + ", status=" + status + '}';
    }

    
}
