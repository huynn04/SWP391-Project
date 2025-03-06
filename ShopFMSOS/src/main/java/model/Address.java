package model;

public class Address {
    private int id;
    private int userId;
    private String fullName;
    private String phone;
    private String city;
    private String district;
    private String ward;
    private String specificAddress;
    private String addressType;
    private boolean isDefault;

    public Address(int id, int userId, String fullName, String phone, String city, String district, String ward, String specificAddress, String addressType, boolean isDefault) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.city = city;
        this.district = district;
        this.ward = ward;
        this.specificAddress = specificAddress;
        this.addressType = addressType;
        this.isDefault = isDefault;
    }

    // Getters và Setters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getCity() { return city; }
    public String getDistrict() { return district; }
    public String getWard() { return ward; }
    public String getSpecificAddress() { return specificAddress; }
    public String getAddressType() { return addressType; }
    public boolean isDefault() { return isDefault; }

    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setCity(String city) { this.city = city; }
    public void setDistrict(String district) { this.district = district; }
    public void setWard(String ward) { this.ward = ward; }
    public void setSpecificAddress(String specificAddress) { this.specificAddress = specificAddress; }
    public void setAddressType(String addressType) { this.addressType = addressType; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }
}
