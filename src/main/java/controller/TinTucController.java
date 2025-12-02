package controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger; // Thêm import cho Logger

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // <--- Cần thiết cho Flash Message

import DAO.NewsDAO;
import Entity.News;

@WebServlet("/tin-tuc")
public class TinTucController extends HttpServlet {
    
    private NewsDAO newsDAO = new NewsDAO();
    // Khai báo Logger để ghi lỗi chi tiết
    private static final Logger LOGGER = Logger.getLogger(TinTucController.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        // Lấy Session và Context Path
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
                    // Truyền thông báo qua Session (Flash Message)
                    session.setAttribute("message", "Xóa bản tin ID: " + newsId + " thành công!");
                } else {
                    session.setAttribute("error", "Xóa bản tin ID: " + newsId + " thất bại.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "ID không hợp lệ khi xóa.");
                LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi ID khi xóa", e);
            }
            // Chuyển hướng lại trang chính để làm mới danh sách
            resp.sendRedirect(contextPath + "/tin-tuc");
            return; // Quan trọng: Dừng xử lý doGet sau khi chuyển hướng
        }
        
        // 2. HIỂN THỊ DANH SÁCH VÀ THÔNG BÁO
        
        // Lấy và xóa thông báo (Flash Message) từ Session
        // Điều này giúp thông báo chỉ xuất hiện một lần
        req.setAttribute("message", session.getAttribute("message"));
        session.removeAttribute("message");
        req.setAttribute("error", session.getAttribute("error"));
        session.removeAttribute("error");
        
        List<News> newsList = newsDAO.getAllNews();
        req.setAttribute("newsList", newsList);
        
        req.getRequestDispatcher("/view/admin/TinTuc.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String contextPath = req.getContextPath();
        
        // Lấy dữ liệu từ form
        String idParam = req.getParameter("id"); // ID trống (Add) hoặc có giá trị (Update)
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String authorInput = req.getParameter("author"); 
        String image = req.getParameter("image");
        
        int categoryId = 0;
        try {
            categoryId = Integer.parseInt(req.getParameter("categoryid")); 
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi Category ID.", e);
        }
        
        // Xử lý Checkbox: nếu checked thì là "true", nếu không có giá trị (null) thì là false
        boolean home = "true".equals(req.getParameter("home"));

        // Tạo đối tượng News
        News news = new News();
        news.setTitle(title);
        news.setContent(content);
        news.setImage(image);
        news.setCategoryId(categoryId);
        news.setHome(home);
        
        // Các trường mặc định/cập nhật:
        news.setPostedDate(new Date()); // Lấy ngày hiện tại
        news.setViewCount(0); // ViewCount không thay đổi khi thêm/sửa qua admin
        
        // LOGIC GÁN STRING AUTHOR
        String finalAuthor;
        if (authorInput != null && !authorInput.trim().isEmpty()) {
            finalAuthor = authorInput.trim(); 
        } else {
            finalAuthor = "Admin"; 
        }
        news.setAuthor(finalAuthor); 

        boolean success = false;
        String actionType = "";

        // Xử lý Thêm mới (Id rỗng) hoặc Cập nhật (Id đã có)
        if (idParam == null || idParam.isEmpty()) {
            // 1. THÊM MỚI
            actionType = "Thêm mới";
            success = newsDAO.addNews(news);
        } else {
            // 2. CẬP NHẬT (UPDATE)
            actionType = "Cập nhật";
            try {
                int newsId = Integer.parseInt(idParam);
                news.setId(newsId);
                // Gọi phương thức UPDATE đã được thêm vào NewsDAO
                success = newsDAO.updateNews(news); 
            } catch (NumberFormatException e) {
                success = false;
                LOGGER.log(Level.SEVERE, "Lỗi chuyển đổi ID khi cập nhật", e);
            }
        }

        // Đặt thông báo vào Session để hiển thị sau khi chuyển hướng
        if (success) {
            session.setAttribute("message", actionType + " bản tin thành công!");
        } else {
            // Thông báo lỗi chi tiết hơn (ví dụ: lỗi khóa ngoại)
        	session.setAttribute("error", actionType + " bản tin thất bại. Lỗi Khóa ngoại: Tên tác giả (**" + finalAuthor + "**) có thể không tồn tại trong bảng Users hoặc lỗi CSDL khác.");
        }

        // Chuyển hướng về GET để tải lại danh sách
        resp.sendRedirect(contextPath + "/tin-tuc");
    }
}