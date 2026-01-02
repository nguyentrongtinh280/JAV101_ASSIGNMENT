package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/external-images/*")
public class ImageServlet extends HttpServlet {
    
    // ⭐ ĐƯỜNG DẪN TUYỆT ĐỐI NƠI LƯU ẢNH (Dùng cho thư mục OneDrive của bạn) ⭐
    // Vui lòng KHÔNG THAY ĐỔI đường dẫn này trừ khi bạn di chuyển thư mục.
    private static final String EXTERNAL_IMAGE_PATH = "C:\\Users\\Bùi anh - Personal\\OneDrive\\Pictures\\Screenshots\\";
    
    private static final Logger LOGGER = Logger.getLogger(ImageServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Lấy tên file ảnh từ URL (Phần sau /external-images/)
        String filename = request.getPathInfo();
        
        // Kiểm tra tính hợp lệ của đường dẫn
        if (filename == null || filename.length() < 2) {
            LOGGER.log(Level.WARNING, "Image request received without a filename.");
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Missing filename in path.");
            return;
        }
        
        // Cắt bỏ dấu '/' đầu tiên (Ví dụ: từ "/image.jpg" thành "image.jpg")
        filename = filename.substring(1);
        
        // ⭐ BƯỚC BẢO MẬT: Ngăn chặn Path Traversal Attack ⭐
        if (filename.contains("..") || filename.contains(File.separator) || filename.contains("/")) {
             LOGGER.log(Level.WARNING, "Path Traversal attempt blocked: " + filename);
             response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid filename or path.");
             return;
        }

        // 2. Tạo đối tượng File từ đường dẫn tuyệt đối
        File file = new File(EXTERNAL_IMAGE_PATH, filename);

        // 3. Kiểm tra file tồn tại và là file
        if (!file.exists() || !file.isFile()) {
            // ⭐ BƯỚC CHẨN ĐOÁN CỰC KỲ QUAN TRỌNG: Ghi log đường dẫn thất bại ⭐
            LOGGER.log(Level.SEVERE, "File NOT FOUND. Attempted path: " + file.getAbsolutePath() + ". Requested filename: " + filename);
            // Xử lý nếu không tìm thấy ảnh: Chuyển hướng đến ảnh mặc định trong dự án
            response.sendRedirect(request.getContextPath() + "/img/default-news.png");
            return;
        }
        
        // ⭐ LOG THÀNH CÔNG (Chỉ trong Debug): Ghi log khi file được tìm thấy ⭐
        LOGGER.log(Level.INFO, "File FOUND successfully: " + file.getAbsolutePath());


        // 4. Thiết lập Content Type (Ví dụ: image/jpeg, image/png)
        String contentType = getServletContext().getMimeType(filename);
        if (contentType == null) {
            // Thiết lập mặc định nếu không xác định được, tránh lỗi trình duyệt
            contentType = "image/jpeg";
        }
        response.setContentType(contentType);

        // 5. Thiết lập Content Length và đọc/ghi file
        response.setContentLengthLong(file.length());

        // Đọc file và ghi vào Output Stream của response
        try (FileInputStream in = new FileInputStream(file); 
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096]; // Tăng buffer size để đọc nhanh hơn
            int length;
            while ((length = in.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error streaming file: " + file.getAbsolutePath(), e);
            if (!response.isCommitted()) {
                 // Gửi lỗi Internal Server Error nếu không thể stream file
                 response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving file stream.");
            }
        }
    }
}