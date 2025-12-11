<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
	<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
	<meta charset="UTF-8">
	<title><fmt:message key="newsletter.title" /></title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
</head>
<body>

    <jsp:include page="MenuAdmin.jsp" /> 

    <div class="crud-container">

        <h2><i class="fa fa-envelope-open"></i> 
            <fmt:message key="newsletter.manage" />
        </h2>

        <div class="crud-form">
            <h3><fmt:message key="newsletter.info" /></h3>
            
            <!-- Thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
            </c:if>

            <!-- Thông báo thành công -->
            <c:if test="${param.success == 'insert'}">
                <div class="alert success">
                    <fmt:message key="newsletter.success.insert" />
                </div>
            </c:if>
            <c:if test="${param.success == 'update'}">
                <div class="alert success">
                    <fmt:message key="newsletter.success.update" />
                </div>
            </c:if>
            <c:if test="${param.success == 'delete'}">
                <div class="alert success">
                    <fmt:message key="newsletter.success.delete" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/newsletter" method="post">
                <div class="form-group">
                    <label><fmt:message key="newsletter.email" />:</label>
                    <input value="${item.email}" type="email" name="email" >
                </div>

                <div class="form-group">
                    <label><fmt:message key="newsletter.status" />:</label>
                    <select name="enabled">
                        <option value="true"  ${item.enabled ? "selected" : ""}>
                            <fmt:message key="newsletter.enabled" />
                        </option>
                        <option value="false" ${!item.enabled ? "selected" : ""}>
                            <fmt:message key="newsletter.disabled" />
                        </option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/create" class="btn-save">
                        <fmt:message key="newsletter.save" />
                    </button>

                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/update" class="btn-new">
                        <fmt:message key="newsletter.update" />
                    </button>

                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/delete" class="btn-delete">
                        <fmt:message key="newsletter.delete" />
                    </button>

                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/reset" class="btn-new">
                        <fmt:message key="newsletter.reset" />
                    </button>
                </div>
            </form>
        </div>

        <div class="crud-table">
            <h3><fmt:message key="newsletter.list" /></h3>

            <table>
                <thead>
                    <tr>
                        <th style="width: 40%;">
                            <fmt:message key="newsletter.email.receive" />
                        </th>

                        <th style="width: 20%;">
                            <fmt:message key="newsletter.status" />
                        </th>

                        <th style="width: 15%;">
                            <fmt:message key="newsletter.action" />
                        </th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="n" items="${list}">
                        <tr>
                            <td>${n.email}</td>
                            <td>
							    <c:choose>
							        <c:when test="${n.enabled}">
							            <fmt:message key="newsletter.active" />
							        </c:when>
							        <c:otherwise>
							            <fmt:message key="newsletter.block" />
							        </c:otherwise>
							    </c:choose>
							</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/newsletter/edit/${n.email}">
                                    <fmt:message key="newsletter.select" />
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty list}">
                        <tr>
                            <td colspan="3" class="no-data">
                                <fmt:message key="newsletter.nodata" />
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>
    
    <script>
        window.addEventListener("load", function() {
            var boxes = document.querySelectorAll(".alert");
            boxes.forEach(function(box) {
                setTimeout(() => box.style.display = "none", 3000);
            });
        });
    </script>
    
    <style>
        .alert { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .alert.error { background: #ffb3b3; color: #a10000; }
        .alert.success { background: #b3ffcc; color: #007a1a; }
    </style>
    
</body>
</html>
