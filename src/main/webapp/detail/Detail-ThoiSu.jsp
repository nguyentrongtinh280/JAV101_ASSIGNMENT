<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Chi tiết Bản tin</title>
    <link rel="stylesheet" href="../css/style.css">
</head>

<body>
<header class="header">
	<img src="../img/logo.png" alt="Logo ABC News" class="header-image">
</header>

<jsp:include page="/menu.jsp" />

<main class="content-container">
    <section class="main-content">
        
        <c:set var="newsId" value="${param.id}" />

        <c:choose>
        	<c:when test="${newsId == 'ts1'}">
                <h1 class="news-detail-title">Tình hình an ninh khu vực: Diễn biến mới nhất sau cuộc họp thượng đỉnh</h1>
                
                <p class="meta">20/11/2025 | Tác giả: Phóng viên A</p>
                
                <img src="../img/hinh17.png" alt="Ảnh chi tiết" class="news-image-detail">
                
                <div class="news-detail-content">
                    <p>Nội dung chi tiết bản tin... Nội dung chi tiết bản tin... Nội dung chi tiết bản tin... Nội dung chi tiết bản tin... [cite: 130] Nội dung chi tiết bản tin... Nội dung chi tiết bản tin... Nội dung chi tiết bản tin...</p>
                    <p>Các chuyên gia nhận định rằng tình hình đã có những chuyển biến tích cực sau khi các bên đạt được thỏa thuận quan trọng về... (đây là phần nội dung đầy đủ). [cite: 130, 131]</p>
                </div>
            </c:when>
            
            <c:when test="${newsId == 'ts2'}">
                 <h1 class="news-detail-title">Chính sách mới về giáo dục: Thay đổi căn bản trong chương trình học</h1>
                
                <p class="meta">19/11/2025 | Tác giả: Phóng viên B</p>
                
                <img src="../img/hinh17.png" alt="Ảnh chi tiết" class="news-image-detail">
                
                <div class="news-detail-content">
                    <p>Nội dung chi tiết bản tin... Chính phủ đã ban hành một loạt chính sách mới nhằm cải thiện chất lượng đào tạo và hội nhập quốc tế...</p>
                    <p>Các nội dung chi tiết về chương trình, sách giáo khoa và phương pháp giảng dạy sẽ được triển khai vào đầu năm học tới.</p>
                </div>
            </c:when>

            <c:otherwise>
                <h1 class="news-detail-title">Không tìm thấy bản tin</h1>
                <p>Mã bản tin: ${newsId} không tồn tại.</p>
            </c:otherwise>
        </c:choose>

        <hr>
        
        <div class="related-news">
            <h2>TIN CÙNG LOẠI</h2>
            <ul>
                <li><a href="detail.jsp?id=ts4">Tiêu đề bản tin cùng loại 1</a></li>
                <li><a href="detail.jsp?id=ts5">Tiêu đề bản tin cùng loại 2</a></li>
                <li><a href="detail.jsp?id=ts6">Tiêu đề bản tin cùng loại 3</a></li>
            </ul>
        </div>

    </section>

    <jsp:include page="/sidebar.jsp" />

</main>

<footer class="footer">
    <p>Góc Nhìn Báo Chí</p>
</footer>
</body>
</html>