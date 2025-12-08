<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${newsItem.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
    /* CSS CHUNG CHO HEADER (Giống trang index) */
        .header {
            display: flex; 
            justify-content: space-between;
            align-items: center; 
            padding: 15px 30px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #eeeeee; 
            height: 80px; 
        }
        
        /* Điều chỉnh kích thước Logo */
        .header-image {
            height: 60px; 
            width: auto; 
        }
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
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e8e8e8;
        }

        /* Tiêu đề bài viết */
        .main-content h1 {
            font-size: 2rem;
            line-height: 1.3;
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
            letter-spacing: 0.2px;
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

    </style>

</head>

<body>

<!-- ===== HEADER ===== -->
<header class="header">
    <img src="${pageContext.request.contextPath}/img/lgo.png"
         alt="Logo ABC News" class="header-image">

    <div class="header-login">
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </div>
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">

    <section class="main-content">

        <h1>${newsItem.title}</h1>

        <p class="meta">
            Ngày đăng:
            <fmt:formatDate value="${newsItem.postedDate}" pattern="dd/MM/yyyy" />
            &nbsp; | &nbsp;
            Tác giả: ${newsItem.author}
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
    <p>Góc Nhìn Báo Chí</p>
</footer>

</body>
</html>
