package controller;

import java.io.IOException;
import java.util.List;
import DAO.CategoriesDAO;
import Entity.Categories;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/loai-tin")
public class LoaiTinController extends HttpServlet {

    CategoriesDAO cd = new CategoriesDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        String success = req.getParameter("success");
        if (success != null) {
            req.setAttribute("success", success);
        }

        try {
            if ("delete".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                cd.delete(id);
                req.setAttribute("success", "xóa thành công");
            } else if ("edit".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                req.setAttribute("editCategory", cd.selectByID(id));
            }
        } catch (Exception e) {
            req.setAttribute("error", "lỗi: " + e.getMessage());
        }

        req.setAttribute("listCategory", cd.selectAll());
        req.getRequestDispatcher("/view/admin/LoaiTin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");

        try {
            if (name == null || name.trim().isEmpty()) {
                req.setAttribute("error", "Tên loại tin không được để trống.");
                req.setAttribute("listCategory", cd.selectAll());

                if ("update".equals(action) && idStr != null) {
                    Categories ct = new Categories();
                    ct.setId(Integer.parseInt(idStr));
                    ct.setName("");
                    req.setAttribute("editCategory", ct);
                }

                req.getRequestDispatcher("/view/admin/LoaiTin.jsp").forward(req, resp);
                return;
            }

            if ("update".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                Categories old = cd.selectByID(id);
                old.setName(name.trim());
                cd.update(old);
                resp.sendRedirect(req.getContextPath() + "/loai-tin?success=update");
            } else if ("insert".equals(action)) {
                Categories ct = new Categories();
                ct.setName(name.trim());
                cd.insert(ct);
                resp.sendRedirect(req.getContextPath() + "/loai-tin?success=insert");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.setAttribute("listCategory", cd.selectAll());
            req.getRequestDispatcher("/view/admin/LoaiTin.jsp").forward(req, resp);
        }
    }
}
