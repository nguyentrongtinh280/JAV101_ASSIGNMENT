package Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	private static String url = "jdbc:mysql://localhost:3306/quanlybantin";
    private static String user = "root";      // thay bằng user MySQL của bạn
    private static String password = "buianh287"; // thay bằng mật khẩu MySQL

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, password);
    }
}
