package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Entity.User;
import java.sql.Date;

public class UserDAO {
    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    // Phương thức tiện ích để chuyển đổi ID vai trò sang tên vai trò (Được thêm vào)
    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1:
                return "Quản trị viên (Admin)";
            case 2:
                return "Người dùng thông thường";
            // Cần cập nhật các case này cho phù hợp với CSDL của bạn
            default:
                return "Vai trò không xác định";
        }
    }
    
    // Tìm user theo id
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE Id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // Tìm user theo email
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE Email=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // Thêm User
    public void insert(User u) throws SQLException {
        String sql = "INSERT INTO users(Fullname, Email, Password, Role, Birthday, Gender, Mobile) VALUES(?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setInt(4, u.getRole());
            ps.setDate(5, u.getBirthday());
            ps.setInt(6, u.getGender());
            ps.setString(7, null); 
            ps.executeUpdate();
        }
    }

    // Map dữ liệu từ ResultSet sang User object
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullname(rs.getString("fullname"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getInt("role"));
        u.setBirthday(rs.getDate("birthday"));
        u.setGender(rs.getInt("gender"));
        return u;
    }

    // Lấy tất cả user
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT Id, Fullname, Email, Role, Birthday, Gender FROM users";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getInt("role"));
                u.setBirthday(rs.getDate("birthday"));
                u.setGender(rs.getInt("gender"));
                list.add(u);
            }
        }
        return list;
    }

    // Cập nhật User
    public boolean updateUser(User u) throws SQLException {
        String sql = "UPDATE users SET Fullname = ?, Email = ?, Role = ?, Birthday = ?, Gender = ?, Mobile = ? WHERE Id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setInt(3, u.getRole());
            ps.setDate(4, u.getBirthday());
            ps.setInt(5, u.getGender());
            ps.setString(6, null);
            ps.setInt(7, u.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // Xóa User
    public boolean deleteUser(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE Id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Lấy user theo id
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE Id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setFullname(rs.getString("fullname"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setRole(rs.getInt("role"));
                    u.setBirthday(rs.getDate("birthday"));
                    u.setGender(rs.getInt("gender"));
                    return u;
                }
            }
        }
        return null;
    }

    // Phương thức login được giữ nguyên trả về User, nhưng ta có thể dùng 
    // hàm mới để tạo thông báo ngay sau khi đăng nhập thành công ở tầng trên.
    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE Email=? AND Password=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }
    
    // Phương thức tiện ích để tạo thông báo sau khi đăng nhập (Được thêm vào)
    // PHƯƠNG THỨC NÀY NÊN ĐƯỢC ĐẶT Ở LỚP SERVICE, nhưng tôi đặt ở đây theo yêu cầu
    public String createLoginStatusMessage(User u) {
        if (u != null) {
            String roleName = getRoleName(u.getRole());
            return "Đăng nhập thành công! Chào mừng, " + u.getFullname() + ". Vai trò của bạn là: **" + roleName + "**.";
        } else {
            return "Đăng nhập thất bại. Email hoặc mật khẩu không chính xác.";
        }
    }
}