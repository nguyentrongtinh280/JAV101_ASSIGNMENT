package Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBConnection {
	private static String url = "jdbc:mysql://localhost:3306/quanlybantin";
    private static String user = "root";      // thay bằng user MySQL của bạn
    private static String password = "buianh287"; // thay bằng mật khẩu MySQL


    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, password);
    }
 // Tạo PreparedStatement (cho phép truyền tham số)
    public static PreparedStatement getStmt(String sql, Object... args) throws Exception {
        Connection conn = getConnection(); 
        PreparedStatement stmt = conn.prepareStatement(sql);

        // Set tham số
        for (int i = 0; i < args.length; i++) {
            stmt.setObject(i + 1, args[i]);
        }

        return stmt;
    }

    // Thực thi INSERT, UPDATE, DELETE
    public static int update(String sql, Object... args) {
        try {
            PreparedStatement stmt = getStmt(sql, args);
            try {
                return stmt.executeUpdate();
            } finally {
                stmt.getConnection().close(); // đóng Connection
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Thực thi SELECT → trả về ResultSet
    public static ResultSet query(String sql, Object... args) {
        try {
            PreparedStatement stmt = getStmt(sql, args);
            return stmt.executeQuery(); // KHÔNG đóng ở đây (DAO đọc dữ liệu rồi đóng sau)
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Lấy giá trị đầu tiên (COUNT, SUM, 1 cột)
    public static Object value(String sql, Object... args) {
        try {
            ResultSet rs = query(sql, args);
            Object obj = null;
            if (rs.next()) {
                obj = rs.getObject(1); // lấy cột đầu tiên
            }
            rs.getStatement().getConnection().close();
            return obj;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
