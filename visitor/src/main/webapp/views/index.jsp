<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>AI 문화시설 관람 도우미</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/variables.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
</head>
<body>

<!-- 헤더: Bootstrap Navbar + 커스텀 디자인 -->
<nav class="header navbar navbar-expand-lg navbar-light fixed-top">
    <div class="header-container">
        <!-- 로고 -->
        <a href="<c:url value='/'/>" class="navbar-brand header-logo">
            <div class="logo-icon">
                <span>文化</span>
            </div>
            <div class="logo-text">
                <div class="logo-title">AI CULTURE GUIDE</div>
                <div class="logo-subtitle">SMART AI ASSISTANT</div>
            </div>
        </a>

        <!-- 모바일 햄버거 버튼 -->
        <button class="navbar-toggler" type="button"
                data-toggle="collapse" data-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false"
                aria-label="메뉴 토글">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 네비게이션 + 로그인 버튼 -->
        <div class="collapse navbar-collapse header-nav" id="mainNavbar">
            <ul class="navbar-nav ml-auto nav-menu">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/'/>">홈</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/voice'/>'">AI 음성 안내</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/map'/>">위치 안내</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/artwork'/>">AI 작품 생성</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/epidemic'/>">전염병 알리미</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/culture'/>">문화 해설</a>
                </li>
            </ul>

            <div class="header-actions">
                <button class="btn btn-outline"
                        onclick="location.href='<c:url value='/login'/>'">
                    로그인
                </button>
            </div>
        </div>
    </div>
</nav>

<!-- 메인 영역 -->
<main>
    <c:choose>
        <c:when test="${center == null}">
            <jsp:include page="center.jsp"/>
        </c:when>
        <c:otherwise>
            <jsp:include page="${center}.jsp"/>
        </c:otherwise>
    </c:choose>
</main>

<!-- 푸터 -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div>
                <h3 class="footer-title">AI Culture Guide</h3>
                <p style="color: rgba(255, 255, 255, 0.7);">
                    인공지능 기술로 더 나은 문화 경험을 제공합니다.
                </p>
            </div>

            <div>
                <h3 class="footer-title">바로가기</h3>
                <ul class="footer-links">
                    <li><a href="<c:url value='/'/>">홈</a></li>
                    <li><a href="<c:url value='/voice'/>">AI 음성 안내</a></li>
                    <li><a href="<c:url value='/map'/>">위치 안내</a></li>
                    <li><a href="<c:url value='/artwork'/>">AI 작품 생성</a></li>
                </ul>
            </div>

            <div>
                <h3 class="footer-title">문의</h3>
                <ul class="footer-links">
                    <li><i class="fas fa-phone"></i> 02-1234-5678</li>
                    <li><i class="fas fa-envelope"></i> info@aiculture.kr</li>
                    <li><i class="fas fa-map-marker-alt"></i> 서울특별시 종로구</li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2025 AI Culture Guide. All rights reserved.</p>
        </div>
    </div>
</footer>

<!-- JS: jQuery -> Popper -> Bootstrap -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>

<!-- 스크롤 시 헤더 배경/그림자만 변경 (로고 크기는 고정) -->
<script>
    (function () {
        var header = document.querySelector('.header');
        if (!header) return;

        window.addEventListener('scroll', function () {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    })();
</script>

</body>
</html>
