package controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.DashboardDAO;

@WebServlet("/admin")
public class IndexAdminController extends HttpServlet {
	
    private DashboardDAO dashboardDAO = new DashboardDAO();
    
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
        try {
            // 1. Lấy dữ liệu thực tế từ MySQL
            int totalUsers = dashboardDAO.getTotalUsers();
            int totalCategories = dashboardDAO.getTotalCategories(); 
            int totalPendingNews = dashboardDAO.getTotalPendingNews();
            int totalSubscribers = dashboardDAO.getTotalSubscribers();
            
            // 2. Gửi dữ liệu sang JSP
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("totalPendingNews", totalPendingNews);
            req.setAttribute("totalSubscribers", totalSubscribers);
            
            // Lượt truy cập hôm nay (tạm thời hardcode vì cần cơ chế tracking phức tạp)
            req.setAttribute("totalTodayVisitors", 560); 
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý khi có lỗi DB: đặt giá trị Lỗi
            String error = "Lỗi truy vấn Database!";
            req.setAttribute("totalUsers", error);
            req.setAttribute("totalCategories", error);
            req.setAttribute("totalPendingNews", error);
            req.setAttribute("totalSubscribers", error);
            req.setAttribute("totalTodayVisitors", error);
        }
        
		req.getRequestDispatcher("/view/admin/IndexAdmin.jsp").forward(req, resp);
	}

}