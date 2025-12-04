package controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.URLDecoder;
import java.util.List;

import DAO.NewsletterDAO;
import Entity.Newsletter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.BeanUtils;

@WebServlet({
	"/newsletter",
    "/newsletter/edit/*",
    "/newsletter/create",
    "/newsletter/update",
    "/newsletter/delete",
    "/newsletter/reset"	
})
public class NewsletterController extends HttpServlet {
	
	private NewsletterDAO dao = new NewsletterDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getServletPath();

        if (uri.contains("edit")) {
            String email = URLDecoder.decode(req.getPathInfo().substring(1), "UTF-8");
            Newsletter form = dao.selectByEmail(email);
            req.setAttribute("item", form);
        } else {
            req.setAttribute("item", new Newsletter());
        }

        req.setAttribute("list", dao.selectAll());
        req.getRequestDispatcher("/view/admin/Newsletter.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Newsletter form = new Newsletter();
        try {
            BeanUtils.populate(form, req.getParameterMap());
        } catch (Exception e) {
            e.printStackTrace();
        }

        String uri = req.getServletPath();

        // Validate email rỗng
        if (form.getEmail() == null || form.getEmail().trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email!");
            req.setAttribute("item", form);
            req.setAttribute("list", dao.selectAll());
            req.getRequestDispatcher("/view/admin/Newsletter.jsp").forward(req, resp);
            return;
        }

        // Validate định dạng email
        if (!form.getEmail().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            req.setAttribute("error", "Email không hợp lệ!");
            req.setAttribute("item", form);
            req.setAttribute("list", dao.selectAll());
            req.getRequestDispatcher("/view/admin/Newsletter.jsp").forward(req, resp);
            return;
        }

        if (uri.contains("create")) {
            if (dao.selectByEmail(form.getEmail()) != null) {
                req.setAttribute("error", "Email đã tồn tại!");
                req.setAttribute("item", form);
                req.setAttribute("list", dao.selectAll());
req.getRequestDispatcher("/view/admin/Newsletter.jsp").forward(req, resp);
                return;
            }

            dao.insert(form);
            resp.sendRedirect(req.getContextPath() + "/newsletter?success=insert");

        } else if (uri.contains("update")) {
            dao.update(form);
            resp.sendRedirect(req.getContextPath() + "/newsletter?success=update");

        } else if (uri.contains("delete")) {
            dao.delete(form.getEmail());
            resp.sendRedirect(req.getContextPath() + "/newsletter?success=delete");

        } else if (uri.contains("reset")) {
            resp.sendRedirect(req.getContextPath() + "/newsletter");
        }
    }

}