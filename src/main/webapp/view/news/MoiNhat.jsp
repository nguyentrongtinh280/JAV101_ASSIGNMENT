<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- BẮT BUỘC: Thư viện JSTL core --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- BẮT BUỘC: Thư viện JSTL format (dùng cho ngày tháng) --%>
<!DOCTYPE html>
<html>
<head>
<style>
   /* 1. Căn chỉnh Header (Sử dụng Flexbox) */
        .header {
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 15px 30px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #eeeeee; 
            height: 80px; 
        }

        /* 2. Điều chỉnh kích thước Logo cho VỪA PHẢI */
        .header-image {
            height: 60px; /* Chiều cao tối đa vừa phải */
            width: auto; /* Giữ tỷ lệ khung hình */
        }
        
        /* Bổ sung CSS quan trọng cho danh sách tin */
        .news-list-item {
            display: flex;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .news-image-list {
            width: 200px; 
            height: 120px;
            object-fit: cover;
            margin-right: 20px;
        }
        .news-info h3 {
            font-size: 1.3rem;
            margin-top: 0;
        }
        .news-info .excerpt {
            color: #555;
            font-size: 0.95rem;
            margin-bottom: 5px;
        }
        .news-info .meta {
            font-size: 0.85rem;
            color: #888;
        }
        
</style>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Tin Mới Nhất</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <%-- Sửa đường dẫn tuyệt đối --%>
</head>

<body>

	<header class="header">
		<img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo ABC News" class="header-image">
	    <div class="header-login">
	            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
	        </div>
	</header>
	
	<jsp:include page="/menu.jsp" />
	
	<main class="content-container">
	    <section class="main-content">
			<h2>TIN TỨC MỚI NHẤT</h2>
			
			<%-- 🔥 Vòng lặp JSTL để hiển thị DỮ LIỆU ĐỘNG từ DB 🔥 --%>
			<c:choose>
	            <c:when test="${not empty requestScope.latestNewsList}"> 
	                <c:forEach var="item" items="${requestScope.latestNewsList}">
	                    <article class="news-list-item">
                            <%-- Đường dẫn ảnh động từ cột Image (ví dụ: hinh1.png) --%>
	                        <img src="${pageContext.request.contextPath}/img/${item.image}" class="news-image-list" alt="${item.title}">
	                        <div class="news-info">
	                            <%-- Liên kết đến trang chi tiết với ID động --%>
	                            <h3><a href="${pageContext.request.contextPath}/detail?id=${item.id}">${item.title}</a></h3>
	                            <p class="excerpt">
                                    <%-- Hiển thị nội dung tóm tắt (dài 150 ký tự) --%>
                                    <c:set var="contentExcerpt" value="${item.content.length() > 150 ? item.content.substring(0, 150) : item.content}"/>
                                    ${contentExcerpt} ...
                                </p>
	                            <p class="meta">
                                    <%-- Định dạng ngày đăng --%>
                                    <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/> | Phóng viên ${item.author}
                                </p>
	                        </div>
	                    </article>
	                </c:forEach>
	            </c:when>
	            <c:otherwise>
	                <p style="padding: 20px;">Hiện tại không có tin tức nào để hiển thị.</p>
	            </c:otherwise>
	        </c:choose>
			<%-- 🔥 KẾT THÚC Vòng lặp JSTL 🔥 --%>
	
	    </section>
	
	    <jsp:include page="/sidebar.jsp" />
	
	</main>
	
	<footer class="footer">
	        <p>Góc Nhìn Báo Chí</p>
    </footer>

</body>
</html>