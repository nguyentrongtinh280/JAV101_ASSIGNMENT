<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,…;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title><fmt:message key="user.manage.title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>   
    <jsp:include page="MenuAdmin.jsp" /> 

    <div class="crud-container">

        <h2><i class="fa fa-users"></i> <fmt:message key="user.manage.title"/></h2>

        <div class="crud-form">
            <h3><fmt:message key="user.info"/></h3>

            <!-- Thông báo lỗi / thành công -->
            <c:if test="${not empty error}">
			    <div class="alert error">${error}</div>
			</c:if>
			
			<c:if test="${param.success == 'insert'}">
			    <div class="alert success">Thêm người dùng thành công!</div>
			</c:if>
			
			<c:if test="${param.success == 'update'}">
			    <div class="alert success">Cập nhật thông tin thành công!</div>
			</c:if>

			            
            <form action="${pageContext.request.contextPath}/nguoi-dung" method="post">

			    <c:if test="${editUser != null}">
			        <input type="hidden" name="action" value="update">
			        <input type="hidden" name="id" value="${editUser.id}">
			    </c:if>
			    <c:if test="${editUser == null}">
			        <input type="hidden" name="action" value="insert">
			    </c:if>
			
			    <div class="form-group two-columns">
			        <div class="form-field-half">
			            <label for="fullname"><fmt:message key="fullname"/></label>
			            <input type="text" id="fullname" name="fullname"
			                   value="${editUser != null ? editUser.fullname : param.fullname}">
			        </div>
			        <div class="form-field-half">
			            <label for="email"><fmt:message key="email"/></label>
			            <input type="email" id="email" name="email"
			                   value="${editUser != null ? editUser.email : param.email}">
			        </div>
			    </div>
			
			    <div class="form-group two-columns">
				    <div class="form-field-half">
				        <label for="password"><fmt:message key="password"/></label>
				        <input type="password" id="password" name="password">
				    </div>
				    
				    <div class="form-field-half">
				        <label for="confirm_password"><fmt:message key="confirm.password"/></label>
				        <input type="password" id="confirm_password" name="confirm_password">
				    </div>
				</div>

			    <div class="form-group two-columns">
			        <div class="form-field-half">
			            <label for="mobile"><fmt:message key="mobile"/></label>
			            <input type="tel" id="mobile" name="mobile" value="${editUser != null ? editUser.mobile : param.mobile}">
			        </div>
				<div class="form-field-half">
			            <label for="birthday"><fmt:message key="birthday"/></label>
			            <input type="date" id="birthday" name="birthday" value="${editUser != null ? editUser.birthday : param.birthday}">
			        </div>
			    </div>
			
			    <div class="form-group two-columns">
			        <div class="form-field-half gender-group">
			            <label><fmt:message key="gender"/></label>
			            <input type="radio" id="gender_male" name="gender" value="0"
			                   ${editUser != null && editUser.gender == 0 ? 'checked' : (param.gender == '0' ? 'checked' : '')}>
			            <label for="gender_male"><fmt:message key="male"/></label>
			
			            <input type="radio" id="gender_female" name="gender" value="1"
			                   ${editUser != null && editUser.gender == 1 ? 'checked' : (param.gender == '1' ? 'checked' : '')}>
			            <label for="gender_female"><fmt:message key="female"/></label>
			        </div>
			
			        <div class="form-field-half">
			            <label for="role"><fmt:message key="role"/></label>
			            <select id="role" name="role">
			                <option value="">
							    <fmt:message key="role.choose"/>
							</option>			                
			                <option value="0" ${editUser != null && editUser.role == 0 ? 'selected' : (param.role == '0' ? 'selected' : '')}> <fmt:message key="role.user"/></option>
			                <option value="1" ${editUser != null && editUser.role == 1 ? 'selected' : (param.role == '1' ? 'selected' : '')}><fmt:message key="role.admin"/></option>
			            </select>
			        </div>
			    </div>
			
			    <div class="form-actions" style="margin-top:20px;">
				    <button type="submit" class="btn-save">
					    <c:choose>
					        <c:when test="${editUser != null}">
					            <fmt:message key="update"/>
					        </c:when>
					        <c:otherwise>
					            <fmt:message key="save"/>
					        </c:otherwise>
					    </c:choose>
					</button>

				    <button type="button" class="btn-new" onclick="window.location.href='${pageContext.request.contextPath}/nguoi-dung'"> <fmt:message key="new"/></button>
				</div>

			</form>

        </div>

        <div class="crud-table user-table">
            <h3><fmt:message key="user.list"/></h3>

            <table>
                <thead>
                    <tr>
                        <th><fmt:message key="id"/></th>
                        <th><fmt:message key="fullname"/></th>
                        <th><fmt:message key="birthday"/></th>
                        <th><fmt:message key="gender"/></th>
                        <th><fmt:message key="email"/></th>
                        <th><fmt:message key="role"/></th>
                        <th><fmt:message key="action"/></th>
                    </tr>
                </thead>
                <tbody>

                    <c:choose>
                        <c:when test="${not empty listUser}">
                            <c:forEach var="u" items="${listUser}">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${u.fullname}</td>
                                    <td>${u.birthday}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.gender == 0}">
                                                <fmt:message key="male"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="female"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>${u.email}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 0}">
                                                <fmt:message key="role.user"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message key="role.admin"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <a href="${pageContext.request.contextPath}/nguoi-dung?action=edit&id=${u.id}">
                                            <fmt:message key="edit"/>
                                        </a> |
                                        <a href="${pageContext.request.contextPath}/nguoi-dung?action=delete&id=${u.id}"
                                           onclick="return confirm('<fmt:message key="delete.confirm"/>');">
                                            <fmt:message key="delete"/>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="7"><fmt:message key="nodata"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>

                </tbody>
            </table>
        </div>

    <style>
        .alert { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .alert.error { background: #ffb3b3; color: #a10000; }
        .alert.success { background: #b3ffcc; color: #007a1a; }
    </style>
    
    <script>
	    window.addEventListener("load", function() {
	        var alerts = document.querySelectorAll(".alert");
	        alerts.forEach(function(alertBox) {
	            setTimeout(function() {
	                alertBox.style.display = "none";
	            }, 3000); 
	        });
	    });
	</script>
    

</body>
</html>
