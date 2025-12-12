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
        
               .content-container {
	            display: grid;
	            grid-template-columns: 3fr 1fr;
	            gap: 35px; 
	            max-width: 1200px;
	            margin: 25px auto;
	            padding: 0 20px;
	        }
	
	        /* Khối nội dung chính */
	        .main-content {
	            background: #ffffff;
	            padding: 20px 20px; 
	            border-radius: 10px;
	            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
	            border: 1px solid #e8e8e8;
                padding-right: 35px; 
	        }

	/* CSS DÀNH CHO DANH SÁCH TIN (Giống Index) */
    .news-item {
        display: flex;
        margin-bottom: 30px; 
        padding-bottom: 25px;
        border-bottom: 1px dashed #ddd;
        overflow: hidden; 
    }
    .news-item:last-child {
        border-bottom: none;
    }
    
    .news-item .news-image-list {
        width: 200px;
        height: 120px; 
        object-fit: cover;
        margin-right: 20px; 
        border-radius: 5px;
        flex-shrink: 0; 
    }
    
    .news-item .news-info h3 {
        font-size: 1.25rem; 
        margin-bottom: 8px;
        margin-top: 0;
    }
    .news-item .excerpt {
        color: #555;
        font-size: 0.95rem;
        line-height: 1.4;
        margin-bottom: 8px;
    }
    .news-item .meta {
        font-size: 0.85rem;
        color: #888;
        display: block; 
    }
	.news-item {
        display: flex; 
        margin-bottom: 30px;
        padding-bottom: 25px;
        border-bottom: 1px dashed #ddd;
        overflow: hidden; 
    }
        
</style>

    <meta charset="UTF-8">
    <title><fmt:message key="news.sports"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png" class="header-image">
    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login"><fmt:message key="menu.login"/></a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h2 style="margin-bottom: 25px; font-family:'Playfair Display', serif;">
            <fmt:message key="news.sports"/>
        </h2>

        <c:choose>

            <c:when test="${not empty theThaoList}">
                <c:forEach var="item" items="${theThaoList}">
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
                                | <fmt:message key="news.reporter.sports"/>
                            </p>
                        </div>

                    </article>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <p><fmt:message key="news.no.sports"/></p>
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
