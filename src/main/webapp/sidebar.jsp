<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- 
    Sử dụng lớp 'sidebar-content' đã được định nghĩa trong index.jsp 
    để áp dụng các style bố cục và hộp (box-shadow/padding).
--%>
<aside class="sidebar-content">

    <%-- =========================================== --%>
    <%-- 1. 5 BẢN TIN ĐƯỢC XEM NHIỀU (Giữ nguyên) --%>
    <%-- =========================================== --%>
    <div class="widget hot-news most-viewed-box">
        <h3>5 BẢN TIN ĐƯỢC XEM NHIỀU</h3>
        
        <ol class="most-viewed-list">
            <li><span class="rank-number">1</span><a href="detail.jsp?id=hot1">Tin Hot Về Vấn Đề Pháp Luật</a></li>
            <li><span class="rank-number">2</span><a href="detail.jsp?id=hot2">Tin Hot Về Vấn Đề Giáo Dục </a></li>
            <li><span class="rank-number">3</span><a href="detail.jsp?id=hot3">Tin Hot Về Vấn Đề Thể Thao</a></li>
            <li><span class="rank-number">4</span><a href="detail.jsp?id=hot4">Tin Hot Về Vấn Đề Thời Sự</a></li>
            <li><span class="rank-number">5</span><a href="detail.jsp?id=hot5">Tin Hot Về Vấn Đề Văn Hóa</a></li>
        </ol>
    </div>
    
    <%-- =========================================== --%>
    <%-- 2. 6 BẢN TIN MỚI NHẤT (Đã chuyển sang dùng style đánh số) --%>
    <%-- =========================================== --%>
    <div class="widget new-news">
        <h3>6 BẢN TIN MỚI NHẤT</h3>
        <%-- Đổi thành OL và áp dụng class .most-viewed-list để dùng CSS tương tự --%>
        <ol class="most-viewed-list"> 
            <li><span class="rank-number">1</span><a href="detail.jsp?id=new1">Tin Mới Nhất Về Môi Trường</a></li>
            <li><span class="rank-number">2</span><a href="detail.jsp?id=new2">Tin Mới Về Giáo Dục</a></li>
            <li><span class="rank-number">3</span><a href="detail.jsp?id=new3">Tin Mới Về Pháp Luật</a></li>
            <li><span class="rank-number">4</span><a href="detail.jsp?id=new4">Tin Mới Về Thể Thao</a></li>
            <li><span class="rank-number">5</span><a href="detail.jsp?id=new5">Tin Mới Về Thời Sự</a></li>
            <li><span class="rank-number">6</span><a href="detail.jsp?id=new6">Tin Mới Về Văn Hóa</a></li>
            
        </ol>
    </div>

    <%-- =========================================== --%>
    <%-- 3. 5 BẢN TIN ĐÃ XEM (Đã chuyển sang dùng style đánh số) --%>
    <%-- =========================================== --%>
    <div class="widget viewed-news">
        <h3>5 BẢN TIN BẠN ĐÃ XEM</h3>
        <%-- Đổi thành OL và áp dụng class .most-viewed-list để dùng CSS tương tự --%>
        <ol class="most-viewed-list"> 
            <li><span class="rank-number">1</span><a href="detail.jsp?id=view1">Tin đã xem: Chủ đề Công nghệ</a></li>
            <li><span class="rank-number">2</span><a href="detail.jsp?id=view2">Tin đã xem: Chủ đề Kinh tế</a></li>
            <li><span class="rank-number">3</span><a href="detail.jsp?id=view3">Tin đã xem: Chủ đề Xã hội</a></li>
            <li><span class="rank-number">4</span><a href="detail.jsp?id=view4">Tin đã xem: Chủ đề Du lịch</a></li>
            <li><span class="rank-number">5</span><a href="detail.jsp?id=view5">Tin đã xem: Chủ đề Sức khỏe</a></li>
        </ol>
    </div>

    <%-- =========================================== --%>
    <%-- 4. ĐĂNG KÝ NEWSLETTER (Giữ nguyên) --%>
    <%-- =========================================== --%>
    <div class="widget newsletter">
        <h3>Đăng Ký Newsletter</h3>
        <p>Nhập email để nhận tin mới nhất từ Góc Nhìn Báo Chí.</p>
        <form action="${pageContext.request.contextPath}/newsletter-register" method="POST" class="newsletter-form">
            <input type="email" name="email" placeholder="Email nhận bản tin" required class="form-control">
            <button type="submit" class="btn btn-danger btn-sm w-100 mt-2">Đăng ký</button>
        </form>
    </div>
</aside>