<%-- File: NguoiDung.jsp (Đã sửa) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Người Dùng</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
</head>
<body>
    <link rel="stylesheet" href="css/style.css">
	<jsp:include page="MenuAdmin.jsp" /> 
	
	<div class="crud-container">
	
	    <h2 >
	        <i class="fa fa-users"></i> Quản Lý Người Dùng
	    </h2>
	
	    <div class="crud-form">
	        <h3>Thông Tin Người Dùng</h3>
	        <form action="#" method="post">
	            
	            <div class="form-group two-columns">
	                <div class="form-field-half">
	                    <label for="id">Mã đăng nhập:</label>
	                    <input type="text" id="id" name="id"  required>
	                </div>
	                <div class="form-field-half">
	                    <label for="password">Mật khẩu:</label>
	                    <input type="password" id="password" name="password"  required>
	                </div>
	            </div>
	
	            <div class="form-group two-columns">
	                <div class="form-field-half">
	                    <label for="fullname">Họ và tên:</label>
	                    <input type="text" id="fullname" name="fullname" required >
	                </div>
	                <div class="form-field-half">
	                    <label for="confirm_password">Xác nhận mật khẩu:</label>
	                    <input type="password" id="confirm_password" name="confirm_password"  required>
	                </div>
	            </div>
	            
	            <div class="form-group two-columns">
	                <div class="form-field-half">
	                    <label for="email">Email:</label>
	                    <input type="email" id="email" name="email" required>
	                </div>
	                 <div class="form-field-half">
	                    <label for="mobile">Điện thoại (Mobile):</label>
	                    <input type="tel" id="mobile" name="mobile">
	                </div>
	            </div>
	
	            <div class="form-group two-columns">
	                <div class="form-field-half">
	                    <label for="birthday">Ngày sinh:</label>
	                    <input type="date" id="birthday" name="birthday">
	                </div>
	                <div class="form-field-half gender-group"> 
	                     <label for="gender">Giới tính:</label>
	                     <input type="radio" id="gender_male" name="gender" value="false"> <label for="gender_male" style="display: inline; font-weight: normal; margin-right: 15px;">Nam</label>
	                     <input type="radio" id="gender_female" name="gender" value="true"> <label for="gender_female" style="display: inline; font-weight: normal;">Nữ</label>
	                </div>
	            </div>
	
	            <div class="form-group">
	                <label for="role">Vai trò:</label>
	                <select id="role" name="role" required>
	                	<option value="">-- Chọn vai trò --</option>
	                    <option value="false">Phóng viên</option>
	                    <option value="true">Quản trị viên</option>
	                </select>
	            </div>
	            
	            <div class="form-actions" style="margin-top: 20px;">
	                <button type="submit" class="btn-save">Lưu</button>
	                <button type="reset" class="btn-new">Mới</button>
	            </div>
	        </form>
	    </div>
	    
	    <div class="crud-table user-table">
	        <h3>Danh Sách Người Dùng</h3>
	        <table>
	            <thead>
	                <tr>
	                    <th>Id</th>
	                    <th>Họ và tên</th>
	                    <th>Ngày sinh</th>
	                    <th>Giới tính</th>
	                    <th>Email</th>
	                    <th>Vai trò</th>
	                    <th>Hành động</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td colspan="7" class="no-data">
	                        Chưa có người dùng nào được thêm vào.
	                    </td>
	                </tr>
	                
	                </tbody>
	        </table>
	    </div>
	
	</div>
</body>
</html>