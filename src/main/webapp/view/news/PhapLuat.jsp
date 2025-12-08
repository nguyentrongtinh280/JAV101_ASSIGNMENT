<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<style>
/* CSS CHUNG CHO HEADER (Giống trang index) */
        .header {
            display: flex; 
            justify-content: space-between;
            align-items: center; 
            padding: 15px 30px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #eeeeee; 
            height: 80px; 
        }
        
        /* Điều chỉnh kích thước Logo */
        .header-image {
            height: 60px; 
            width: auto; 
        }
</style>
    <meta charset="UTF-8">
    <title>Tin Pháp Luật</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png" class="header-image">
    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h2 style="margin-bottom: 25px; font-family:'Playfair Display', serif;">
            Tin Pháp Luật
        </h2>

        <c:choose>

            <c:when test="${not empty phapLuatList}">
                <c:forEach var="item" items="${phapLuatList}">
                    <article class="news-list-item">

                        <img src="${pageContext.request.contextPath}/upload_img/news/${item.image}"
                             class="news-image-list">

                        <div class="news-info">

                            <h3><a href="chi-tiet-tin?id=${item.id}">${item.title}</a></h3>

                            <p class="excerpt">
                                ${fn:substring(item.content, 0, 150)}...
                            </p>

                            <p class="meta">
                                <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy" />
                                | PV Pháp Luật
                            </p>
                        </div>

                    </article>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <p>Hiện chưa có tin pháp luật nào.</p>
            </c:otherwise>

        </c:choose>

    </section>

    <jsp:include page="/sidebar.jsp" />

</main>

<footer class="footer">
    <p>Góc Nhìn Báo Chí</p>
</footer>

</body>
</html>
