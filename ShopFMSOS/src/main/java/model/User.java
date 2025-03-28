package model;

import java.util.Date;

public class User {

    private int userId;
    private int roleId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String address; // Chứa địa chỉ đầy đủ
    private String password;
    private String avatar;
    private int status;
    private Date createdAt;
    private Date updatedAt;

    public User(int userId, int roleId, String fullName, String email, String phoneNumber, String address, String password, String avatar, int status, Date createdAt, Date updatedAt) {
        this.userId = userId;
        this.roleId = roleId;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.password = password;
        this.avatar = avatar;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public User() {
    }

    public int getId() {
        return this.userId;
    }

    public void setId(int userId) {
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    // Phương thức lấy thông tin city từ địa chỉ
    public String getCity() {
        // Giả sử city là phần đầu tiên trong địa chỉ, ngăn cách bằng dấu phẩy
        if (address != null && !address.isEmpty()) {
            String[] addressParts = address.split(","); // Giả sử địa chỉ theo dạng "city, district, ward"
            if (addressParts.length > 0) {
                return addressParts[0].trim(); // Trả về phần city
            }
        }
        return "";
    }

    // Phương thức cập nhật city trong địa chỉ
    public void setCity(String city) {
        if (address != null && !address.isEmpty()) {
            String[] addressParts = address.split(",");
            addressParts[0] = city; // Cập nhật city
            this.address = String.join(",", addressParts); // Ghép lại địa chỉ
        } else {
            this.address = city; // Nếu địa chỉ rỗng, chỉ cần gán city
        }
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
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

}
