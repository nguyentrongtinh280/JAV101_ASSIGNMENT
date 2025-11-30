package DAO;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Entity.User;
import Util.DBConnection;

public class NguoiDungDAO {
	
	// Thêm người dùng
    public void insert(User user) {
        String sql = "INSERT INTO users(fullname, email, password, role, birthday, gender, mobile) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        DBConnection.update(sql,
                user.getFullname(),
                user.getEmail(),
                user.getPassword(),
                user.getRole(),
                user.getBirthday(),
                user.getGender(),
                user.getMobile()
        );
    }

    // Cập nhật người dùng
    public void update(User user) {
        String sql = "UPDATE users SET fullname=?, email=?, password=?, role=?, birthday=?, gender=?, mobile=? "
                   + "WHERE id=?";
        DBConnection.update(sql,
                user.getFullname(),
                user.getEmail(),
                user.getPassword(),
                user.getRole(),
                user.getBirthday(),
                user.getGender(),
                user.getMobile(),
                user.getId()
        );
    }

    // Xóa theo ID
    public void delete(int id) {
        String sql = "DELETE FROM users WHERE id=?";
        DBConnection.update(sql, id);
    }

    // Lấy 1 người dùng theo id
    public User selectById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try {
            ResultSet rs = DBConnection.query(sql, id);
            if (rs.next()) {
                User user = mapUser(rs);
                rs.getStatement().getConnection().close();
                return user;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    // Lấy user theo email
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email=?";
        try {
            ResultSet rs = DBConnection.query(sql, email);
            if (rs.next()) {
                User u = mapUser(rs);
                rs.getStatement().getConnection().close();
                return u;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    // Kiểm tra đăng nhập
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        try {
            ResultSet rs = DBConnection.query(sql, email, password);
            if (rs.next()) {
                User user = mapUser(rs);
                rs.getStatement().getConnection().close();
                return user;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    // Lấy tất cả người dùng
    public List<User> selectAll() {
        String sql = "SELECT * FROM users";
        List<User> list = new ArrayList<>();

        try {
            ResultSet rs = DBConnection.query(sql);
            while (rs.next()) {
                list.add(mapUser(rs));
            }
            rs.getStatement().getConnection().close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    // Đếm số lượng user
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        Object obj = DBConnection.value(sql);
        return obj == null ? 0 : Integer.parseInt(obj.toString());
    }

    private User mapUser(ResultSet rs) throws Exception {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullname(rs.getString("fullname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getInt("role"));
        user.setBirthday(rs.getDate("birthday"));
        user.setGender(rs.getInt("gender"));
        user.setMobile(rs.getString("mobile"));
        return user;
    }

}
