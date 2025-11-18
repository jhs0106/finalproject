<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- AI 작품 생성 페이지: 감성 기반 질문 흐름 + 시설 자동 매칭 + 다크모드 대응 -->
<div class="container mt-5 pt-4" style="max-width: 900px;">

    <!-- 0. AI 큐레이터 인사말 -->
    <div class="mb-4 p-3 rounded curator-box">
        <strong>AI 큐레이터:</strong>
        <span id="curator-text">오늘의 감정을 바탕으로 어울리는 공간을 찾아볼까요?</span>
    </div>

    <!-- 1. 감성 질문 흐름 -->
    <section id="step1" class="mb-5">
        <h5 class="mb-3">1. 오늘은 어떤 장소의 느낌이 어울릴까요?</h5>

        <div class="emotion-grid">
            <div class="emotion-card" onclick="chooseEmotion(this, '고요함')">고요한 곳</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '미래감')">미래적 공간</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '따뜻함')">따뜻한 실내</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '활기참')">활기 넘치는 공간</div>
        </div>
    </section>

    <!-- 2. 자동 추천된 시설 → 실제 생성 옵션 노출 -->
    <section id="step2" class="mb-5 d-none">
        <h5 class="mb-3">2. 당신의 감성에 어울리는 공간을 추천했어요</h5>

        <div class="recommended-box rounded p-3 mb-3">
            <strong>추천 시설:</strong> <span id="recommended-place"></span>
        </div>

        <div class="d-flex flex-wrap mb-4 facility-grid">
            <div class="facility-card" onclick="selectFacility(this)">미술관</div>
            <div class="facility-card" onclick="selectFacility(this)">도서관</div>
            <div class="facility-card" onclick="selectFacility(this)">카페</div>
            <div class="facility-card" onclick="selectFacility(this)">테마파크</div>
        </div>
    </section>

    <!-- 3. 작품 미리보기 -->
    <section id="step3" class="mb-4 d-none">
        <h5 class="mb-3">3. 생성된 작품 미리보기</h5>

        <div id="preview-box" class="p-4 rounded preview-panel">
            작품을 생성하면 이곳에 표시됩니다.
        </div>
    </section>

    <!-- 생성 버튼 -->
    <button id="generate-btn" class="btn btn-primary px-4 d-none" onclick="generateArtwork()">작품 생성하기</button>

</div>

<style>
    .curator-box {
        background: var(--bg-soft, #f0f0f0);
        border-left: 4px solid #6582ff;
        color: var(--text-primary);
    }
    .emotion-grid, .facility-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 12px;
    }
    .emotion-card, .facility-card {
        padding: 18px;
        border-radius: 10px;
        cursor: pointer;
        background: var(--bg-card, #e7e9ef);
        text-align: center;
        transition: 0.2s;
        font-size: 15px;
    }
    .emotion-card:hover, .facility-card:hover {
        opacity: 0.85;
    }
    .selected {
        border: 2px solid #4a80f0;
        background: #7490e4 !important;
        color: white;
    }
    .preview-panel {
        min-height: 160px;
        border: 1px solid var(--border-color, #d1d1d1);
        background: var(--bg-panel, #fafafa);
        color: var(--text-primary);
    }
</style>

<script>
    let selectedEmotion = null;
    let matchedFacility = null;
    let selectedFacility = null;

    const emotionToFacility = {
        '고요함': '도서관',
        '미래감': '미술관',
        '따뜻함': '카페',
        '활기참': '테마파크'
    };

    function chooseEmotion(el, emotion) {
        document.querySelectorAll('.emotion-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        selectedEmotion = emotion;

        matchedFacility = emotionToFacility[emotion];
        document.getElementById('recommended-place').innerHTML = matchedFacility;
        document.getElementById('curator-text').innerHTML = `"${emotion}"이라는 느낌을 선택하셨군요. 그 감성에는 '${matchedFacility}'이 잘 어울립니다.`;

        document.getElementById('step2').classList.remove('d-none');
    }

    function selectFacility(el) {
        document.querySelectorAll('.facility-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        selectedFacility = el.innerText;

        document.getElementById('preview-box').innerHTML =
            `<strong>선택한 공간:</strong> ${selectedFacility}<br>작품 생성 준비 중...`;

        document.getElementById('step3').classList.remove('d-none');
        document.getElementById('generate-btn').classList.remove('d-none');
    }

    function generateArtwork() {
        if (!selectedFacility) {
            alert('먼저 공간을 선택해주세요!');
            return;
        }

        document.getElementById('preview-box').innerHTML = `
            <div class="loading-text">
                AI가 작품을 스케치하는 중입니다...<br>
                <small>빛과 온도를 섞어 공간을 형상화하는 중...</small>
            </div>
        `;
    }
</script>