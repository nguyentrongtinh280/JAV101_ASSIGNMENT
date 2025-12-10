package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import DAO.NewsDAO;
import Entity.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/chi-tiet-tin")
public class ChiTietTinController extends HttpServlet {

    private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");

        // Kiểm tra tham số
        if (idRaw == null || !idRaw.matches("\\d+")) {
            resp.sendRedirect("error.jsp");
            return;
        }

        int id = Integer.parseInt(idRaw);

        // =======================================================
        // BƯỚC 1: TĂNG VIEWCOUNT TRONG DATABASE (CODE MỚI)
        // =======================================================
        newsDAO.UpdateViewCount(id);

        // BƯỚC 2: Lấy thông tin bài viết sau khi tăng view
        News news = newsDAO.getNewsById(id);

        if (news == null) {
            req.setAttribute("message", "Bài viết không tồn tại!");
            req.getRequestDispatcher("/view/news/404.jsp").forward(req, resp);
            return;
        }
        
        // Hiển thị 5 tin gần đây đã xem
        HttpSession session = req.getSession();
        List<Integer> viewed = (List<Integer>) session.getAttribute("viewed");
        if (viewed == null) viewed = new ArrayList<>();

        int newsId = Integer.parseInt(req.getParameter("id"));

        // Nếu tin đã tồn tại trong danh sách thì xóa để đưa lên cuối
        viewed.remove(Integer.valueOf(newsId));

        // Thêm vào cuối danh sách
        viewed.add(newsId);

        // Chỉ giữ tối đa 5 tin
        while (viewed.size() > 5) {
            viewed.remove(0); // xóa tin cũ nhất
        }

        session.setAttribute("viewed", viewed);

        // 3. Gửi dữ liệu sang JSP
        req.setAttribute("newsItem", news);

        req.getRequestDispatcher("/view/news/ChiTietTin.jsp")
                .forward(req, resp);
    }
}
