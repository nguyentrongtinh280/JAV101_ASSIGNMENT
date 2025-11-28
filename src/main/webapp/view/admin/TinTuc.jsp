<%-- File: TinTuc.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Tin Tức</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
</head>
<body>
    <link rel="stylesheet" href="css/style.css">
    <jsp:include page="MenuAdmin.jsp" /> 

	<div class="crud-container">
	
	    <h2>
	        <i class="fa fa-newspaper-o"></i> Quản Lý Tin Tức
	    </h2>
	
	    <div class="crud-form">
	        <h3>Thông Tin Bản Tin</h3>
	        <form action="#" method="post">
	            
	            <div class="form-group">
	                <label for="id">Mã bản tin:</label>
	                <input type="text" id="id" name="id"  readonly>
	            </div>
	
	            <div class="form-group">
	                <label for="title">Tiêu đề:</label>
	                <input type="text" id="title" name="title" required >
	            </div>
	
	            <div class="form-group">
	                <label for="categoryid">Loại tin:</label>
	                <select id="categoryid" name="categoryid" required>
	                    <option value="">-- Chọn Loại tin --</option>
	                     <option value="TS">Thời sự</option>
	                    <option value="VH">Văn hóa</option>
	                    <option value="PL">Pháp luật</option>
	                    <option value="TT">Thể thao</option>
	                    <option value="GD">Giáo dục</option>
	                </select>
	            </div>
	            
	            <div class="form-group">
	                <label for="content">Nội dung:</label>
	                <textarea id="content" name="content" rows="6" required ></textarea>
	            </div>
	
	            <div class="form-group">
	                <label for="image">Hình ảnh/Video:</label>
	                <input type="text" id="image" name="image" >
	            </div>
	            
	            <div class="form-group">
	                <label for="home">Trang nhất:</label>
	                <input type="checkbox" id="home" name="home" value="true">
	                <small> (Chọn nếu muốn tin xuất hiện trên trang chủ)</small>
	            </div>
	            
	            <div class="form-actions">
	                <button type="submit" class="btn-save">Lưu</button>
	                <button type="reset" class="btn-new">Mới</button>
	            </div>
	        </form>
	    </div>
	    
	    <div class="crud-table">
	        <h3>Danh Sách Bản Tin</h3>
	        <table>
	            <thead>
	                <tr>
	                    <th>Id</th>
	                    <th>Tiêu đề</th>
	                    <th>Loại tin</th>
	                    <th>Ngày đăng</th>
	                    <th>Tác giả</th>
	                    <th>Lượt xem</th>
	                    <th>Trang nhất</th>
	                    <th>Hành động</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td colspan="8" class="no-data">
	                        Chưa có bản tin nào được thêm vào.
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	    </div>
	
	</div>
</body>
</html>