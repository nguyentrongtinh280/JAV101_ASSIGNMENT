<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="lang.Language" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><fmt:message key="register.title"/></title>
    
    <%-- 1. Thêm Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    
    <%-- 2. Thêm Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;1,400&family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    
    <%-- 3. Thêm Font Awesome (Icon) --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <%-- 4. CSS Tùy chỉnh (Đã Hợp Nhất và Tối Ưu Màu Sắc cho Glassmorphism) --%>
    <style>
        /* GLOBAL: Font, Nền Glassmorphism */
        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Roboto', sans-serif;
            background-image: url('img/bacgroundLogin.jpg'); 
            background-size: cover; 
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed; 
        }
        body {
            display: flex;
            flex-direction: column;
        }

        /* MAIN CONTENT: Căn giữa */
        .main-content {
            flex-grow: 1; 
            display: flex;
            justify-content: center;
            align-items: center; 
            padding: 20px;
        }

        /* REGISTER CARD */
        .register-card {
            width: 370px;
            max-width: 450px; 
            padding: 40px; 
            border-radius: 18px; 
            
            /* Hiệu ứng Frosted Glass */
            background: rgba(255, 255, 255, 0.15); 
            backdrop-filter: blur(15px); 
            -webkit-backdrop-filter: blur(15px);
            
            /* Border và Shadow */
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
            
            animation: slideUp 0.7s ease-out; 
        }
        
        /* LOGO */
        #login-logo {
            display: block; 
            width: 80px; 
            height: 80px;
            margin: 0 auto 20px auto; 
            border-radius: 50%; 
            object-fit: cover;
            border: 2px solid rgba(255, 255, 255, 0.6); 
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.3);
        }

        /* 🔥 TIÊU ĐỀ: Đã chỉnh màu SÁNG */
        .register-card h2 {
            text-align: center;
            color: #ffffff; /* CHỈNH: Màu trắng để nổi bật trên nền Glassmorphism */
            margin-bottom: 30px; 
            font-weight: 700;
            font-size: 2.2rem;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }
        
        /* INPUT FIELDS */
        .input-group-custom {
            position: relative;
        }
        /* 🔥 ICON: Đã chỉnh màu SÁNG */
        .input-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: black; /* CHỈNH: Màu trắng cho icon */
            z-index: 2; 
            font-size: 1.1em;
        }
        /* LABEL: Giữ nguyên màu trắng */
        .form-label {
            font-weight: 600; 
            font-size: 1.05em;
            color: #ffffff; 
        }
        /* INPUT CONTROL: Giữ nguyên chữ trắng */
        .form-control {
            padding: 12px 15px 12px 45px; 
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.5); 
            background-color: rgba(255, 255, 255, 0.1); 
            color: #ffffff; 
        }
        /* PLACEHOLDER: Giữ nguyên màu trắng mờ */
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7); 
        }
        .form-control:focus {
            border-color: #ffffff;
            box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.2); 
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        /* NÚT ĐĂNG KÝ: Giữ nguyên chữ trắng */
        .btn-brand-secondary {
            background: rgba(180, 255, 255, 0.15); 
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            color: #ffffff;
            padding: 14px;
            font-size: 1.15em;
            font-weight: 700;
            border-radius: 12px;
            letter-spacing: 1px;
            box-shadow: 0 4px 18px rgba(0, 255, 255, 0.1);
            transition: 0.3s ease;
        }

        .btn-brand-secondary:hover {
            background: rgba(180, 255, 255, 0.3); 
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(0, 255, 255, 0.2);
        }
        
        /* LINK ĐĂNG NHẬP: Giữ nguyên chữ trắng */
        .alt-link-text {
            color: #ffffff; 
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }
        .alt-link-text a {
            color: #ffffff;
            font-weight: 700;
            text-decoration: underline;
            transition: color 0.3s;
        }
        /* Thay đổi màu hover sang màu sáng/đỏ để dễ nhìn hơn */
        .alt-link-text a:hover {
             color: #ffcccc; /* Màu đỏ nhạt hơn để nổi bật */
             text-decoration: none;
        }

        /* THÔNG BÁO LỖI: Giữ nguyên chữ trắng */
        .alert-error {
            color: #fff; 
            background-color: rgba(255, 0, 0, 0.5); 
            border-color: rgba(255, 255, 255, 0.5);
            text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    
    <div class="main-content">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-auto">
                    <div class="register-card">

                        <img id="login-logo" src="img/lgo.png" alt="Logo">

                        <h2 class="mb-4"><fmt:message key="register.header"/></h2>

                        <c:if test="${not empty requestScope.error}">
                            <div class="alert alert-error mb-4" role="alert">
                                ${requestScope.error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="POST">

                            <!-- Fullname -->
                            <div class="mb-3">
                                <label class="form-label"><fmt:message key="register.fullname"/>:</label>
                                <div class="input-group-custom">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" name="fullname" class="form-control"
                                           placeholder="<fmt:message key='register.fullname.placeholder'/>" required>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label class="form-label"><fmt:message key="register.email"/>:</label>
                                <div class="input-group-custom">
                                    <i class="fas fa-envelope input-icon"></i>
                                    <input type="email" name="email" class="form-control"
                                           placeholder="<fmt:message key='register.email.placeholder'/>" required>
                                </div>
                            </div>

                            <!-- Password -->
                            <div class="mb-3">
                                <label class="form-label"><fmt:message key="register.password"/>:</label>
                                <div class="input-group-custom">
                                    <i class="fas fa-lock input-icon"></i>
                                    <input type="password" name="password" class="form-control"
                                           placeholder="<fmt:message key='register.password.placeholder'/>" required>
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="mb-4">
                                <label class="form-label"><fmt:message key="register.confirm"/>:</label>
                                <div class="input-group-custom">
                                    <i class="fas fa-key input-icon"></i>
                                    <input type="password" name="confirmPassword" class="form-control"
                                           placeholder="<fmt:message key='register.confirm.placeholder'/>" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-brand-secondary w-100">
                                <fmt:message key="register.submit"/>
                            </button>

                            <div class="text-center mt-4 alt-link-text">
                                <p class="mb-0">
                                    <fmt:message key="register.haveaccount"/> 
                                    <a href="${pageContext.request.contextPath}/login">
                                        <fmt:message key="register.login"/>
                                    </a>
                                </p>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

</body> 
</html>