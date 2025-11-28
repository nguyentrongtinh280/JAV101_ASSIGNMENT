<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


	<!DOCTYPE html>
	<html>
	<head>
	<style>
	   /* 1. Căn chỉnh Header (Sử dụng Flexbox) */
        .header {
            display: flex; 
            justify-content: space-between; /* Đẩy logo và nút đăng nhập ra hai bên */
            align-items: center; /* Căn giữa theo chiều dọc - GIÚP HÌNH THẲNG HÀNG */
            padding: 15px 30px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #eeeeee; 
            height: 80px; /* Chiều cao cố định cho header */
        }

        /* 2. Điều chỉnh kích thước Logo cho VỪA PHẢI */
        .header-image {
            height: 120px; /* Chiều cao tối đa vừa phải */
            width: 150px; /* Giữ tỷ lệ khung hình */
        }
        
	</style>
	<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
	    <meta charset="UTF-8">
	    <title>Danh sách tin tức</title>
	    <link rel="stylesheet" href="css/style.css">
	</head>

<body>

<header class="header">
	<img src="img/lgo.png" alt="Logo ABC News" class="header-image">
    
</header>

<jsp:include page="menu.jsp" />

<main class="content-container">
    <section class="main-content">

        <c:set var="categoryId" value="${param.id}" />

        <c:choose>
        	<c:when test="${categoryId == 'MN'}">
                <c:set var="categoryName" value="Mới nhất" />
                <c:set var="includePage" value="news/news-moiNhat.jsp" />
            </c:when>
        	
            <c:when test="${categoryId == 'TS'}">
                <c:set var="categoryName" value="Thời sự" />
                <c:set var="includePage" value="news/news-thoiSu.jsp" />
            </c:when>

            <c:when test="${categoryId == 'VH'}">
                <c:set var="categoryName" value="Văn hóa" />
                <c:set var="includePage" value="news/news-vanHoa.jsp" />
            </c:when>

            <c:when test="${categoryId == 'PL'}">
                <c:set var="categoryName" value="Pháp luật" />
                <c:set var="includePage" value="news/news-phapLuat.jsp" />
            </c:when>

            <c:when test="${categoryId == 'TT'}">
                <c:set var="categoryName" value="Thể thao" />
                <c:set var="includePage" value="news/news-theThao.jsp" />
            </c:when>

            <c:when test="${categoryId == 'GD'}">
                <c:set var="categoryName" value="Giáo dục" />
                <c:set var="includePage" value="news/news-giaoDuc.jsp" />
            </c:when>

            <c:otherwise>
                <c:set var="categoryName" value="Danh mục khác (${categoryId})" />
                <c:set var="includePage" value="news/news-other.jsp" />
            </c:otherwise>
        </c:choose>

        <h2>Tin Tức Thuộc Mục: ${categoryName}</h2>

        <jsp:include page="${includePage}" />

    </section>

    <jsp:include page="sidebar.jsp" />

</main>

<footer class="footer">
    <p>Góc Nhìn Báo Chí</p>
</footer>

</body>
</html>
