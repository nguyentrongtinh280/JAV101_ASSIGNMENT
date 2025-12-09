package controller;

import java.io.IOException;
import DAO.NewsDAO;
import Entity.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        // BƯỚC 1: TĂNG VIEWCOUNT TRONG DATABASE
        // =======================================================
        newsDAO.UpdateViewCount(id); 

        // BƯỚC 2: Lấy thông tin bài viết (Lúc này đã bao gồm viewCount MỚI)
        News news = newsDAO.getNewsById(id);

        if (news == null) {
            req.setAttribute("message", "Bài viết không tồn tại!");
            req.getRequestDispatcher("/view/news/404.jsp").forward(req, resp);
            return;
        }

        // Gửi dữ liệu sang JSP
        req.setAttribute("newsItem", news);

        req.getRequestDispatcher("/view/news/ChiTietTin.jsp")
                .forward(req, resp);
    }
}