<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Newsletter</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
</head>
<body>

    <jsp:include page="MenuAdmin.jsp" /> 

    <div class="crud-container">
        <h2><i class="fa fa-envelope-open"></i> Quản Lý Đăng Ký Newsletter</h2>

        <div class="crud-form">
            <h3>Thông Tin Đăng Ký</h3>
            
            <!-- Thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
            </c:if>
            
            <!-- Thông báo thành công -->
            <c:if test="${param.success == 'insert'}">
                <div class="alert success">Đăng ký thành công!</div>
            </c:if>
            
            <c:if test="${param.success == 'update'}">
                <div class="alert success">Cập nhật thông tin thành công!</div>
            </c:if>
            
            <c:if test="${param.success == 'delete'}">
                <div class="alert success">Xóa thành công!</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/newsletter" method="post">
                <div class="form-group">
                    <label>Email:</label>
                    <input value="${item.email}" type="email" name="email" >
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="enabled">
                        <option value="true"  ${item.enabled ? "selected" : ""}>Còn hiệu lực</option>
                        <option value="false" ${!item.enabled ? "selected" : ""}>Đã khóa</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/create" class="btn-save">Lưu</button>
                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/update" class="btn-new">Sửa</button>
                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/delete" class="btn-delete">Xóa</button>
                    <button type="submit" formaction="${pageContext.request.contextPath}/newsletter/reset" class="btn-new">Mới</button>
                </div>
            </form>
        </div>
        
        <div class="crud-table">
            <h3>Danh Sách Email Đăng Ký</h3>
            <table>
                <thead>
                    <tr>
                        <th style="width: 40%;">Email nhận tin</th>
                        <th style="width: 20%;">Trạng thái</th>
                        <th style="width: 15%;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="n" items="${list}">
                        <tr>
                            <td>${n.email}</td>
                            <td>${n.enabled ? "Hoạt động" : "Khóa"}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/newsletter/edit/${n.email}">Chọn</a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty list}">
                        <tr>
                            <td colspan="3" class="no-data">Chưa có email nào đăng ký</td>
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
