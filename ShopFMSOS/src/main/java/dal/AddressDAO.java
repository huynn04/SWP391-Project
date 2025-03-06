package dal;

import model.Address;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO extends DBContext {

    // Lấy danh sách địa chỉ của người dùng
    public List<Address> getAddressesByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
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
                        false // Đây có thể là giá trị mặc định cho trường 'isDefault'
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addresses;
    }

    // Lưu địa chỉ mới vào database
    public boolean saveAddress(Address address) {
        String sql = "INSERT INTO addresses (user_id, full_name, phone, city, district, ward, specific_address, address_type, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, address.getUserId());
            statement.setString(2, address.getFullName());
            statement.setString(3, address.getPhone());
            statement.setString(4, address.getCity());
            statement.setString(5, address.getDistrict());
            statement.setString(6, address.getWard());
            statement.setString(7, address.getSpecificAddress());
            statement.setString(8, address.getAddressType());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        address.setId(generatedKeys.getInt(1));
                    }
                }
            }
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật địa chỉ
    public boolean updateAddress(Address address) {
        String sql = "UPDATE addresses SET full_name = ?, phone = ?, city = ?, district = ?, ward = ?, specific_address = ?, address_type = ?, updated_at = NOW() " +
                     "WHERE address_id = ? AND user_id = ?";

        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, address.getFullName());
            statement.setString(2, address.getPhone());
            statement.setString(3, address.getCity());
            statement.setString(4, address.getDistrict());
            statement.setString(5, address.getWard());
            statement.setString(6, address.getSpecificAddress());
            statement.setString(7, address.getAddressType());
            statement.setInt(8, address.getId());
            statement.setInt(9, address.getUserId());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra xem addressId có thuộc userId không
    public boolean isAddressOwnedByUser(int userId, int addressId) {
        String sql = "SELECT COUNT(*) FROM addresses WHERE address_id = ? AND user_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, addressId);
            statement.setInt(2, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra địa chỉ trùng lặp
    public boolean isDuplicateAddress(int userId, String fullName, String phone, String city, String district, String ward, String specificAddress, String addressType, int excludeAddressId) {
        String sql = "SELECT COUNT(*) FROM addresses WHERE user_id = ? AND full_name = ? AND phone = ? AND city = ? AND district = ? AND ward = ? AND specific_address = ? AND address_type = ? AND address_id <> ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setString(2, fullName != null ? fullName : "");
            statement.setString(3, phone != null ? phone : "");
            statement.setString(4, city != null ? city : "");
            statement.setString(5, district != null ? district : "");
            statement.setString(6, ward != null ? ward : "");
            statement.setString(7, specificAddress != null ? specificAddress : "");
            statement.setString(8, addressType != null ? addressType : "");
            statement.setInt(9, excludeAddressId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
