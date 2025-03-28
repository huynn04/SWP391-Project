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

    // Constructor với discountId (dành cho đối tượng đã có trong DB)
    public Discount(int discountId, String code, double discountValue, String discountType, double minOrderValue, Date expiryDate, int status) {
        this.discountId = discountId;
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.minOrderValue = minOrderValue;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    // Constructor dành cho đối tượng mới (không có discountId)
    public Discount(String code, double discountValue, String discountType, double minOrderValue, Date expiryDate, int status) {
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.minOrderValue = minOrderValue;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    // Constructor mặc định (nếu cần)
    public Discount() {
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

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = new java.sql.Date(expiryDate.getTime()); // Chuyển từ java.util.Date sang java.sql.Date
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
