<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
	<link
		href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap"
		rel="stylesheet">
	<meta charset="UTF-8">
	<title><fmt:message key="menu.category"/></title>
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/StyleAdmin.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/style.css">
	<style>
	.msg-error,
	.msg-success {
		padding: 10px 14px;
		border-radius: 6px;
		font-size: 0.9em;
		margin-top: 6px;
		display: block;
		color: #fff;
		font-weight: 500;
		letter-spacing: 0.3px;
		box-shadow: 0 2px 6px rgba(0,0,0,0.15);
	}
	
	.msg-error {
		background: linear-gradient(135deg, #ff4b4b, #d90000);
	}
	
	.msg-success {
		background: linear-gradient(135deg, #2ecc71, #1e9e55);
	}
	</style>
</head>
<body>
	<jsp:include page="MenuAdmin.jsp"></jsp:include>

	<div class="crud-container">

        <h2><i class="fa fa-tag"></i> <fmt:message key="menu.category"/></h2>

        <div class="crud-form">
            <h3><fmt:message key="category.info"/></h3>

            <form action="${pageContext.request.contextPath}/loai-tin" method="post">

                <c:if test="${editCategory != null}">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${editCategory.id}">
                </c:if>

                <c:if test="${editCategory == null}">
                    <input type="hidden" name="action" value="insert">
                </c:if>

                <div class="form-group">
                    <label for="name"><fmt:message key="category.name"/>:</label>
                    <input type="text" id="name" name="name"
                           value="${editCategory != null ? editCategory.name : param.name}">

                    <c:if test="${not empty error}">
                        <span class="msg-error">${error}</span>
                    </c:if>

                    <c:if test="${param.success == 'insert'}">
                        <span class="msg-success"><fmt:message key="category.add.success"/></span>
                    </c:if>

                    <c:if test="${param.success == 'update'}">
                        <span class="msg-success"><fmt:message key="category.update.success"/></span>
                    </c:if>
                </div>

                <div class="form-actions" style="margin-top: 20px;">
                    <button type="submit" class="btn-save">
                        <c:choose>
                            <c:when test="${editCategory != null}">
                                <fmt:message key="btn.update"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message key="btn.save"/>
                            </c:otherwise>
                        </c:choose>
                    </button>

                    <button type="button" class="btn-new"
                            onclick="window.location.href='${pageContext.request.contextPath}/loai-tin'">
                        <fmt:message key="btn.new"/>
                    </button>
                </div>
            </form>
        </div>

        <div class="crud-table">
            <h3><fmt:message key="category.list"/></h3>

            <table>
                <thead>
                    <tr>
                        <th><fmt:message key="category.id"/></th>
                        <th><fmt:message key="category.name"/></th>
                        <th><fmt:message key="category.action"/></th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>
                        <c:when test="${not empty listCategory}">
                            <c:forEach var="ct" items="${listCategory}">
                                <tr>
                                    <td>${ct.id}</td>
                                    <td>${ct.name}</td>

                                    <td>
                                        <a href="${pageContext.request.contextPath}/loai-tin?action=edit&id=${ct.id}"
                                           class="btn-edit">
                                           <fmt:message key="category.edit"/>
                                        </a>
                                        |
                                        <a href="${pageContext.request.contextPath}/loai-tin?action=delete&id=${ct.id}"
                                           class="btn-delete"
                                           onclick="return confirm('<fmt:message key="category.delete.confirm"/>');">
                                           <fmt:message key="category.delete"/>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="3" class="no-data">
                                    <fmt:message key="category.no.data"/>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
    
</body>
</html>