<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />
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
	        <h1><i class="fa fa-newspaper-o"></i> <fmt:message key="news.title"/></h1>
	
	        <div class="search-box">
	            <form action="${pageContext.request.contextPath}/tin-tuc" method="get" class="search-form">
	                
	                <input type="text" name="searchKeyword"
	                       placeholder="<fmt:message key='search.placeholder'/>"
	                       value="${searchKeyword != null ? searchKeyword : ''}"
	                       class="search-input">
	
	                <select name="categoryId" class="search-select">
	                    <option value="0" ${selectedCategoryId == 0 ? 'selected' : ''}>
	                        <fmt:message key="category.all"/>
	                    </option>
	
	                    <c:forEach var="cat" items="${categoryList}">
	                        <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
	                            ${cat.name}
	                        </option>
	                    </c:forEach>
	                </select>
	
	                <button type="submit" class="btn-search">
	                    <i class="fa-solid fa-magnifying-glass"></i> <fmt:message key="search"/>
	                </button>
	
	                <c:if test="${not empty searchKeyword || selectedCategoryId > 0}">
	                    <a href="${pageContext.request.contextPath}/tin-tuc" class="btn-clear-search">
	                        <fmt:message key="clear.search"/>
	                    </a>
	                </c:if>
	
	            </form>
	        </div>
	    </div>
	
	    <hr class="red-divider">
	
	    <div class="crud-form">
	        <h3><fmt:message key="form.info"/></h3>
	
	        <form action="${pageContext.request.contextPath}/tin-tuc" method="post"
	              enctype="multipart/form-data" id="newsForm">
	
	            <div class="form-group">
	                <label><fmt:message key="form.id"/></label>
	                <input type="text" id="id" name="id" readonly>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.title"/></label>
	                <input type="text" id="title" name="title" required>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.category"/></label>
	                <select id="categoryid" name="categoryid" required>
	                    <option value="">-- Chọn --</option>
	                    <c:forEach var="cat" items="${categoryList}">
	                        <option value="${cat.id}">${cat.name}</option>
	                    </c:forEach>
	                </select>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.content"/></label>
	                <textarea id="content" name="content" rows="6" required></textarea>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.author"/></label>
	                <input type="text" id="author" name="author" required>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.image"/></label>
	                <input type="file" id="image" name="image">
	                <input type="hidden" id="currentImageURL" name="currentImageURL">
	                <div id="imagePreview"></div>
	            </div>
	
	            <div class="form-group">
	                <label><fmt:message key="form.home"/></label>
	                <input type="checkbox" id="home" name="home" value="true">
	            </div>
	
	            <div class="form-actions">
	                <button type="submit" class="btn-save"><fmt:message key="btn.save"/></button>
	                <button type="button" class="btn-new" onclick="resetForm()"><fmt:message key="btn.new"/></button>
	            </div>
	
	        </form>
	    </div>
	
	    <div class="crud-table">
	        <h3><fmt:message key="table.list"/></h3>
	
	        <table>
	            <thead>
	                <tr>
	                    <th><fmt:message key="table.id"/></th>
	                    <th><fmt:message key="table.title"/></th>
	                    <th><fmt:message key="table.category"/></th>
	                    <th><fmt:message key="table.date"/></th>
	                    <th><fmt:message key="table.author"/></th>
	                    <th><fmt:message key="table.view"/></th>
	                    <th><fmt:message key="table.home"/></th>
	                    <th><fmt:message key="table.action"/></th>
	                </tr>
	            </thead>
	
	            <tbody>
	                <c:choose>
	                    <c:when test="${not empty newsList}">
	                        <c:forEach var="item" items="${newsList}">
	                            <tr data-id="${item.id}"
	                                data-title="${item.title}"
	                                data-content="${item.content}"
	                                data-categoryid="${item.categoryId}"
	                                data-image="${item.image}"
	                                data-home="${item.home}"
	                                data-author="${item.author}">
	
	                                <td>${item.id}</td>
	                                <td>${item.title}</td>
	
	                                <td>
	                                    <c:forEach var="cat" items="${categoryList}">
	                                        <c:if test="${cat.id == item.categoryId}">
	                                            ${cat.name}
	                                        </c:if>
	                                    </c:forEach>
	                                </td>
	
	                                <td><fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/></td>
	                                <td>${item.author}</td>
	                                <td>${item.viewCount}</td>
	
	                                <td>
	                                    <c:if test="${item.home}">
	                                        ✔
	                                    </c:if>
	                                    <c:if test="${not item.home}">
	                                        ✘
	                                    </c:if>
	                                </td>
	
	                                <td>
	                                    <a href="#" class="btn-edit" onclick="loadNewsForEdit(${item.id})">
	                                        <fmt:message key="action.edit"/>
	                                    </a> |
	
	                                    <a href="${pageContext.request.contextPath}/tin-tuc?action=delete&id=${item.id}"
	                                       onclick="return confirm('<fmt:message key="confirm.delete"/> ${item.id}?')"
	                                       class="btn-delete">
	                                       <fmt:message key="action.delete"/>
	                                    </a>
	                                </td>
	
	                            </tr>
	                        </c:forEach>
	                    </c:when>
	
	                    <c:otherwise>
	                        <tr>
	                            <td colspan="8" class="no-data">
	                                <fmt:message key="table.no.data"/>
	                            </td>
	                        </tr>
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
	            // Đảm bảo chọn đúng giá trị trong dropdown Category// Đảm bảo chọn đúng giá trị trong dropdown Category
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