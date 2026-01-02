<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> 

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language"/>
<!DOCTYPE html>
<html lang="${sessionScope.lang}"><html>
<head>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title><fmt:message key="home.title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        .alert-container {
            max-width: 90%; 
            margin: 15px auto 0 auto; 
        }
        .content-container {
            display: grid;
            grid-template-columns: 3fr 1fr;
            gap: 30px; 
            max-width: 1200px; 
            margin: 20px auto; 
            padding: 0 20px;
        }
        .main-content {
            padding-right: 20px;
            border-right: 1px solid #eee; 
            grid-template-columns: 3fr 1fr;
            
        }
        .news-item {
            margin-bottom: 35px; 
            padding-bottom: 25px;
            border-bottom: 1px dashed #ddd;
            overflow: hidden; 
        }
        .news-item:last-child {
            border-bottom: none;
        }
        .news-image {
            width: 100%; 
            height: 250px; 
            object-fit: cover;
            margin-bottom: 15px; 
            border-radius: 5px;
        }
        .news-info h3 {
            font-size: 1.5rem; 
            margin-bottom: 10px;
        }
        .news-info .excerpt {
            color: #555;
            font-size: 1rem;
            line-height: 1.5;
        }
        .news-info .meta {
            font-size: 0.9rem;
            color: #888;
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .news-info .meta span {
            flex-grow: 1;
        }
        @media (max-width: 992px) {
            .content-container {
                grid-template-columns: 1fr;
                padding: 0 15px;
            }
            .main-content {
                border-right: none;
                padding-right: 0;
            }
        }
    </style>   
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>
<body>
	
	<div class="alert-container container"> 
	    <c:if test="${not empty sessionScope.flashMessage}">
	        <div id="autoDismissAlert" class="alert alert-success alert-dismissible fade show" role="alert">
	            ${sessionScope.flashMessage}
	            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
	        </div>
	    </c:if>
	</div>
	
	<header class="header">
	    <img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo" class="header-image">
	
	    <div class="header-login">
	        <c:choose>
	            <c:when test="${not empty sessionScope.loggedInUser}">
	                <fmt:message key="home.hello"/> 
	                <strong>${sessionScope.loggedInUser.fullname}</strong>
	                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2">
	                    <fmt:message key="home.logout"/>
	                </a>
	            </c:when>
	            <c:otherwise>
	                <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary">
	                    <fmt:message key="home.login"/>
	                </a>
	            </c:otherwise>
	        </c:choose>
	    </div>
	</header>
	
	<jsp:include page="menu.jsp" />
	
	<main class="content-container">
	    <section class="main-content">
	        <h2><fmt:message key="home.featured"/></h2>
	
	        <c:choose>
	            <c:when test="${not empty featuredNews}">
	                <c:forEach var="item" items="${featuredNews}">
	                    <article class="news-item">
	
	                        <img src="${pageContext.request.contextPath}/upload_img/news/${item.image}" 
	                             class="news-image">
	
	                        <div class="news-info">
	                            <h3>
	                                <a href="${pageContext.request.contextPath}/chi-tiet-tin?id=${item.id}">
	                                    ${item.title}
	                                </a>
	                            </h3>
	
	                            <p class="excerpt">
	                                ${item.content.length() > 200 ? item.content.substring(0,200).concat("...") : item.content}
	                            </p>
	
	                            <p class="meta">
	                                <span><fmt:message key="home.date"/>:
	                                    <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
	                                </span>
	
	                                <span><fmt:message key="home.author"/>:
	                                    ${item.author}
	                                </span>
	                            </p>
	                        </div>
	                    </article>
	                </c:forEach>
	            </c:when>
	
	            <c:otherwise>
	                <p><fmt:message key="home.empty"/></p>
	            </c:otherwise>
	        </c:choose>
	
	    </section>
	
	    <jsp:include page="sidebar.jsp"/>
	</main>
	
	<footer class="footer">
	    <p><fmt:message key="footer.text"/></p>
	</footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    
	<script>
	document.addEventListener('DOMContentLoaded', function() {
	    const form = document.getElementById('newsletter-form');
	    const emailInput = document.getElementById('newsletter-email');
	    const messageDiv = document.getElementById('newsletter-message');
	
	    if (form) {
	        form.addEventListener('submit', function(event) {
	            // Ngăn chặn hành động gửi form mặc định (ngăn chuyển hướng)
	            event.preventDefault(); 
	            
	            const email = emailInput.value;
	            const url = form.action;
	
	            // Ẩn thông báo cũ và hiển thị thông báo đang xử lý
	            messageDiv.style.display = 'block';
	            messageDiv.className = 'mt-2 text-info';
	            messageDiv.innerHTML = 'Đang xử lý đăng ký...';
	
	            // Gửi dữ liệu bằng fetch (AJAX)
	            fetch(url, {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded',
	                },
	                // Tạo chuỗi dữ liệu gửi đi (email=gia_tri_email)
	                body: new URLSearchParams({
	                    'email': email
	                })
	            })
	            .then(response => {
	                // Kiểm tra xem phản hồi có thành công không (status 200-299)
	                if (response.ok) {
	                    return response.text(); // Lấy phản hồi dạng text
	                }
	                // Nếu có lỗi server (4xx, 5xx), ném lỗi
	                throw new Error('Lỗi server: ' + response.status);
	            })
	            .then(responseText => {
	                // Xử lý thành công
	                messageDiv.className = 'mt-2 text-success';
	                messageDiv.innerHTML = 'Đăng ký nhận tin thành công!';
	                emailInput.value = ''; // Xóa email đã nhập
	            })
	            .catch(error => {
	                // Xử lý lỗi (ví dụ: email đã tồn tại, lỗi kết nối)
	                console.error('Đăng ký thất bại:', error);
	                messageDiv.className = 'mt-2 text-danger';
	                messageDiv.innerHTML = 'Đăng ký thất bại. Email có thể đã tồn tại.';
	            })
	            .finally(() => {
	                // Tự động ẩn thông báo sau 4 giây
	                setTimeout(() => {
	                    messageDiv.style.display = 'none';
	                }, 4000);
	            });
	        });
	    }
	});
	</script>

    <c:remove var="flashMessage" scope="session"/>
    <c:remove var="flashError" scope="session"/>	
</body>
</html>
