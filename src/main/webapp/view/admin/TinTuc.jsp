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
				
				<style>
				.crud-header {
				    display: flex;
				    justify-content: space-between;
				    align-items: center;
				    margin-bottom: 0; 
				    padding-bottom: 0; 
				}
				
				.search-form {
				    display: flex;
				    align-items: center;
				    gap: 8px; /* Giãn cách giữa các thành phần trong form */
				}
				
				.search-input {
				    padding: 8px 10px;
				    border: 1px solid #ccc;
				    border-radius: 4px 0 0 4px;
				    width: 250px;
				    font-size: 0.95em;
				}
				
				.search-select {
				    padding: 8px 10px;
				    border: 1px solid #ccc;
				    border-right: none;
				    font-size: 0.95em;
				    margin-left: -1px; 
				}
				
				.btn-search {
				    padding: 8px 15px;
				    background-color: #007bff; 
				    color: white;
				    border: 1px solid #007bff;
				    border-radius: 0 4px 4px 0; 
				    cursor: pointer;
				    transition: background-color 0.3s;
				    font-size: 0.95em;
				}
				
				.btn-search:hover {
				    background-color: #0056b3;
				}
				
				.btn-clear-search {
				text-decoration: none;
				    margin-left: 2px; /* Giãn cách nhẹ với nút Tìm */
				    padding: 10px 15px; /* Điều chỉnh padding để bằng với input */
				    background-color: #f44336;
				    color: white;
				    border-radius: 4px;
				    font-size: 0.95em;
				    transition: background-color 0.3s;
				}
				
				.red-divider {
				    border: none;
				    height: 3px; 
				    background-color: red; 
				    margin: 10px 0 20px 0; 
				}
				</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> 
<link rel="stylesheet" href="css/style.css">

</head>
<body>
    <jsp:include page="MenuAdmin.jsp" /> 

	<div class="crud-container">
	    
	    <div class="crud-header">
	        <h1><i class="fa fa-newspaper-o"></i> Quản Lý Tin Tức</h1>
	        <div class="search-box">
	            <form action="${pageContext.request.contextPath}/tin-tuc" method="get" class="search-form">
	                
	                <input type="text" name="searchKeyword" placeholder="Tìm kiếm theo tiêu đề/nội dung..." 
	                       value="${searchKeyword != null ? searchKeyword : ''}"
	                       class="search-input">
	                       
	                <select name="categoryId" class="search-select">
	                    <option value="0" ${selectedCategoryId == 0 ? 'selected' : ''}>-- Tất cả loại tin --</option>
	                    <c:forEach var="cat" items="${categoryList}">
	                        <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
	                            ${cat.name}
	                        </option>
	                    </c:forEach>
	                </select>
	                
	                <button type="submit" class="btn-search"><i class="fa-solid fa-magnifying-glass"></i> Tìm</button>
	                
	                <c:if test="${not empty searchKeyword || selectedCategoryId > 0}">
	                    <a href="${pageContext.request.contextPath}/tin-tuc" class="btn-clear-search">Xóa tìm kiếm</a>
	                </c:if>
	            </form>
	        </div>
	    </div>
        
        <hr class="red-divider">

	    <c:if test="${not empty message}">
	        <div class="alert success" style="font-weight: bold;">${message}</div>
	    </c:if>

	    <c:if test="${not empty error}">
	        <div class="alert error" style="font-weight: bold;">${error}</div>
	    </c:if>

	    <div class="crud-form">
	        <h3>Thông Tin Bản Tin</h3>

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
	                    <c:forEach var="cat" items="${categoryList}">
	                        <option value="${cat.id}">${cat.name}</option> 
	                    </c:forEach>
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

	                <input type="hidden" id="currentImageURL" name="currentImageURL">

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
	                                    <c:set var="categoryName" value="Khác"/>
                                        <c:forEach var="cat" items="${categoryList}">
                                            <c:if test="${item.categoryId == cat.id}">
                                                <c:set var="categoryName" value="${cat.name}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${categoryName}
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
	            
	            // Đảm bảo chọn đúng giá trị trong dropdown Category
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