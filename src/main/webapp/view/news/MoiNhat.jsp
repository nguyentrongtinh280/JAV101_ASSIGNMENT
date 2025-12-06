<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tin Mới Nhất</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png" 
         alt="Logo ABC News" class="header-image">

    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h2 style="margin-bottom: 25px; font-family:'Playfair Display', serif;">
            Tin Mới Nhất
        </h2>

        <c:choose>

            <c:when test="${not empty listMoiNhat}">
                <c:forEach var="item" items="${listMoiNhat}">

                    <article class="news-list-item">

                        <img src="${pageContext.request.contextPath}/upload_img/news/${item.image}"
                             alt="${item.title}"
                             class="news-image-list">

                        <div class="news-info">
                            <h3>
                                <a href="chi-tiet-tin?id=${item.id}">
                                    ${item.title}
                                </a>
                            </h3>

                            <p class="excerpt">
                                ${fn:substring(item.content, 0, 150)}...
                            </p>

                            <p class="meta">
                                <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
                                | Tác giả: ${item.author}
                            </p>
                        </div>

                    </article>

                </c:forEach>
            </c:when>

            <c:otherwise>
                <p>Hiện chưa có tin mới nhất.</p>
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
