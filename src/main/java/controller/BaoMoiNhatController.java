package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.NewsDAO; // Import NewsDAO
import Entity.News;  // Import News entity

@WebServlet("/moi-nhat")
public class BaoMoiNhatController extends HttpServlet {
	
    private NewsDAO newsDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        newsDAO = new NewsDAO(); 
    }
    
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

		try {
            // 🔥 THAY ĐỔI QUAN TRỌNG: Gọi phương thức lấy TẤT CẢ tin tức 🔥
            List<News> allNewsList = newsDAO.getAllNews(); 
            
            // Đặt danh sách vào request scope với tên biến là 'latestNewsList'
            req.setAttribute("latestNewsList", allNewsList); 
            
            // Chuyển tiếp tới trang JSP
            req.getRequestDispatcher("/view/news/MoiNhat.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu tin mới nhất.");
        }
	}
}