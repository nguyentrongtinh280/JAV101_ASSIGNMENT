package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import DAO.NewsDAO;
import Entity.News;

@WebServlet("/tin-tuc")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class TinTucController extends HttpServlet {

    private NewsDAO newsDAO = new NewsDAO();
    private static final Logger LOGGER = Logger.getLogger(TinTucController.class.getName());
    
    // ⭐ CẦN THAY ĐỔI ĐƯỜNG DẪN NÀY ĐỂ ĐÚNG VỚI MÁY CỦA BẠN ⭐
    private static final String UPLOAD_DIRECTORY = "C:\\Users\\ADMIN\\OneDrive\\Pictures\\anh di co ba\\"; 
    
    // ==========================================================
    // ⭐ HÀM LẤY GIÁ TRỊ TRƯỜNG FORM (TEXT) TỪ PART ⭐
    // ==========================================================
    private String getFormFieldValue(HttpServletRequest req, String fieldName) {
        try {
            // Lấy tất cả các Part có cùng tên, nếu có nhiều (nhưng thường chỉ có 1)
            List<Part> parts = (List<Part>) req.getParts();
            
            for (Part part : parts) {
                if (part.getName().equals(fieldName)) {
                    // Tránh xử lý trường file nếu nó có cùng tên
                    if (part.getSubmittedFileName() != null) {
                        continue; 
                    }
                    
                    // Đọc nội dung từ Part
                    try (InputStream is = part.getInputStream()) {
                        byte[] bytes = new byte[is.available()];
                        is.read(bytes);
                        // Chuyển đổi byte[] sang String với encoding UTF-8
                        return new String(bytes, "UTF-8");
                    }
                }
            }
            return null;
        } catch (Exception e) {
             LOGGER.log(Level.WARNING, "Không tìm thấy Part cho field: " + fieldName, e);
             return null; 
        }
    }

    // ==========================================================
    // ⭐ HÀM XỬ LÝ UPLOAD FILE ⭐
    // ==========================================================
    private String uploadFile(Part imagePart) throws IOException {
        String submittedFileName = imagePart.getSubmittedFileName();
        
        // Kiểm tra nếu không có tệp nào được gửi (hoặc là một trường form thường)
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null; 
        }

        // Tạo tên file duy nhất
        String extension = "";
        int i = submittedFileName.lastIndexOf('.');
        if (i > 0) {
            extension = submittedFileName.substring(i);
        }
        String uniqueFileName = System.currentTimeMillis() + extension; 

        // Đảm bảo thư mục upload tồn tại
        Path uploadPath = Paths.get(UPLOAD_DIRECTORY);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // Lưu tệp
        Path filePath = uploadPath.resolve(uniqueFileName);
        
        try (InputStream fileContent = imagePart.getInputStream()) {
            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Trả về tên file đã được lưu
        return uniqueFileName; 
    }
    
    // ==========================================================
    // ⭐ DO GET (GIỮ NGUYÊN) ⭐
    // ==========================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String contextPath = req.getContextPath();
        String action = req.getParameter("action");
        String newsIdParam = req.getParameter("id");
        
        // 1. XỬ LÝ HÀNH ĐỘNG XÓA (DELETE)
        if ("delete".equals(action) && newsIdParam != null) {
            try {
                int newsId = Integer.parseInt(newsIdParam);
                boolean success = newsDAO.deleteNews(newsId);
                
                if (success) {
                    session.setAttribute("message", "Xóa bản tin ID: " + newsId + " thành công!");
                } else {
                    session.setAttribute("error", "Xóa bản tin ID: " + newsId + " thất bại. Có thể do khóa ngoại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID không hợp lệ khi xóa.");
                LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi ID khi xóa", e);
            }
            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }
        
        // 2. HIỂN THỊ DANH SÁCH VÀ THÔNG BÁO 
        req.setAttribute("message", session.getAttribute("message"));
        session.removeAttribute("message");
        req.setAttribute("error", session.getAttribute("error"));
        session.removeAttribute("error");
        
        List<News> newsList = newsDAO.getAllNews();
        req.setAttribute("newsList", newsList);
        
        req.getRequestDispatcher("/view/admin/TinTuc.jsp").forward(req, resp);
    }
    
    // ==========================================================
    // ⭐ DO POST (ĐÃ SỬA VÀ HOÀN CHỈNH) ⭐
    // ==========================================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String contextPath = req.getContextPath();

        // ----------------------------------------------------
        // LẤY DỮ LIỆU TỪ FORM (SỬ DỤNG HÀM getFormFieldValue)
        // ----------------------------------------------------
        String idParam = getFormFieldValue(req, "id");
        String title = getFormFieldValue(req, "title");
        String content = getFormFieldValue(req, "content");
        String authorInput = getFormFieldValue(req, "author"); 
        String categoryIdStr = getFormFieldValue(req, "categoryid");
        String homeStr = getFormFieldValue(req, "home");
        String currentImageURL = getFormFieldValue(req, "currentImageURL"); 
        
        // Lấy Part của file image
        Part imagePart = req.getPart("image");
        
        // ----------------------------------------------------
        // XỬ LÝ DỮ LIỆU VÀ VALIDATION
        // ----------------------------------------------------
        
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty() || categoryIdStr == null || categoryIdStr.isEmpty()) {
            session.setAttribute("error", "Vui lòng điền đầy đủ Tiêu đề, Nội dung và Loại tin.");
            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }
        
        int categoryId = 0;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi Category ID.", e);
            session.setAttribute("error", "Loại tin không hợp lệ.");
            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }
        
        String imageURL = currentImageURL; 
        try {
            // Chỉ upload nếu có tệp được gửi
            if (imagePart != null && imagePart.getSize() > 0) {
                 String uploadedFileName = uploadFile(imagePart);
                 if (uploadedFileName != null) {
                    imageURL = uploadedFileName; 
                 }
            }
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Lỗi khi upload file.", e);
             session.setAttribute("error", "Lỗi khi tải lên tệp: " + e.getMessage());
             resp.sendRedirect(contextPath + "/tin-tuc");
             return;
        }

        boolean home = "true".equals(homeStr);
        String finalAuthor = (authorInput != null && !authorInput.trim().isEmpty()) ? authorInput.trim() : "Admin";
        
        News news = new News();
        news.setTitle(title.trim());
        news.setContent(content.trim());
        news.setImage(imageURL);
        news.setCategoryId(categoryId);
        news.setHome(home);
        news.setAuthor(finalAuthor);

        boolean success = false;
        String actionType = "";

        // Xử lý Thêm mới (Id rỗng) hoặc Cập nhật (Id đã có)
        if (idParam == null || idParam.isEmpty()) {
            // 1. THÊM MỚI (Add)
            actionType = "Thêm mới";
            
            news.setPostedDate(new Date()); 
            news.setViewCount(0);
            
            success = newsDAO.addNews(news);
        } else {
            // 2. CẬP NHẬT (Update)
            actionType = "Cập nhật";
            try {
                int newsId = Integer.parseInt(idParam);
                news.setId(newsId);
                
                News oldNews = newsDAO.getNewsById(newsId);
                
                if (oldNews != null) {
                    // GIỮ LẠI NGÀY ĐĂNG VÀ LƯỢT XEM CŨ
                    news.setPostedDate(oldNews.getPostedDate());
                    news.setViewCount(oldNews.getViewCount());
                } else {
                    news.setPostedDate(new Date()); 
                    news.setViewCount(0); 
                }
                
                success = newsDAO.updateNews(news); 
            } catch (NumberFormatException e) {
                success = false;
                LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi ID khi cập nhật", e);
            }
        }

        // Đặt thông báo vào Session
        if (success) {
            session.setAttribute("message", actionType + " bản tin thành công!");
        } else {
            session.setAttribute("error", actionType + " bản tin thất bại. Vui lòng kiểm tra lại ID loại tin và Tên tác giả (**" + finalAuthor + "**).");
        }

        resp.sendRedirect(contextPath + "/tin-tuc");
    }
}