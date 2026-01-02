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
import DAO.NewsDAO.Category; // Lớp Category đã được import
import DAO.NewsDAO;
import Entity.News;

// BỔ SUNG IMPORTS CHO TÍNH NĂNG EMAIL
import DAO.NewsletterDAO;
import Util.EmailUtil;
// END BỔ SUNG IMPORTS

@WebServlet("/tin-tuc")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class TinTucController extends HttpServlet {

    private NewsDAO newsDAO = new NewsDAO();
    // BỔ SUNG KHAI BÁO DAO CHO NEWSLETTER
    private NewsletterDAO newsletterDAO = new NewsletterDAO(); 
    // END BỔ SUNG DAO
    
    private static final Logger LOGGER = Logger.getLogger(TinTucController.class.getName());

    // Thư mục nằm trong webapp/upload_img/news
    private static final String UPLOAD_DIRECTORY = "upload_img/news";

    // Lấy dữ liệu text từ multipart form
    private String getFormFieldValue(HttpServletRequest req, String fieldName) {
        try {
            for (Part part : req.getParts()) {
                if (part.getName().equals(fieldName)) {
                    if (part.getSubmittedFileName() != null) continue;
                    try (InputStream is = part.getInputStream()) {
                        byte[] bytes = is.readAllBytes();
                        return new String(bytes, "UTF-8");
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không tìm thấy Part cho field: " + fieldName, e);
        }
        return null;
    }

    // Upload file vào thư mục của dự án (webapp/upload_img/news)
    private String uploadFile(Part imagePart, HttpServletRequest req) throws IOException {

        String submittedFileName = imagePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null;
        }

        String extension = "";
        int i = submittedFileName.lastIndexOf('.');
        if (i > 0) {
            extension = submittedFileName.substring(i);
        }

        String uniqueFileName = System.currentTimeMillis() + extension;

        //Lấy đường dẫn tuyệt đối của folder trong webapp
        String realPath = req.getServletContext().getRealPath("") 
                        + File.separator + UPLOAD_DIRECTORY;

        File uploadDir = new File(realPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Path filePath = Paths.get(realPath, uniqueFileName);

        try (InputStream fileContent = imagePart.getInputStream()) {
            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return uniqueFileName; // chỉ lưu tên file, không lưu đường dẫn
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String contextPath = req.getContextPath();

        String action = req.getParameter("action");
        String newsIdParam = req.getParameter("id");

        // Xóa
        if ("delete".equals(action) && newsIdParam != null) {
            try {
                int newsId = Integer.parseInt(newsIdParam);
                boolean success = newsDAO.deleteNews(newsId);

                if (success) {
                    session.setAttribute("message", "Xóa bản tin ID: " + newsId + " thành công!");
                } else {
                    session.setAttribute("error", "Xóa bản tin thất bại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID không hợp lệ khi xóa.");
            }

            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }
        
        // =================================================================
        // PHẦN ĐÃ SỬA: Lấy dữ liệu Category và truyền sang JSP
        // =================================================================
        try {
            List<Category> categoryList = newsDAO.getAllCategories();
            req.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Category", e);
            // Có thể set một danh sách rỗng nếu bị lỗi
            req.setAttribute("categoryList", List.of()); 
        }
        // =================================================================

        req.setAttribute("message", session.getAttribute("message"));
        session.removeAttribute("message");
        req.setAttribute("error", session.getAttribute("error"));
        session.removeAttribute("error");
        
        String searchKeyword = req.getParameter("searchKeyword");
        String categoryIdParam = req.getParameter("categoryId");

        int categoryId = 0; // Giá trị mặc định 0 cho 'Tất cả loại tin'
        try {
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdParam);
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "CategoryId không hợp lệ: " + categoryIdParam, e);
            categoryId = 0;
        }
        
        List<News> newsList;
        if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || categoryId > 0) {
            String trimmedKeyword = (searchKeyword != null) ? searchKeyword.trim() : ""; 
            
            newsList = newsDAO.searchNews(trimmedKeyword, categoryId);
            req.setAttribute("searchKeyword", trimmedKeyword); 
            req.setAttribute("selectedCategoryId", categoryId); 
        } else {
            newsList = newsDAO.getAllNews();
            req.setAttribute("selectedCategoryId", 0);
        }
        
        req.setAttribute("newsList", newsList);

        req.getRequestDispatcher("/view/admin/TinTuc.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String contextPath = req.getContextPath();

        // Lấy dữ liệu từ form
        String idParam = getFormFieldValue(req, "id");
        String title = getFormFieldValue(req, "title");
        String content = getFormFieldValue(req, "content");
        String authorInput = getFormFieldValue(req, "author");
        String categoryIdStr = getFormFieldValue(req, "categoryid");
        String homeStr = getFormFieldValue(req, "home");
        String currentImageURL = getFormFieldValue(req, "currentImageURL");
        Part imagePart = req.getPart("image");

        if (title == null || title.isEmpty() || content == null || content.isEmpty() || categoryIdStr == null) {
            session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (Exception e) {
            session.setAttribute("error", "Loại tin không hợp lệ.");
            resp.sendRedirect(contextPath + "/tin-tuc");
            return;
        }

        // Upload ảnh
        String imageURL = currentImageURL;

        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                String uploadedFileName = uploadFile(imagePart, req);
                if (uploadedFileName != null) {
                    imageURL = uploadedFileName;
                }
            } catch (Exception e) {
                session.setAttribute("error", "Lỗi upload file.");
                resp.sendRedirect(contextPath + "/tin-tuc");
                return;
            }
        }

        boolean home = "true".equals(homeStr);
        String finalAuthor = (authorInput != null && !authorInput.trim().isEmpty())
                ? authorInput.trim()
                : "Admin";

        News news = new News();
        news.setTitle(title.trim());
        news.setContent(content.trim());
        news.setImage(imageURL);
        news.setCategoryId(categoryId);
        news.setHome(home);
        news.setAuthor(finalAuthor);

        boolean success = false;
        String actionType = "";

        // Thêm mới
        if (idParam == null || idParam.isEmpty()) {
            actionType = "Thêm mới";
            news.setPostedDate(new Date());
            news.setViewCount(0);
            
            // THỰC HIỆN THÊM TIN
            success = newsDAO.addNews(news);
            
            // =================================================================
            // BỔ SUNG LOGIC GỬI EMAIL SAU KHI THÊM THÀNH CÔNG
            // =================================================================
            if (success) {
                try {
                    // Lấy danh sách email
                    List<String> subscribers = newsletterDAO.getAllActiveSubscribers();
                    
                    // Xây dựng link tạm thời cho bài viết mới
                    // Link này cần được cập nhật để trỏ đến trang chi tiết thực tế của tin tức
                    String newsLink = req.getRequestURL().toString().replace("/tin-tuc", req.getContextPath() + "/trang-chu"); 
                    
                    for (String email : subscribers) {
                        EmailUtil.sendNewNewsNotification(email, news.getTitle(), newsLink);
                    }
                    LOGGER.log(Level.INFO, "Đã gửi thông báo cho {0} người đăng ký.", subscribers.size());
                    
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "LỖI GỬI EMAIL SAU KHI THÊM TIN MỚI:", e);
                }
            }
            // =================================================================
        }
        // Cập nhật
        else {
            actionType = "Cập nhật";
            try {
                int newsId = Integer.parseInt(idParam);
                news.setId(newsId);

                News oldNews = newsDAO.getNewsById(newsId);
                if (oldNews != null) {
                    news.setPostedDate(oldNews.getPostedDate());
                    news.setViewCount(oldNews.getViewCount());
                } else {
                    news.setPostedDate(new Date());
                    news.setViewCount(0);
                }

                success = newsDAO.updateNews(news);

            } catch (Exception e) {
                success = false;
            }
        }

        if (success) {
            session.setAttribute("message", actionType + " bản tin thành công!");
        } else {
            session.setAttribute("error", actionType + " bản tin thất bại.");
        }

        resp.sendRedirect(contextPath + "/tin-tuc");
    }
}