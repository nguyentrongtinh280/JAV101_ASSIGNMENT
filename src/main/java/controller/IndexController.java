package controller;

import DAO.NewsDAO;
import Entity.News;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Ánh xạ Controller này tới các URL trang chủ
@WebServlet(urlPatterns = {"/index", "/home", ""}) 
public class IndexController extends HttpServlet {
    private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy danh sách các tin tức nổi bật (Home = 1)
            List<News> featuredNews = newsDAO.getFeaturedNews();
            
            // 2. Lấy danh sách tin tức mới nhất (Ví dụ: 8 tin) - Dùng cho Sidebar hoặc mục khác
            List<News> latestNews = newsDAO.getLatestNews(8); 

            // Đặt dữ liệu vào request để JSP hiển thị
            req.setAttribute("featuredNews", featuredNews);
            req.setAttribute("latestNews", latestNews);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: Không thể tải dữ liệu tin tức.");
        }

        // Chuyển tiếp tới trang chủ JSP
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}