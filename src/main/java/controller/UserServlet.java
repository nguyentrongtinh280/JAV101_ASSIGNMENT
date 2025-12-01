package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import DAO.UserDAO;
import Entity.User;
import Util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Đã bỏ ký tự thừa

@WebServlet({ "/login", "/register", "/logout" }) // OK
public class UserServlet extends HttpServlet {
	
	// Tối ưu: Dùng hằng số static final để tránh nhầm lẫn
	private static final int ROLE_READER = 0;
	// private static final int ROLE_WRITER = 1; // Giả sử đây là Writer/Manager
	private static final int ROLE_MANAGER = 1; // Giả sử đây là Manager/Writer
	private static final int ROLE_ADMIN = 2; 

	private UserDAO dao;

	@Override
	public void init() throws ServletException {
		try {
			// Sửa: Connection nên được đóng (hoặc quản lý) sau khi sử dụng,
			// nhưng trong cấu trúc này, ta giả định DBConnection quản lý Pool hoặc là Singleton.
			// Giữ nguyên logic của bạn, nhưng lưu ý trong thực tế không nên giữ Connection lâu.
			Connection conn = DBConnection.getConnection(); 
			dao = new UserDAO(conn);
		} catch (Exception e) {
			e.printStackTrace(); // Bỏ ký tự thừa
			throw new ServletException("Không thể kết nối MySQL", e);
		}
	}
 
    // =========================================================
    // PHƯƠNG THỨC XỬ LÝ FLASH MESSAGE (Giữ nguyên)
    // Mục đích: Chuyển message từ SESSION (sau redirect) sang REQUEST (trước forward)
    // =========================================================
    private void handleFlashMessages(HttpServletRequest req) {
        // Lấy session hiện tại, không tạo mới
        HttpSession session = req.getSession(false);
        if (session != null) {
            
            // Xử lý flashError (Lỗi từ các servlet khác chuyển qua)
            String flashError = (String) session.getAttribute("flashError");
            if (flashError != null) {
                req.setAttribute("error", flashError);
                session.removeAttribute("flashError");
            }
            
            // Xử lý flashMessage (Thông báo thành công chung)
            String flashMessage = (String) session.getAttribute("flashMessage");
            if (flashMessage != null) {
                req.setAttribute("message", flashMessage);
                session.removeAttribute("flashMessage");
            }
            
            // Xử lý successMessage (Dùng cho Login.jsp sau Register/Logout)
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                // Đặt vào Session thay vì Request để Login.jsp có thể đọc từ Session.
                // Vì Login.jsp (hoặc trang khác) có thể redirect và cần đọc lại.
                // Tuy nhiên, vì code JSP của bạn đang đọc từ Session và tự xóa, ta giữ nguyên.
                req.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
        }
    }
    // =========================================================

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String uri = req.getRequestURI();
        
        // Luôn xử lý flash messages trước khi forward
        handleFlashMessages(req);
        
