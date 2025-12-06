package controller;

import java.io.IOException;
import java.util.List;

import DAO.NewsDAO;
import Entity.News;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/thoi-su")
public class BaoThoiSuController extends HttpServlet{

	private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1: Loại Thời sự
        List<News> thoiSuList = newsDAO.getNewsByCategory(1);

        req.setAttribute("thoiSuList", thoiSuList);

        req.getRequestDispatcher("/view/news/ThoiSu.jsp").forward(req, resp);
    }
}
