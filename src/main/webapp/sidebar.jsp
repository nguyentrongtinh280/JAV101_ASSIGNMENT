<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="DAO.NewsDAO" %>
<%@ page import="Entity.News" %>

<aside class="sidebar-content">

    <%-- =========================================== --%>
    <%-- 1. 5 BẢN TIN ĐƯỢC XEM NHIỀU --%>
    <%-- =========================================== --%>
	<div class="widget hot-news most-viewed-box">
		<h3>5 BẢN TIN ĐƯỢC XEM NHIỀU</h3>
		<ol class="most-viewed-list">
			<%
			NewsDAO newsDAO = new NewsDAO();
			List<News> hotNewsList = newsDAO.getTopViewedNews(5);
			int rank = 1;
			for (News news : hotNewsList) {
			%>
			<li><span class="rank-number"><%=rank%></span> <a
				href="chi-tiet-tin?id=<%=news.getId()%>"><%=news.getTitle()%></a></li>
			<%
			rank++;
			}
			%>
		</ol>
	</div>

	<%-- =========================================== --%>
    <%-- 2. 5 BẢN TIN MỚI NHẤT --%>
    <%-- =========================================== --%>
    <div class="widget new-news">
        <h3>5 BẢN TIN MỚI NHẤT</h3>
        <ol class="most-viewed-list">
            <%
                List<News> latestNews = newsDAO.getLatestNews(5);
                rank = 1;
                for (News news : latestNews) {
            %>
            <li>
                <span class="rank-number"><%=rank%></span>
                <a href="chi-tiet-tin?id=<%=news.getId()%>"><%=news.getTitle()%></a>
            </li>
            <%
                    rank++;
                }
            %>
        </ol>
    </div>

    <%-- =========================================== --%>
    <%-- 3. 5 BẢN TIN ĐÃ XEM --%>
    <%-- =========================================== --%>
    <div class="widget viewed-news">
        <h3>5 BẢN TIN BẠN ĐÃ XEM</h3>
        <ol class="most-viewed-list">
            <%
                List<Integer> viewedIds = (List<Integer>) session.getAttribute("viewed");
                if (viewedIds != null) {
                    rank = 1;
                    for (int id : viewedIds) {
                        if (rank > 5) break; // chỉ 5 tin
                        News news = newsDAO.getNewsById(id);
                        if (news != null) {
            %>
            <li>
                <span class="rank-number"><%=rank%></span>
                <a href="chi-tiet-tin?id=<%=news.getId()%>"><%=news.getTitle()%></a>
            </li>
            <%
                            rank++;
                        }
                    }
                }
            %>
        </ol>
    </div>

    <%-- =========================================== --%>
    <%-- 4. ĐĂNG KÝ NEWSLETTER --%>
    <%-- =========================================== --%>
    <div class="widget newsletter">
        <h3>Đăng Ký Newsletter</h3>
        <p>Nhập email để nhận tin mới nhất từ Góc Nhìn Báo Chí.</p>
        <form action="${pageContext.request.contextPath}/newsletter-register" method="POST" class="newsletter-form">
            <input type="email" name="email" placeholder="Email nhận bản tin" required class="form-control">
            <button type="submit" class="btn btn-danger btn-sm w-100 mt-2">Đăng ký</button>
        </form>
    </div>

</aside>
