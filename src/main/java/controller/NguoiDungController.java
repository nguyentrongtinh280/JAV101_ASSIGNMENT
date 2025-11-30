package controller;

import java.io.IOException;
import java.util.List;

import DAO.NguoiDungDAO;
import Entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/nguoi-dung")
public class NguoiDungController extends HttpServlet {
	
	NguoiDungDAO dao = new NguoiDungDAO();

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");

        try {
            if ("delete".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                dao.delete(id);
                req.setAttribute("success", "Xóa người dùng thành công!");
            }
            else if ("edit".equals(action) && idStr != null) {
                int id = Integer.parseInt(idStr);
                User user = dao.selectById(id);

                if (user != null) {
                    req.setAttribute("editUser", user);
                } else {
                    req.setAttribute("error", "Người dùng không tồn tại.");
                }
            }

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        
        List<User> list = dao.selectAll();
        req.setAttribute("listUser", list);

        req.getRequestDispatcher("/view/admin/NguoiDung.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String action = req.getParameter("action");

            String idStr = req.getParameter("id");
            String fullname = req.getParameter("fullname");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String confirm = req.getParameter("confirm_password");
            String mobile = req.getParameter("mobile");
            String birthdayStr = req.getParameter("birthday");
            String genderStr = req.getParameter("gender");
            String roleStr = req.getParameter("role");

            if (fullname.isEmpty()) {
                req.setAttribute("error", "Họ và tên không được để trống.");
            } else if (email.isEmpty()) {
                req.setAttribute("error", "Email không được để trống.");
            } else if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
                req.setAttribute("error", "Email không hợp lệ.");
            } else if (password.isEmpty() && "insert".equals(action)) { 
                req.setAttribute("error", "Mật khẩu không được để trống.");
            } else if (!password.equals(confirm)) {
                req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            } else if (mobile.isEmpty()) {
                req.setAttribute("error", "Số điện thoại không được để trống.");
            } else if (!mobile.matches("0[0-9]{9}")) {
                req.setAttribute("error", "Số điện thoại không hợp lệ.");
            } else if (birthdayStr.isEmpty()) {
                req.setAttribute("error", "Ngày sinh không được để trống.");
            } else if (genderStr == null || genderStr.isEmpty()) {
                req.setAttribute("error", "Vui lòng chọn giới tính.");
            } else if (roleStr == null || roleStr.isEmpty()) {
                req.setAttribute("error", "Vui lòng chọn vai trò.");
            } 
            else {
            	if ("update".equals(action) && idStr != null) {

            	    int id = Integer.parseInt(idStr);
            	    User old = dao.selectById(id);

            	    if (old == null) {
            	        req.setAttribute("error", "Người dùng không tồn tại.");
            	    } else {

            	        User u = new User();
            	        u.setId(id);
            	        u.setFullname(fullname);
            	        u.setEmail(email);
            	        u.setMobile(mobile);
            	        u.setGender(genderStr.equals("1") ? 1 : 0);
            	        u.setRole(Integer.parseInt(roleStr));

            	        if (password == null || password.isEmpty()) {
            	            u.setPassword(old.getPassword());
            	        } else {
            	            if (!password.equals(confirm)) {
            	                req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            	                req.setAttribute("editUser", old);
            	                req.getRequestDispatcher("/view/admin/NguoiDung.jsp").forward(req, resp);
            	                return;
            	            }
            	            u.setPassword(password);
            	        }

            	        if (birthdayStr == null || birthdayStr.isEmpty()) {
            	            u.setBirthday(old.getBirthday());
            	        } else {
            	            u.setBirthday(java.sql.Date.valueOf(birthdayStr));
            	        }

            	        dao.update(u);
            	    }

            	    resp.sendRedirect(req.getContextPath() + "/nguoi-dung?success=update");
            	    return;
            	}
                else if ("insert".equals(action)) {

                    User u = new User();
                    u.setFullname(fullname);
                    u.setEmail(email);
                    u.setPassword(password);
                    u.setMobile(mobile);
                    u.setGender(genderStr.equals("1") ? 1 : 0);
                    u.setRole(Integer.parseInt(roleStr));

                    if (birthdayStr != null && !birthdayStr.isEmpty()) {
                        u.setBirthday(java.sql.Date.valueOf(birthdayStr));
                    }

                    dao.insert(u);

                    resp.sendRedirect(req.getContextPath() + "/nguoi-dung?success=insert");
                    return;
                }
            }

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        req.setAttribute("listUser", dao.selectAll());
        req.getRequestDispatcher("/view/admin/NguoiDung.jsp").forward(req, resp);
    }
}
