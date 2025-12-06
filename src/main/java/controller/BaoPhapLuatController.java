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

@WebServlet("/phap-luat")
public class BaoPhapLuatController extends HttpServlet {
	private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<News> list = newsDAO.getNewsByCategory(3); // Pháp luật = 3

        req.setAttribute("phapLuatList", list);
        req.getRequestDispatcher("/view/news/PhapLuat.jsp").forward(req, resp);
    }
}
