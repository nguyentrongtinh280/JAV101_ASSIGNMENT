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

@WebServlet("/giao-duc")
public class BaoGiaoDucController extends HttpServlet {

	private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

<<<<<<< Updated upstream
        List<News> list = newsDAO.getNewsByCategory(7); // Giáo dục = 7
=======
        List<News> list = newsDAO.getNewsByCategory(7); // Giáo dục = 5
>>>>>>> Stashed changes

        req.setAttribute("giaoDucList", list);
        req.getRequestDispatcher("/view/news/GiaoDuc.jsp").forward(req, resp);
    }
}
