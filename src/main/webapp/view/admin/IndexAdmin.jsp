<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<%--
    🔥 BẢO MẬT: Kiểm tra người dùng đã đăng nhập chưa
    Sử dụng sessionScope.loggedInUser như đã set trong đoạn code xung đột bên dưới
--%>
<c:if test="${empty sessionScope.loggedInUser}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<%-- Lấy thông tin người dùng đã đăng nhập (đảm bảo user đã tồn tại sau khi kiểm tra) --%>
<c:set var="loggedInUser" value="${sessionScope.loggedInUser}" />

<!DOCTYPE html>
<html>
<head>
    <style>
        /* 1. Căn chỉnh Header (Sử dụng Flexbox) */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background-color: #ffffff;
            border-bottom: 1px solid #eeeeee;
            height: 80px;
        }

        /* 2. Điều chỉnh kích thước Logo cho VỪA PHẢI */
        .header-image {
            /* Giảm kích thước để phù hợp hơn với chiều cao header 80px */
            height: 60px;
            width: auto;
        }

        /* CSS cho header-login để hiển thị tên và nút Đăng xuất */
        .header-login {
            display: flex;
            align-items: center;
            font-size: 1.05rem;
        }
        .header-login strong {
            color: #d9534f; /* Màu đỏ nổi bật cho Admin/Quản trị */
            font-weight: 700;
        }
        
        /* CSS để căn giữa thông báo */
        .alert-container {
            width: 100%;
            max-width: 600px; /* Độ rộng tối đa của thông báo */
            margin: 15px auto 0 auto; /* Đặt ở giữa */
        }
    </style>

    <%-- Thêm Bootstrap CSS cho nút và alert --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <meta charset="UTF-8">
    <title>Giao Diện Quản Trị - Góc Nhìn Báo Chí</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div id="page-container">
        
        <%-- 🔥 KHỐI HIỂN THỊ FLASH MESSAGE VÀ TỰ ĐỘNG TẮT --%>
        <div class="alert-container">
            <c:if test="${not empty sessionScope.flashMessage}">
                <div id="autoDismissAlert" class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.flashMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%-- QUAN TRỌNG: XÓA THÔNG BÁO SAU KHI HIỂN THỊ --%>
                <c:remove var="flashMessage" scope="session"/>
            </c:if>
            <%-- Nếu có flash error, cũng nên xóa nó --%>
            <c:remove var="flashError" scope="session" />
        </div>
        
        <header class="header">
            <img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo" class="header-image">
            
            <%-- HIỂN THỊ LỜI CHÀO VÀ NÚT ĐĂNG XUẤT --%>
            <div class="header-login">
                <span>
                    Xin chào admin,
                        <strong>${loggedInUser.fullname}</strong>
                </span>
                <%-- Sử dụng loggedInUser đã set ở trên --%>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2">Đăng xuất</a>
            </div>
        </header>
        
        <jsp:include page="MenuAdmin.jsp" /> 

        <main id="content-wrap" style="padding: 20px; text-align: center;">
            <h2>Vùng Nội Dung Chính</h2>
            <p>Nội dung của trang Admin/Phóng viên. Hãy bắt đầu công việc quản lý của bạn!</p>
        </main>
        
    </div>
        
    <footer class="footer">
        <p>Góc Nhìn Báo Chí</p>
    </footer>
    
    <%-- BẮT BUỘC: Thêm Bootstrap JS để alert hoạt động --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

    <%-- LOGIC TỰ ĐỘNG TẮT ALERT SAU 2 GIÂY (Chỉ khi sử dụng Bootstrap 5) --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const alertElement = document.getElementById('autoDismissAlert');
            
            if (alertElement) {
                // Tự động tắt sau 2000 mili giây (1,5 giây)
                setTimeout(() => {
                    const alert = bootstrap.Alert.getOrCreateInstance(alertElement);
                    alert.close();
                }, 1500); 
            }
        });
    </script>
</body>
</html>