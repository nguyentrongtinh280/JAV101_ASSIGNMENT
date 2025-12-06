<%-- File: TinTuc.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Tin Tức</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> 
</head>
<body>
	<link rel="stylesheet" href="css/style.css">
    <jsp:include page="MenuAdmin.jsp" /> 

	<div class="crud-container">
	    <h2><i class="fa fa-newspaper-o"></i> Quản Lý Tin Tức</h2>
	    
	    <!-- Flash message -->
	    <c:if test="${not empty message}">
	        <div class="alert success" style="font-weight: bold;">${message}</div>
	    </c:if>

	    <c:if test="${not empty error}">
	        <div class="alert error" style="font-weight: bold;">${error}</div>
	    </c:if>

	    <div class="crud-form">
	        <h3>Thông Tin Bản Tin</h3>

	        <!-- FORM MULTIPART -->
	        <form action="${pageContext.request.contextPath}/tin-tuc" 
	              method="post" id="newsForm" enctype="multipart/form-data">

	            <div class="form-group">
	                <label for="id">Mã bản tin:</label>
	                <input type="text" id="id" name="id" readonly>
	            </div>

	            <div class="form-group">
	                <label for="title">Tiêu đề:</label>
	                <input type="text" id="title" name="title" required>
	            </div>

	            <div class="form-group">
	                <label for="categoryid">Loại tin:</label>
	                <select id="categoryid" name="categoryid" required>
	                    <option value="">-- Chọn Loại tin --</option>
	                    <option value="1">Thời sự</option>
	                    <option value="2">Văn hóa</option>
	                    <option value="3">Pháp luật</option>
	                    <option value="4">Thể thao</option>
	                    <option value="7">Giáo dục</option>
	                </select>
	            </div>

	            <div class="form-group">
	                <label for="content">Nội dung:</label>
	                <textarea id="content" name="content" rows="6" required></textarea>
	            </div>

	            <div class="form-group">
	                <label for="author">Tên Tác Giả:</label>
	                <input type="text" id="author" name="author" required>
	            </div>

	            <div class="form-group">
	                <label for="image">Hình ảnh:</label>
	                <input type="file" id="image" name="image">

	                <!-- input để lưu fileName hiện tại -->
	                <input type="hidden" id="currentImageURL" name="currentImageURL">

	                <!-- hiển thị ảnh cũ -->
	                <div id="imagePreview" style="margin-top: 5px; font-size: 0.9em; color: #555;"></div>
	            </div>

	            <div class="form-group">
	                <label for="home">Trang nhất:</label>
	                <input type="checkbox" id="home" name="home" value="true">
	            </div>

	            <div class="form-actions">
	                <button type="submit" class="btn-save">Lưu</button>
	                <button type="button" class="btn-new" onclick="resetForm()">Mới</button>
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
	                <c:choose>
	                    <c:when test="${not empty newsList}">
	                        <c:forEach var="item" items="${newsList}">
	                            <tr 
	                                data-id="${item.id}"
	                                data-title="${item.title}"
	                                data-content="${item.content}"
	                                data-image="${item.image}"
	                                data-author="${item.author}"
	                                data-categoryid="${item.categoryId}"
	                                data-home="${item.home}">
	                                
	                                <td>${item.id}</td>
	                                <td>${item.title}</td>

	                                <td>
	                                    <c:choose>
	                                        <c:when test="${item.categoryId == 1}">Thời sự</c:when>
	                                        <c:when test="${item.categoryId == 2}">Văn hóa</c:when>
	                                        <c:when test="${item.categoryId == 3}">Pháp luật</c:when>
	                                        <c:when test="${item.categoryId == 4}">Thể thao</c:when>
	                                        <c:when test="${item.categoryId == 5}">Giáo dục</c:when>
	                                        <c:otherwise>Khác</c:otherwise>
	                                    </c:choose>
	                                </td>

	                                <td><fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/></td>

	                                <td>${item.author}</td>
	                                <td>${item.viewCount}</td>

	                                <td>
	                                    <c:if test="${item.home}">
	                                        <i class="fa-solid fa-check" style="color: green;"></i>
	                                    </c:if>
	                                    <c:if test="${not item.home}">
	                                        <i class="fa-solid fa-xmark" style="color: red;"></i>
	                                    </c:if>
	                                </td>

	                                <td>
	                                    <a href="#" class="btn-edit" onclick="loadNewsForEdit(${item.id})">Sửa</a> |
	                                    <a href="${pageContext.request.contextPath}/tin-tuc?action=delete&id=${item.id}"
	                                        onclick="return confirm('Xóa bản tin ID: ${item.id}?')" 
	                                        class="btn-delete">Xóa</a>
	                                </td>
	                            </tr>
	                        </c:forEach>
	                    </c:when>

	                    <c:otherwise>
	                        <tr><td colspan="8" class="no-data">Chưa có bản tin nào.</td></tr>
	                    </c:otherwise>
	                </c:choose>
	            </tbody>
	        </table>
	    </div>
	</div>

	<script>
	    function loadNewsForEdit(id) {
	        var row = document.querySelector('tr[data-id="' + id + '"]');
	        var imagePreviewDiv = document.getElementById('imagePreview');

	        if (row) {
	            document.getElementById('id').value = id;
	            document.getElementById('title').value = row.dataset.title;
	            document.getElementById('content').value = row.dataset.content;
	            document.getElementById('author').value = row.dataset.author;
	            document.getElementById('categoryid').value = row.dataset.categoryid;

	            var currentImage = row.dataset.image;
	            document.getElementById('currentImageURL').value = currentImage;

	            if (currentImage) {
	                imagePreviewDiv.innerHTML =
	                    "Ảnh hiện tại:<br>" +
	                    "<img src='${pageContext.request.contextPath}/upload_img/news/" + currentImage + "' style='max-width:150px; margin-top:5px; border:1px solid #ccc;'>";
	            } else {
	                imagePreviewDiv.innerHTML = "Chưa có ảnh.";
	            }

	            document.getElementById('image').value = "";
	            document.getElementById('home').checked = (row.dataset.home === 'true');
	            document.querySelector('.btn-save').textContent = 'Cập nhật';

	            window.scrollTo(0, 0);
	        }
	    }

	    function resetForm() {
	        document.getElementById('newsForm').reset();
	        document.getElementById('id').value = "";
	        document.getElementById('currentImageURL').value = "";
	        document.getElementById('imagePreview').innerHTML = "";
	        document.querySelector('.btn-save').textContent = 'Lưu';
	    }

	    window.onload = resetForm;
	</script>

</body>
</html>
