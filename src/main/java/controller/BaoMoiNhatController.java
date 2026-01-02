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

@WebServlet("/moi-nhat")
public class BaoMoiNhatController extends HttpServlet {

    private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<News> listMoiNhat = newsDAO.getAllNewsMoiNhat();

        req.setAttribute("listMoiNhat", listMoiNhat);

        req.getRequestDispatcher("/view/news/MoiNhat.jsp").forward(req, resp);
    }
}
