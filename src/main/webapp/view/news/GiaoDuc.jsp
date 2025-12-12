<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />
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
<<<<<<< Updated upstream
    <title>Tin Giáo Dục</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
=======
    <title><fmt:message key="menu.education1"/></title>
    </head>
>>>>>>> Stashed changes

<body>

<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo ABC News" class="header-image">

    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login"><fmt:message key="menu.login"/></a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h2 style="margin-bottom: 25px; font-family:'Playfair Display', serif;">
            <fmt:message key="menu.education1"/>
        </h2>

        <c:choose>

            <c:when test="${not empty giaoDucList}">
                <c:forEach var="item" items="${giaoDucList}">
                    <article class="news-list-item">

                        <img src="${pageContext.request.contextPath}/upload_img/news/${item.image}"
                             class="news-image-list" alt="${item.title}">

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
                                <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy" />
                                | <fmt:message key="news.education.reporter"/>
                            </p>
                        </div>

                    </article>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <p><fmt:message key="news.no.education"/></p>
            </c:otherwise>

        </c:choose>

    </section>

    <jsp:include page="/sidebar.jsp" />

</main>

	<footer class="footer">
	    <p><fmt:message key="footer.text"/></p>
	</footer>

</body>
</html>
