<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         trimDirectiveWhitespaces="true" %>

<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><fmt:message key="news.latest"/></title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
.content-container{
    display:grid;
    grid-template-columns:3fr 1fr;
    gap:35px;
    max-width:1200px;
    margin:25px auto;
    padding:0 20px
}
.main-content{
    background:#fff;
    padding:25px;
    border-radius:10px;
    box-shadow:0 4px 15px rgba(0,0,0,.08)
}
.news-item{
    display:flex;
    margin-bottom:30px;
    padding-bottom:25px;
    border-bottom:1px dashed #ddd
}
.news-image-list{
    width:200px;
    height:120px;
    object-fit:cover;
    margin-right:20px;
    border-radius:5px
}
.news-info h3{margin:0 0 8px}
.excerpt{color:#555}
.meta{font-size:.85rem;color:#888}
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

<h2><fmt:message key="news.latest"/></h2>

<c:choose><c:when test="${not empty listMoiNhat}">
<c:forEach var="item" items="${listMoiNhat}">
<article class="news-item">

<img src="${pageContext.request.contextPath}/upload_img/news/${item.image}"
     alt="${item.title}"
     class="news-image-list">

<div class="news-info">
<h3>
<a href="${pageContext.request.contextPath}/chi-tiet-tin?id=${item.id}">
${item.title}
</a>
</h3>

<p class="excerpt">
${fn:substring(item.content,0,150)}...
</p>

<p class="meta">
<fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
 | <fmt:message key="news.author"/>: ${item.author}
</p>
</div>

</article>
</c:forEach>
</c:when><c:otherwise>
<p><fmt:message key="news.no.latest"/></p>
</c:otherwise></c:choose>

</section>

<jsp:include page="/sidebar.jsp"/>
</main>

<footer class="footer">
<p><fmt:message key="footer.text"/></p>
</footer>

</body>
</html>
