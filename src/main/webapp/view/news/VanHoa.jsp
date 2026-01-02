<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         trimDirectiveWhitespaces="true" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> >

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tin Văn Hóa</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
body { margin:0; font-family:Arial,sans-serif; background:#f3f4f6; }
.content-container {
    display:grid; grid-template-columns:3fr 1fr; gap:35px;
    max-width:1200px; margin:25px auto; padding:0 20px;
}
.main-content {
    background:#fff; padding:20px 35px 20px 20px;
    border-radius:10px; border:1px solid #e8e8e8;
    box-shadow:0 4px 15px rgba(0,0,0,.08);
}
.news-item {
    display:flex; gap:20px; margin-bottom:30px;
    padding-bottom:25px; border-bottom:1px dashed #ddd;
}
.news-image-list {
    width:200px; height:120px; object-fit:cover; border-radius:5px;
}
.news-info h3 { margin:0 0 8px; font-size:1.25rem; }
.excerpt { font-size:.95rem; color:#555; }
.meta { font-size:.85rem; color:#888; }
</style>
</head>

<body>

	<header class="header">
	    <img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo" class="header-image">
	
	    <div class="header-login">
	        <c:choose>
	            <c:when test="${not empty sessionScope.loggedInUser}">
	                <fmt:message key="home.hello"/> 
	                <strong>${sessionScope.loggedInUser.fullname}</strong>
	                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2">
	                    <fmt:message key="home.logout"/>
	                </a>
	            </c:when>
	            <c:otherwise>
	                <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary">
	                    <fmt:message key="home.login"/>
	                </a>
	            </c:otherwise>
	        </c:choose>
	    </div>
	</header>

<jsp:include page="/menu.jsp"/>

<main class="content-container">
<section class="main-content">

<h2><fmt:message key="vanhoa"/></h2>

<c:choose><c:when test="${not empty vanHoaList}">
<c:forEach var="item" items="${vanHoaList}">
<article class="news-item">
<img class="news-image-list"
     src="${pageContext.request.contextPath}/upload_img/news/${item.image}">
<div class="news-info">
<h3><a href="chi-tiet-tin?id=${item.id}">${item.title}</a></h3>
<p class="excerpt">${fn:substring(item.content,0,150)}...</p>
<p class="meta">
<fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
 | <fmt:message key="vanhoa.reporter"/>
</p>
</div>
</article>
</c:forEach>
</c:when><c:otherwise>
<p><fmt:message key="vanhoa.empty"/></p>
</c:otherwise></c:choose>

</section>
<jsp:include page="/sidebar.jsp"/>
</main>

<footer class="footer">
<p><fmt:message key="footer.text"/></p>
</footer>

</body>
</html>
