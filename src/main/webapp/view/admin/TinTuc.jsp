<%-- File: TinTuc.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- Thêm JSTL Core để sử dụng vòng lặp và điều kiện --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%-- Thêm JSTL FMT để định dạng ngày tháng --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<title>Quản lý Tin Tức</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleAdmin.css">
<%-- Thêm Font Awesome để hiển thị icon --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> 
</head>
<body>
    <link rel="stylesheet" href="css/style.css">
    <%-- Đảm bảo đường dẫn này đúng nếu MenuAdmin nằm ngoài thư mục view/admin --%>
    <jsp:include page="MenuAdmin.jsp" /> 

	<div class="crud-container">
	
	    <h2>
	        <i class="fa fa-newspaper-o"></i> Quản Lý Tin Tức
	    </h2>
	    
	    <%-- HIỂN THỊ THÔNG BÁO FLASH MESSAGE TỪ SESSION --%>
	    <%-- ĐÃ THÊM STYLE font-weight: bold; --%>
	    <c:if test="${not empty message}">
	        <div class="alert success" style="font-weight: bold;">${message}</div>
	    </c:if>
	    <c:if test="${not empty error}">
	        <div class="alert error" style="font-weight: bold;">${error}</div>
	    </c:if>
	
	    <div class="crud-form">
	        <h3>Thông Tin Bản Tin</h3>
	        <%-- ACTION TRỎ ĐÚNG VỀ CONTROLLER --%>
	        <form action="${pageContext.request.contextPath}/tin-tuc" method="post" id="newsForm">
	            
	            <div class="form-group">
	                <label for="id">Mã bản tin:</label>
	                <%-- ID không cần value vì nó được điền bằng JS khi Sửa --%>
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
	                     <option value="1">Thời sự</option>
	                    <option value="2">Văn hóa</option>
	                    <option value="3">Pháp luật</option>
	                    <option value="4">Thể thao</option>
	                    <option value="5">Giáo dục</option>
	                </select>
	            </div>
	            
	            <div class="form-group">
	                <label for="content">Nội dung:</label>
	                <textarea id="content" name="content" rows="6" required ></textarea>
	            </div>
				 <div class="form-group">
	                <label for="author">Tên Tác Giả :</label>
					<%-- Đã sửa nhãn và id/name cho Tác giả --%>
					<input type="text" id="author" name="author" required ></div>
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
	                <%-- Ban đầu là "Thêm", JS sẽ đổi thành "Cập nhật" khi Sửa --%>
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
	                            <%-- THÊM data-* attributes cho JS --%>
	                            <tr data-id="${item.id}" data-title="${item.title}" data-content="${item.content}" 
	                                data-image="${item.image}" data-author="${item.author}" data-categoryid="${item.categoryId}" 
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
	                                        <c:otherwise>Khác (${item.categoryId})</c:otherwise>
	                                    </c:choose>
	                                </td>
	                                <td>
	                                    <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
	                                </td>
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
	                                    <%-- Nút Sửa gọi hàm JS --%>
	                                    <a href="#" class="btn-edit" onclick="loadNewsForEdit(${item.id})">Sửa</a> |
	                                    
	                                    <%-- Nút Xóa trỏ về Controller với action=delete --%>
	                                    <a href="${pageContext.request.contextPath}/tin-tuc?action=delete&id=${item.id}" class="btn-delete" 
                                            onclick="return confirm('Bạn có chắc chắn muốn xóa bản tin ID: ${item.id} không?')">Xóa</a>
	                                </td>
	                            </tr>
	                        </c:forEach>
	                    </c:when>
	                    <c:otherwise>
	                        <tr>
	                            <td colspan="8" class="no-data">
	                                Chưa có bản tin nào được thêm vào.
	                            </td>
	                        </tr>
	                    </c:otherwise>
	                </c:choose>
	            </tbody>
	        </table>
	    </div>
	
	</div>
	
	<script>
	    // Hàm điền dữ liệu vào form khi bấm nút Sửa
	    function loadNewsForEdit(id) {
	        // Sử dụng data attribute để lấy dữ liệu
	        var row = document.querySelector('tr[data-id="' + id + '"]');
	        if (row) {
	            document.getElementById('id').value = id;
	            document.getElementById('title').value = row.dataset.title;
	            document.getElementById('content').value = row.dataset.content;
	            document.getElementById('image').value = row.dataset.image;
	            document.getElementById('author').value = row.dataset.author;
	            document.getElementById('categoryid').value = row.dataset.categoryid;
	            
	            // Xử lý checkbox 'home'
	            var homeCheckbox = document.getElementById('home');
	            homeCheckbox.checked = (row.dataset.home === 'true');
	            
	            // ĐỔI TEXT NÚT THÀNH CẬP NHẬT/LƯU
	            document.querySelector('.btn-save').textContent = 'Cập nhật';
	            
	            // Cuộn lên đầu trang
	            window.scrollTo(0, 0);
	        }
	    }
	    
	    // Hàm reset form
	    function resetForm() {
	        document.getElementById('newsForm').reset();
	        document.getElementById('id').value = ''; // Đảm bảo ID trống để kích hoạt Add
	        document.querySelector('.btn-save').textContent = 'Thêm'; // Đổi lại thành Lưu
	    }
	    
	    // Gọi resetForm() khi trang được tải lần đầu để đảm bảo nút có text "Lưu" nếu form rỗng
	    window.onload = function() {
	        resetForm();
	    };
	</script>
</body>
</html>