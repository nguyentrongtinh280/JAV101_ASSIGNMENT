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

@WebServlet("/van-hoa")
public class BaoVanHoaController extends HttpServlet {
	
	private NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<News> list = newsDAO.getNewsByCategory(2); // Văn hóa = 2

        req.setAttribute("vanHoaList", list);
        req.getRequestDispatcher("/view/news/VanHoa.jsp").forward(req, resp);
    }

}
