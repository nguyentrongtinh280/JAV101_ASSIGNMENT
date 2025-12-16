<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 1. THIẾT LẬP ĐA NGÔN NGỮ (TỪ DEVELOP) --%>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${newsItem.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .content-container {
            display: grid;
            grid-template-columns: 3fr 1fr;
            gap: 35px;
            max-width: 1200px;
            margin: 25px auto;
            padding: 0 20px;
        }

        /* Khối nội dung chính */
        .main-content {
            background: #ffffff;
            padding: 100px 50px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e8e8e8;
        }

        /* Tiêu đề bài viết */
        .main-content h1 {
            font-size: 2rem;
            line-height: 1.3; /* GIỮ TỪ CODE CỦA BẠN */
            margin-bottom: 15px;
            color: #222;
        }

        /* Meta: Ngày đăng + tác giả */
        .meta {
            font-size: 0.95rem;
            color: #777;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 12px;
            display: flex;
            align-items: center;
        }

        /* Ảnh lớn */
        .detail-image {
            width: 100%;
            max-height: 450px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid #ddd;
        }

        /* Nội dung bài viết */
        .content {
            font-size: 1.1rem;
            color: #333;
            line-height: 1.8;
            letter-spacing: 0.2px; /* GIỮ TỪ CODE CỦA BẠN */
            text-align: justify;
            padding-bottom: 30px;
        }

        .content p {
            margin-bottom: 16px;
        }

        /* Tối ưu mobile */
        @media (max-width: 992px) {
            .content-container {
                grid-template-columns: 1fr;
            }
            .main-content {
                padding: 20px;
            }
        }
        
        /* CSS VIEW COUNT (TỪ CODE CỦA BẠN) */
        .view-count-info {
            display: inline-flex;
            align-items: center;
            margin-left: auto; 
            font-weight: 600;
            color: #0056b3; 
        }

        .view-icon {
            margin-right: 5px;
            font-size: 1.5rem; 
            color: #8b4513; 
            line-height: 1; 
        }

    </style>

</head>

<body>

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

<jsp:include page="/menu.jsp" />
    
    <main class="content-container">
    
        <section class="main-content">
    
            <h1>${newsItem.title}</h1>
    
            <p class="meta">
                <%-- SỬ DỤNG I18N CHO NGÀY ĐĂNG VÀ TÁC GIẢ (TỪ DEVELOP) --%>
                <fmt:message key="detail.postedDate" />:
                <fmt:formatDate value="${newsItem.postedDate}" pattern="dd/MM/yyyy" />
                &nbsp; | &nbsp;
                <fmt:message key="detail.author" />: ${newsItem.author}
    
                <%-- CHÈN VIEW COUNT VÀ SỬ DỤNG I18N CHO 'LƯỢT XEM' (KẾT HỢP) --%>
                <span class="view-count-info">
                    <span class="view-icon">👁️</span>
                    ${newsItem.viewCount} <fmt:message key="detail.views" />
                </span>
                
            </p>
    
            <img src="${pageContext.request.contextPath}/upload_img/news/${newsItem.image}"
                 alt="${newsItem.title}" class="detail-image">
    
            <div class="content">
                ${newsItem.content}
            </div>
    
        </section>
    
        <jsp:include page="/sidebar.jsp" />
    
    </main>


<footer class="footer">
    <p><fmt:message key="detail.footer" /></p>
</footer>

</body>
</html>