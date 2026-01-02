<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<c:if test="${empty sessionScope.loggedInUser}">
    <c:redirect url="${pageContext.request.contextPath}/login" />
</c:if>

<c:set var="loggedInUser" value="${sessionScope.loggedInUser}" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}"><html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ Quản Trị - Góc Nhìn Báo Chí</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
    
    	*{
    	box-sizing: border-box;	
    	}
		.card-link {
		    text-decoration: none;
		    color: inherit;
		    display: block;
		    height: 100%; 
		}	
        /* CSS CHUNG */
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            padding-bottom: 40px; 
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        /* 1. CSS CHO HEADER/LOGIN */
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
        .header-login strong {
            color: #d9534f;
            font-weight: 700;
        }
        
        .alert-container {
            width: 100%;
            max-width: 600px;
            margin: 15px auto 0 auto;
        }
        
        /* 2. CSS CHO MENU */
        .main-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
            background-color: #34495e; 
            display: flex;
            justify-content: center; 
        }
        .main-nav li a {
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .main-nav li a:hover {
            background-color: #2c3e50; 
        }
        
        /* 3. CSS CHO DASHBOARD CARDS */
        .welcome-banner {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
            margin-bottom: 30px;
        }        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            align-items: stretch; 
        }
        
        .card-link {
            text-decoration: none; 
            color: inherit; 
            display: block; 
            height: 100%; 
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border-left: 5px solid;
            transition: transform 0.3s;
            height: 100%; 
        }
        
        .card-header {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .card-header i {
            margin-right: 10px;
            font-size: 1.5rem;
        }
        .card-value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-top: 5px;
        }

        .card.users { border-left-color: #2ecc71; }
        .card.users .card-value { color: #2ecc71; }
        .card.categories { border-left-color: #e67e22; }
        .card.categories .card-value { color: #e67e22; }
        .card.news { border-left-color: #d9534f; }
        .card.news .card-value { color: #d9534f; }
        .card.subscribers { border-left-color: #5bc0de; }
        .card.subscribers .card-value { color: #5bc0de; }

        /* CSS Footer */
        .footer {
            padding: 10px;
            text-align: center;
            background-color: #34495e;
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
            height: 40px; 
            left: 0;
            right: 0;
        }
    </style>
</head>
<body>

    <div id="page-container">
        
        <%-- KHỐI HIỂN THỊ FLASH MESSAGE VÀ TỰ ĐỘNG TẮT --%>
        <div class="alert-container">
            <c:if test="${not empty sessionScope.flashMessage}">
                <div id="autoDismissAlert" class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.flashMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%-- QUAN TRỌNG: XÓA THÔNG BÁO SAU KHI HIỂN THỊ --%>
                <c:remove var="flashMessage" scope="session"/>
            </c:if>
            <c:remove var="flashError" scope="session" />
        </div>
        
        <header class="header">
            <img src="${pageContext.request.contextPath}/img/lgo.png" alt="Logo" class="header-image">
            
            <div class="header-login">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger ms-2"><fmt:message key="admin.logout"/></a>
            </div>
        </header>
        
        <jsp:include page="MenuAdmin.jsp" />

        <main id="content-wrap">
            <div class="container">

			    <div class="welcome-banner">
			        <h1><fmt:message key="admin.welcome"/> ${loggedInUser.fullname}</h1>
			        <p><fmt:message key="admin.dashboard"/></p>
			    </div>
			
			    <h2><i class="fas fa-chart-line"></i> <fmt:message key="admin.overview"/></h2>
			
			    <div class="dashboard-grid">
			
			        <a href="${pageContext.request.contextPath}/nguoi-dung" class="card-link">
			            <div class="card users">
			                <div class="card-header"><i class="fas fa-users"></i> 
			                    <fmt:message key="admin.totalUsers"/></div>
			                <div class="card-value">${totalUsers}</div>
			            </div>
			        </a>
			
			        <a href="${pageContext.request.contextPath}/loai-tin" class="card-link">
			            <div class="card categories">
			                <div class="card-header"><i class="fas fa-list-alt"></i> 
			                    <fmt:message key="admin.totalCategories"/></div>
			                <div class="card-value">${totalCategories}</div>
			            </div>
			        </a>
			
			        <a href="${pageContext.request.contextPath}/tin-tuc" class="card-link">
			            <div class="card news">
			                <div class="card-header"><i class="fas fa-newspaper"></i> 
			                    <fmt:message key="admin.totalPendingNews"/></div>
			                <div class="card-value">${totalPendingNews}</div>
			            </div>
			        </a>
			
			        <a href="${pageContext.request.contextPath}/newsletter" class="card-link">
			            <div class="card subscribers">
			                <div class="card-header"><i class="fas fa-envelope-open-text"></i> 
			                    <fmt:message key="admin.totalSubscribers"/></div>
			                <div class="card-value">${totalSubscribers}</div>
			            </div>
			        </a>
			
			    </div>
			
			</div>
        </main>
        
    </div>
        
    <footer class="footer">
	    <p><fmt:message key="admin.footer"/></p>
	</footer>
    
    <%-- BẮT BUỘC: Thêm Bootstrap JS để alert hoạt động --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

    <%-- LOGIC TỰ ĐỘNG TẮT ALERT SAU 1.5 GIÂY --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const alertElement = document.getElementById('autoDismissAlert');
            
            if (alertElement) {
                // Tự động tắt sau 1500 mili giây (1.5 giây)
                setTimeout(() => {
                    // Cần có thư viện Bootstrap JS để gọi bootstrap.Alert
                    const alert = bootstrap.Alert.getOrCreateInstance(alertElement); 
                    alert.close();
                }, 1500); 
            }
        });
    </script>
</body>
</html>