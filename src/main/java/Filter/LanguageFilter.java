package Filter;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class LanguageFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        String lang = req.getParameter("lang");

        if (lang != null) {
            session.setAttribute("lang", lang);
        }

        // Nếu chưa có ngôn ngữ → mặc định tiếng Việt
        if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "vi_VN");
        }

        chain.doFilter(request, response);
    }
}
