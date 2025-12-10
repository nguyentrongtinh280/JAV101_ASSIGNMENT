<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<%@ page import="java.util.List" %>
<%@ page import="DAO.NewsDAO" %>
<%@ page import="Entity.News" %>

<aside class="sidebar-content">

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

   <div class="widget newsletter">
    <h3>Đăng Ký Newsletter</h3>
    <p>Nhập email để nhận tin mới nhất từ Góc Nhìn Báo Chí.</p>
    <form id="newsletter-form" action="${pageContext.request.contextPath}" method="POST" class="newsletter-form">
        <input type="email" name="email" placeholder="Email nhận bản tin" required class="form-control" id="newsletter-email">
        <button type="submit" class="btn btn-danger btn-sm w-100 mt-2">Đăng ký</button>
        <div id="newsletter-message" class="mt-2" style="display: none;"></div>
    </form>
</div>

</aside>