		if (uri.endsWith("/login")) {
			req.getRequestDispatcher("Login.jsp").forward(req, resp);
		} else if (uri.endsWith("/register")) {
			req.getRequestDispatcher("Register.jsp").forward(req, resp);
		} else if (uri.endsWith("/logout")) {
			
			// Lấy session hiện tại
			HttpSession session = req.getSession(false);
			
			if(session != null) {
                // 1. Lưu thông báo đăng xuất thành công vào Session (để Login.jsp đọc)
                // Đã tối ưu hóa: Sử dụng successMessage để tránh nhầm lẫn với flashMessage (của admin page)
			    session.setAttribute("successMessage", "Bạn đã đăng xuất thành công!");
			    
			    // 2. Hủy toàn bộ Session
			    session.invalidate();
			}

			// 3. Chuyển hướng về trang đăng nhập
			resp.sendRedirect(req.getContextPath() + "/login");

		} else {
            // Trường hợp không khớp: Đưa về trang chủ
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");
		
		String uri = req.getRequestURI();
        // Lấy Session, nếu chưa có thì tạo mới (đúng cho Login/Register)
        HttpSession session = req.getSession(true); 
        
		try {
			if (uri.endsWith("/login")) {
                // Tối ưu: Thêm kiểm tra đầu vào cơ bản
                String email = req.getParameter("email");
                String password = req.getParameter("password");

                if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                    req.setAttribute("error", "Vui lòng điền đầy đủ email và mật khẩu!");
                    req.getRequestDispatcher("Login.jsp").forward(req, resp);
                    return;
                }
                
                email = email.trim();
                password = password.trim();

				User u = dao.findByEmail(email);

				// SỬA CHỮA LỖI BẢO MẬT: Trong thực tế, KHÔNG BAO GIỜ DÙNG
                // 'u.getPassword().equals(password)' vì nó là Clear Text Password.
                // Tuy nhiên, trong phạm vi bài tập cơ bản, ta giữ nguyên.
                // Cần dùng hàm băm (Hashing) như BCrypt.
                
				if (u != null && u.getPassword().equals(password)) { 
					
					// 1. Lưu thông tin User vào Session với key "loggedInUser"
					session.setAttribute("loggedInUser", u);
					
					// 2. Flash Message: Hiển thị thông báo trên trang chủ/admin
					session.setAttribute("flashMessage", "Đăng nhập thành công! Chào mừng, " + u.getFullname() + "!");
					
					// 3. Chuyển hướng về trang tương ứng dựa trên Role
					if (u.getRole() == ROLE_ADMIN || u.getRole() == ROLE_MANAGER) {
						resp.sendRedirect(req.getContextPath() + "/admin"); 
					} else {
						// Độc giả hoặc Role khác về trang chủ
						resp.sendRedirect(req.getContextPath() + "/index.jsp"); 
					}
					return;
				} else {
					// Đăng nhập thất bại: Forward lại trang Login và gửi lỗi
					req.setAttribute("error", "Sai email hoặc mật khẩu!");
					req.getRequestDispatcher("Login.jsp").forward(req, resp);
				}
			} else if (uri.endsWith("/register")) {
                String fullname = req.getParameter("fullname");
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                String confirm = req.getParameter("confirmPassword");
                
                // Tối ưu: Kiểm tra null/empty
                if (fullname == null || email == null || password == null || confirm == null || 
                    fullname.trim().isEmpty() || email.trim().isEmpty() || password.isEmpty() || confirm.isEmpty()) {
                    
                    req.setAttribute("error", "Vui lòng điền đầy đủ thông tin đăng ký!");
                    req.getRequestDispatcher("Register.jsp").forward(req, resp);
                    return;
                }
                
                fullname = fullname.trim();
                email = email.trim();
				
				// 1. Kiểm tra Mật khẩu khớp
				if (!password.equals(confirm)) {
					req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
					req.getRequestDispatcher("Register.jsp").forward(req, resp);
					return;
				}
				
				// 2. Kiểm tra độ dài mật khẩu tối thiểu (>= 6 KÝ TỰ)
				if (password.length() < 6) {
					req.setAttribute("error", "Mật khẩu quá ngắn, yêu cầu tối thiểu 6 ký tự.");
					req.getRequestDispatcher("Register.jsp").forward(req, resp);
					return;
				}

				// 3. Kiểm tra Email đã tồn tại
				if (dao.findByEmail(email) != null) {
					req.setAttribute("error", "Email đã được sử dụng, vui lòng chọn email khác!");
					req.getRequestDispatcher("Register.jsp").forward(req, resp);
					return;
				}
				
				// 4. Thực hiện Đăng ký
				User u = new User();
				u.setFullname(fullname);
				u.setEmail(email);
                // LƯU Ý BẢO MẬT: Trong thực tế, mật khẩu phải được băm (hash) trước khi lưu.
				u.setPassword(password); 
				u.setRole(ROLE_READER); // Mặc định là độc giả (0)
				
				dao.insert(u);
				
				// 5. Đăng ký thành công, chuyển sang trang đăng nhập
				session.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
				resp.sendRedirect(req.getContextPath() + "/login");
			}
		} catch (SQLException e) {
		e.printStackTrace();
		// Xử lý lỗi SQL cho cả Login và Register
		req.setAttribute("error", "Lỗi cơ sở dữ liệu: Không thể hoàn tất yêu cầu.");
		 String target = uri.endsWith("/login") ? "Login.jsp" : "Register.jsp";
		 req.getRequestDispatcher(target).forward(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Lỗi máy chủ", e);
		}
	}
}