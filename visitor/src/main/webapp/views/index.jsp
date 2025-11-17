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
<!-- Epidemic Info Modal -->
<div class="modal fade" id="epidemicModal" tabindex="-1"
     role="dialog" aria-labelledby="epidemicModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">

            <!-- 제목 -->
            <div class="modal-header">
                <h5 class="modal-title" id="epidemicModalLabel">전염병 알림 및 안내</h5>
            </div>

            <!-- 본문 -->
            <div class="modal-body">
                <h6 class="mb-2">
                    현재 위험 단계 :
                    <span class="badge badge-danger">경계</span>
                </h6>

                <p class="mb-2">
                    ○○지역 전염병 의심 사례가 증가하고 있습니다.<br>
                    손 씻기, 마스크 착용 등 기본 예방 수칙을 지켜주세요.
                </p>

                <ul class="mb-2">
                    <li>발열 · 기침 · 인후통이 있을 경우 방문 전 문의 필수</li>
                    <li>방문 시 마스크 착용 및 손 소독 필수</li>
                    <li>최근 14일 이내 해외 방문 시 안내 데스크 고지</li>
                </ul>

                <small class="text-muted">
                    ※ 정보는 질병관리청 및 지자체 공지를 기반으로 제공됩니다.
                </small>
            </div>

            <!-- 푸터 (왼쪽 체크박스 + 오른쪽 닫기 버튼) -->
            <div class="modal-footer d-flex justify-content-between align-items-center">

                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class="custom-control-input" id="hideEpidemicToday">
                    <label class="custom-control-label" for="hideEpidemicToday">
                        오늘 하루 보지 않기
                    </label>
                </div>

                <button type="button"
                        class="btn btn-link text-muted font-weight-bold epidemic-close-btn"
                        data-dismiss="modal">
                    ×
                </button>
            </div>

        </div>
    </div>
</div>

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

<!-- Epidemic Popup Control Script -->
<script>
    (function () {

        var STORAGE_KEY = 'epidemicHideUntil';      // 오늘 하루 보지 않기
        var CLICK_KEY   = 'epidemicCardClicked';    // 카드 클릭 여부

        // 자동 팝업을 띄워도 되는지 판단
        function shouldShowEpidemicModal() {

            // 1) 카드 클릭으로 모달이 열린 경우 → 자동 팝업 방지
            if (localStorage.getItem(CLICK_KEY) === 'true') {
                localStorage.removeItem(CLICK_KEY);
                return false;
            }

            // 2) 오늘 하루 보지 않기 체크 여부 확인
            var stored = localStorage.getItem(STORAGE_KEY);
            if (!stored) return true;

            var hideUntil = new Date(stored);
            var now = new Date();

            // hideUntil이 지났으면 다시 팝업 띄움
            return now > hideUntil;
        }

        // 오늘 하루 보지 않기 저장 (내일 0시까지)
        function hideEpidemicForToday() {
            var now = new Date();
            var tomorrow = new Date(
                    now.getFullYear(),
                    now.getMonth(),
                    now.getDate() + 1,
                    0, 0, 0, 0
            );

            localStorage.setItem(STORAGE_KEY, tomorrow.toISOString());
        }

        $(function () {

            // ★ 카드 클릭인 경우(모달 직접 열기) 자동 팝업 막기
            $('.epidemic-card').on('click', function () {
                localStorage.setItem(CLICK_KEY, 'true');
            });

            // ★ 홈(index + center.jsp 결합) 첫 진입 시 자동 팝업
            if (shouldShowEpidemicModal()) {
                $('#epidemicModal').modal('show');
            }

            // ★ 모달 닫힐 때 오늘 하루 보지 않기 체크한 경우 저장
            $('#epidemicModal').on('hidden.bs.modal', function () {
                if ($('#hideEpidemicToday').is(':checked')) {
                    hideEpidemicForToday();
                }

                // 다음 열림을 위해 체크박스 초기화
                $('#hideEpidemicToday').prop('checked', false);
            });
        });

    })();
</script>

</body>
</html>
