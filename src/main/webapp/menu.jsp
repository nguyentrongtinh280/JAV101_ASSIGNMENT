<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Lưu ngôn ngữ vào session nếu người dùng chọn -->
<c:if test="${not empty param.lang}">
    <c:set var="lang" value="${param.lang}" scope="session"/>
</c:if>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<nav class="main-nav">
    <ul>
        <li><a href="${pageContext.request.contextPath}"><fmt:message key="menu.home"/></a></li>
        <li><a href="${pageContext.request.contextPath}/moi-nhat"><fmt:message key="menu.news"/></a></li>
        <li><a href="${pageContext.request.contextPath}/thoi-su"><fmt:message key="menu.politics"/></a></li>
        <li><a href="${pageContext.request.contextPath}/van-hoa"><fmt:message key="menu.culture"/></a></li>
        <li><a href="${pageContext.request.contextPath}/phap-luat"><fmt:message key="menu.law"/></a></li>
        <li><a href="${pageContext.request.contextPath}/the-thao"><fmt:message key="menu.sport"/></a></li>
        <li><a href="${pageContext.request.contextPath}/giao-duc"><fmt:message key="menu.education"/></a></li>

        <li><a href="?lang=vi_VN">🌐 <fmt:message key="menu.langVI"/></a></li>
        <li><a href="?lang=en_US">🌐 <fmt:message key="menu.langEN"/></a></li>
    </ul>
</nav>
