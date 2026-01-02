package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Entity.Newsletter;
import Util.DBConnection;

public class NewsletterDAO {
	// Giả sử bảng newsletter có cột 'Email' và 'Status' (1 là Hoạt động)
    public List<String> getAllActiveSubscribers() {
        List<String> emails = new ArrayList<>();
        // Lấy tất cả email có trạng thái "Hoạt động" (giả sử Status = 1)
        String query = "SELECT Email FROM newsletters WHERE Enabled = 1"; 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                emails.add(rs.getString("Email"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return emails;
    }

    public void insert(Newsletter n) {
        String sql = "INSERT INTO newsletters(Email, Enabled) VALUES (?, ?)";
        DBConnection.update(sql,
                n.getEmail(),
                n.isEnabled()
        );
    }
    
    public void update(Newsletter n) {
        String sql = "UPDATE newsletters SET Enabled=? WHERE Email=?";
        DBConnection.update(sql,
                n.isEnabled(),
                n.getEmail()
        );
    }

    public void delete(String email) {
        String sql = "DELETE FROM newsletters WHERE Email=?";
        DBConnection.update(sql, email);
    }

    public Newsletter selectByEmail(String email) {
        String sql = "SELECT * FROM newsletters WHERE Email=?";
        try {
            ResultSet rs = DBConnection.query(sql, email);
            if (rs.next()) {
                Newsletter n = mapNewsletter(rs);
                rs.getStatement().getConnection().close();
                return n;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public List<Newsletter> selectAll() {
        String sql = "SELECT * FROM newsletters";
        List<Newsletter> list = new ArrayList<>();

        try {
            ResultSet rs = DBConnection.query(sql);
            while (rs.next()) {
                list.add(mapNewsletter(rs));
            }
            rs.getStatement().getConnection().close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM newsletters";
        Object obj = DBConnection.value(sql);
        return obj == null ? 0 : Integer.parseInt(obj.toString());
    }

    // Hàm map từ ResultSet sang Entity
    private Newsletter mapNewsletter(ResultSet rs) throws Exception {
        Newsletter n = new Newsletter();
        n.setEmail(rs.getString("Email"));
        n.setEnabled(rs.getBoolean("Enabled"));
        return n;
    }
}