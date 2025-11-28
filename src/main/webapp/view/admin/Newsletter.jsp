<%-- File: Newsletter.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Newsletter</title>
    <link rel="stylesheet" href="css/style.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
</head>
<body>
    <jsp:include page="MenuAdmin.jsp" /> 

	<div class="crud-container">
	
	    <h2 >
	        <i class="fa fa-envelope-open"></i> Quản Lý Đăng Ký Newsletter
	    </h2>
	
	    <div class="crud-form">
	        <h3>Thông Tin Đăng Ký</h3>
	        <form action="#" method="post">
	            
	            <div class="form-group">
	                <label for="email">Email:</label>
	                <input type="email" id="email" name="email" required >
	            </div>
	
	            <div class="form-group">
	                <label for="enabled">Trạng thái:</label>
	                <select id="enabled" name="enabled" required>
	                    <option value="true">Còn hiệu lực</option>
	                    <option value="false">Đã hủy/Khóa</option>
	                </select>
	            </div>
	            
	            <div class="form-actions">
	                <button type="submit" class="btn-save">Lưu</button>
	                <button type="reset" class="btn-new">Mới</button>
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
	                <tr>
	                    <td colspan="3" class="no-data">
	                        Chưa có email nào đăng ký.
	                    </td>
	                </tr>
	                
	                </tbody>
	        </table>
	    </div>
	
	</div>
</body>
</html>