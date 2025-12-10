package Util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
// Import lớp cấu hình đã được tạo (Giả định bạn đã đặt nó tại đây)

public class EmailUtil {

	   // Địa chỉ email người gửi
    public static final String mail = "quocanhbuinhat@gmail.com"; 
    // Mật khẩu ứng dụng (App Password)
    public static final String password = "mkjjiljafkdbvmqg";

    public static void sendNewNewsNotification(String recipientEmail, String newsTitle, String newsLink) {
        
        // 1. Cấu hình Properties
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587");

        // 2. Tạo Session
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("quocanhbuinhat@gmail.com", "mkjjiljafkdbvmqg");
            }
        });

        try {
            // 3. Tạo đối tượng Message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("quocanhbuinhat@gmail.com", "Hệ thống Tin tức từ trang Góc Nhìn Báo Chí"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            
            // 4. Thiết lập tiêu đề và nội dung HTML
            message.setSubject("[TIN NÓNG] " + newsTitle);
            
            String content = "Xin chào Quý độc giả,<br><br>"
                           + "Một bản tin mới vừa được đăng tải:<br>"
                           + "<h3>" + newsTitle + "</h3>"
                           + "<p>Hãy click vào liên kết dưới đây để đọc ngay:</p>"
                           + "<a href=\"" + newsLink + "\">Đọc ngay: " + newsTitle + "</a>"
                           + "<br><br>Trân trọng,<br>Đội ngũ Quản trị Tin tức.";
            
            message.setContent(content, "text/html; charset=UTF-8");

            // 5. Gửi Message
            Transport.send(message);

        } catch (Exception e) {
            System.err.println("Lỗi khi gửi email đến " + recipientEmail + ": " + e.getMessage());
            // In lỗi ra console để debug
            e.printStackTrace();
        }
    }
}