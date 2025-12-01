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
    <link rel="stylesheet" href="css/style.css">
</head>
<body>   
    <jsp:include page="MenuAdmin.jsp" /> 

    <div class="crud-container">

        <h2><i class="fa fa-users"></i> Quản Lý Người Dùng</h2>

        <div class="crud-form">
            <h3>Thông Tin Người Dùng</h3>

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
			            <label for="fullname">Họ và tên:</label>
			            <input type="text" id="fullname" name="fullname"
			                   value="${editUser != null ? editUser.fullname : param.fullname}">
			        </div>
			        <div class="form-field-half">
			            <label for="email">Email:</label>
			            <input type="email" id="email" name="email"
			                   value="${editUser != null ? editUser.email : param.email}">
			        </div>
			    </div>
			
			    <div class="form-group two-columns">
				    <div class="form-field-half">
				        <label for="password">Mật khẩu mới:</label>
				        <input type="password" id="password" name="password">
				    </div>
				    
				    <div class="form-field-half">
				        <label for="confirm_password">Xác nhận mật khẩu mới:</label>
				        <input type="password" id="confirm_password" name="confirm_password">
				    </div>
				</div>

			    <div class="form-group two-columns">
			        <div class="form-field-half">
			            <label for="mobile">Điện thoại:</label>
			            <input type="tel" id="mobile" name="mobile" value="${editUser != null ? editUser.mobile : param.mobile}">
			        </div>
			        <div class="form-field-half">
			            <label for="birthday">Ngày sinh:</label>
			            <input type="date" id="birthday" name="birthday" value="${editUser != null ? editUser.birthday : param.birthday}">
			        </div>
			    </div>
			
			    <div class="form-group two-columns">
			        <div class="form-field-half gender-group">
			            <label>Giới tính:</label>
			            <input type="radio" id="gender_male" name="gender" value="0"
			                   ${editUser != null && editUser.gender == 0 ? 'checked' : (param.gender == '0' ? 'checked' : '')}>
			            <label for="gender_male">Nam</label>
			
			            <input type="radio" id="gender_female" name="gender" value="1"
			                   ${editUser != null && editUser.gender == 1 ? 'checked' : (param.gender == '1' ? 'checked' : '')}>
			            <label for="gender_female">Nữ</label>
			        </div>
			
			        <div class="form-field-half">
			            <label for="role">Vai trò:</label>
			            <select id="role" name="role">
			                <option value="" ${editUser == null && param.role == '' ? 'selected' : ''}>-- Chọn vai trò --</option>
			                <option value="0" ${editUser != null && editUser.role == 0 ? 'selected' : (param.role == '0' ? 'selected' : '')}>Phóng viên</option>
			                <option value="1" ${editUser != null && editUser.role == 1 ? 'selected' : (param.role == '1' ? 'selected' : '')}>Quản trị viên</option>
			            </select>
			        </div>
			    </div>
			
			    <div class="form-actions" style="margin-top:20px;">
				    <button type="submit" class="btn-save">${editUser != null ? "Cập nhật" : "Lưu"}</button>
				    <button type="button" class="btn-new" onclick="window.location.href='${pageContext.request.contextPath}/nguoi-dung'">Mới</button>
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
                    <c:choose>
                        <c:when test="${not empty listUser}">
                            <c:forEach var="u" items="${listUser}">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${u.fullname}</td>
                                    <td>${u.birthday}</td>
                                    <td>${u.gender == 0 ? "Nam" : "Nữ"}</td>
                                    <td>${u.email}</td>
                                    <td>${u.role == 0 ? "Phóng viên" : "Quản trị viên"}</td>
                                    <td>
									    <a href="${pageContext.request.contextPath}/nguoi-dung?action=edit&id=${u.id}">Sửa</a> |
									    <a href="${pageContext.request.contextPath}/nguoi-dung?action=delete&id=${u.id}" 
									       onclick="return confirm('Bạn có chắc muốn xóa người dùng này không?');">
									       Xóa
									    </a>
									</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="no-data">Chưa có người dùng nào được thêm vào.</td>
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