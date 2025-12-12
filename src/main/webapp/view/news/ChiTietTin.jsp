<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${newsItem.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background-color: #ffffff;
            border-bottom: 1px solid #eeeeee;
            height: 80px;
        }
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
        .main-content {
            background: #ffffff;
            padding: 100px 50px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e8e8e8;
        }
        .main-content h1 {
            font-size: 2rem;
            margin-bottom: 15px;
            color: #222;
        }
        .meta {
            font-size: 0.95rem;
            color: #777;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 12px;
            display: flex;
            align-items: center;
        }
        .detail-image {
            width: 100%;
            max-height: 450px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid #ddd;
        }
        .content {
            font-size: 1.1rem;
            color: #333;
            line-height: 1.8;
            text-align: justify;
            padding-bottom: 30px;
        }
        .view-count-info {
            margin-left: auto;
            font-weight: 600;
            color: #0056b3;
        }
        .view-icon {
            margin-right: 5px;
            font-size: 1.5rem;
            color: #8b4513;
        }
    </style>

</head>

<body>

<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png"
         alt="Logo" class="header-image">

    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login">
            <fmt:message key="detail.login" />
        </a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h1>${newsItem.title}</h1>

        <p class="meta">
            <fmt:message key="detail.postedDate" />:
            <fmt:formatDate value="${newsItem.postedDate}" pattern="dd/MM/yyyy" />
            &nbsp; | &nbsp;
            <fmt:message key="detail.author" />: ${newsItem.author}

            <span class="view-count-info">
                <span class="view-icon">👁️</span>
                ${newsItem.viewCount} <fmt:message key="detail.views" />
            </span>
        </p>

        <img src="${pageContext.request.contextPath}/upload_img/news/${newsItem.image}"
             alt="${newsItem.title}" class="detail-image">

        <div class="content">
            ${newsItem.content}
        </div>

    </section>

    <jsp:include page="/sidebar.jsp" />

</main>

<footer class="footer">
    <p><fmt:message key="detail.footer" /></p>
</footer>

</body>
</html>
