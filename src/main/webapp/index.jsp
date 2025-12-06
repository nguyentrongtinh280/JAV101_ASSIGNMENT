<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> 
<!DOCTYPE html>
<html>
<head>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Trang Chủ - Góc Nhìn Báo Chí </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        .header {
            display: flex; 
            justify-content: space-between;
            align-items: center; 
            padding: 15px 30px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #eeeeee; 
            height: 80px; 
        }
        .header-image {
            height: 60px; 
            width: auto; 
        }
        .header-login {
            display: flex;
            align-items: center;
            font-size: 1.05rem;
        }
        .header-login a {
            text-decoration: none;
            margin: 0 5px; 
        }
        .header-login strong {
            color: #333; 
        }
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
        .footer {
            text-align: center;
            padding: 20px;
            background-color: #f8f8f8;
            border-top: 1px solid #eee;
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
</head>
<body>
    
    <div class="alert-container container"> 
        <c:if test="${not empty sessionScope.flashMessage}">
            <div id="autoDismissAlert" class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.flashMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
    </div>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <header class="header">
    	<img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo ABC News" class="header-image">
        
        <div class="header-login">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}"> 
                    Xin chào, 
                        <strong>${sessionScope.loggedInUser.fullname}</strong>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2">Đăng xuất</a>
                </c:when>
                <c:when test="${not empty sessionScope.currentUser}"> 
                    Xin chào  
                        <strong>${sessionScope.currentUser.fullname}</strong>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary">Đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <jsp:include page="menu.jsp" />
    
    <main class="content-container">
        <section class="main-content">
            <h2>Tin Nổi Bật Trên Trang Nhất</h2>

            <c:choose>
                <c:when test="${not empty featuredNews}">
                    <c:forEach var="item" items="${featuredNews}">
                        
                        <article class="news-item">

                            <!-- 🔥 ĐÃ SỬA: ĐƯỜNG DẪN ẢNH ĐÚNG -->
                            <img src="${pageContext.request.contextPath}/upload_img/news/${item.image}" 
                                 class="news-image" alt="${item.title}">
                            
                            <div class="news-info">
                                <h3>
                                    <a href="${pageContext.request.contextPath}/chi-tiet-tin?id=${item.id}">
									    ${item.title}
									</a>

                                </h3>
                                
                                <p class="excerpt">
                                    ${item.content.length() > 200 ? item.content.substring(0, 200).concat("...") : item.content}
                                </p>
                                
                                <p class="meta">
                                    <span>Ngày đăng: 
                                        <fmt:formatDate value="${item.postedDate}" pattern="dd/MM/yyyy"/>
                                    </span>
                                    <span>Tác giả: ${item.author}</span>
                                </p>
                            </div>
                        </article>
                        
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Hiện không có tin tức nổi bật nào được đánh dấu để hiển thị trên trang nhất.</p>
                </c:otherwise>
            </c:choose>
            
        </section>

        <jsp:include page="sidebar.jsp"/>
    </main>

    <footer class="footer">
        <p>Góc Nhìn Báo Chí</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const alertElement = document.getElementById('autoDismissAlert');
            if (alertElement) {
                setTimeout(() => {
                    const alert = bootstrap.Alert.getOrCreateInstance(alertElement);
                    alert.close();
                }, 2000); 
            }
        });
    </script>

    <c:remove var="flashMessage" scope="session"/>
    <c:remove var="flashError" scope="session"/>	
</body>
</html>
