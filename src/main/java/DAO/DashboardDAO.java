package DAO;

import java.sql.SQLException;
import Util.DBConnection; // Import lớp tiện ích kết nối của bạn

public class DashboardDAO {

  
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(Id) FROM users";
        try {
            // Sử dụng DBConnection.value() để lấy giá trị cột đầu tiên (COUNT)
            Object result = DBConnection.value(sql);
            return (result instanceof Number) ? ((Number) result).intValue() : 0;
        } catch (Exception e) {
            // Bao bọc ngoại lệ để xử lý lỗi SQL
            throw new SQLException("Lỗi khi truy vấn tổng số người dùng.", e);
        }
    }

    /**
     * Lấy tổng số loại tin từ bảng 'categories'.
     */
    public int getTotalCategories() throws SQLException {
        String sql = "SELECT COUNT(Id) FROM categories";
        try {
            // Sử dụng DBConnection.value()
            Object result = DBConnection.value(sql);
            return (result instanceof Number) ? ((Number) result).intValue() : 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi khi truy vấn tổng số loại tin.", e);
        }
    }


    public int getTotalPendingNews() throws SQLException {
        // Truyền tham số cho mệnh đề WHERE
        String sql = "SELECT COUNT(Id) FROM news WHERE Home = ?"; 
        try {
            // Sử dụng DBConnection.value(sql, tham số)
            Object result = DBConnection.value(sql, 0); // Home = 0
            return (result instanceof Number) ? ((Number) result).intValue() : 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi khi truy vấn tổng số tin tức chờ duyệt.", e);
        }
    }

   
    public int getTotalSubscribers() throws SQLException {
        // Truyền tham số cho mệnh đề WHERE
        String sql = "SELECT COUNT(Email) FROM newsletters WHERE Enabled = ?"; 
        try {
            // Sử dụng DBConnection.value(sql, tham số)
            Object result = DBConnection.value(sql, 1); // Enabled = 1
            return (result instanceof Number) ? ((Number) result).intValue() : 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi khi truy vấn tổng số người đăng ký.", e);
        }
    }
}