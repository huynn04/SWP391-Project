package dal;

import dal.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Address;

public class AddressDAO extends DBContext {

    // Lấy danh sách địa chỉ của người dùng
    public List<Address> getAddressesByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";

        try {
            connection = getConnection(); // Kết nối database
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                addresses.add(new Address(
                    resultSet.getInt("address_id"),
                    resultSet.getInt("user_id"),
                    resultSet.getString("full_name"),
                    resultSet.getString("phone"),
                    resultSet.getString("city"),
                    resultSet.getString("district"),
                    resultSet.getString("ward"),
                    resultSet.getString("specific_address"),
                    resultSet.getString("address_type"),
                    resultSet.getBoolean("is_default")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(); // Đóng kết nối
        }
        return addresses;
    }

    // Lưu địa chỉ mới vào database
    public void saveAddress(Address address) {
        String sql = "INSERT INTO addresses (user_id, full_name, phone, city, district, ward, specific_address, address_type, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection(); // Kết nối database
            statement = connection.prepareStatement(sql);

            statement.setInt(1, address.getUserId());
            statement.setString(2, address.getFullName());
            statement.setString(3, address.getPhone());
            statement.setString(4, address.getCity());
            statement.setString(5, address.getDistrict());
            statement.setString(6, address.getWard());
            statement.setString(7, address.getSpecificAddress());
            statement.setString(8, address.getAddressType());
            statement.setBoolean(9, address.isDefault());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection(); // Đóng kết nối
        }
    }

    // Cập nhật địa chỉ (Dùng để cập nhật thông tin hoặc đặt làm mặc định)
   public void updateAddress(Address address) {
    String sql = "UPDATE addresses SET full_name = ?, phone = ?, city = ?, district = ?, ward = ?, specific_address = ?, address_type = ?, is_default = ?, updated_at = GETDATE() WHERE address_id = ? AND user_id = ?";

    try {
        connection = getConnection();
        statement = connection.prepareStatement(sql);

        statement.setString(1, address.getFullName());
        statement.setString(2, address.getPhone());
        statement.setString(3, address.getCity());
        statement.setString(4, address.getDistrict());
        statement.setString(5, address.getWard());
        statement.setString(6, address.getSpecificAddress());
        statement.setString(7, address.getAddressType());
        statement.setBoolean(8, address.isDefault());
        statement.setInt(9, address.getId());
        statement.setInt(10, address.getUserId());

        statement.executeUpdate();

        // Nếu cập nhật địa chỉ thành mặc định thì gọi phương thức setDefaultAddress
        if (address.isDefault()) {
            setDefaultAddress(address.getUserId(), address.getId());
        }

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeConnection();
    }
}

    // Đặt địa chỉ mặc định cho người dùng
    public void setDefaultAddress(int userId, int addressId) {
        String resetDefaultSql = "UPDATE addresses SET is_default = 0 WHERE user_id = ?";
        String setDefaultSql = "UPDATE addresses SET is_default = 1 WHERE address_id = ? AND user_id = ?";

        try {
            connection = getConnection();

            // Đặt tất cả địa chỉ về không mặc định
            statement = connection.prepareStatement(resetDefaultSql);
            statement.setInt(1, userId);
            statement.executeUpdate();

            // Đặt địa chỉ mới làm mặc định
            statement = connection.prepareStatement(setDefaultSql);
            statement.setInt(1, addressId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
    }

    // Xóa địa chỉ
    public void deleteAddress(int addressId, int userId) {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, addressId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeConnection();
        }
    }
    
}
