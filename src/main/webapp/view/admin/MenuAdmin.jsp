<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<nav class="main-nav">
    <ul>
        <li>
            <a href="${pageContext.request.contextPath}/admin">
                <fmt:message key="menu.admin.home" />
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/tin-tuc">
                <fmt:message key="menu.admin.news" />
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/loai-tin">
                <fmt:message key="menu.admin.category" />
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/nguoi-dung">
                <fmt:message key="menu.admin.user" />
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/newsletter">
                <fmt:message key="menu.admin.newsletter" />
            </a>
        </li>
        
        <li><a href="?lang=vi_VN">🌐 <fmt:message key="menu.langVI"/></a></li>
        <li><a href="?lang=en_US">🌐 <fmt:message key="menu.langEN"/></a></li>
    </ul>
</nav>
