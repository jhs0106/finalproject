<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>AI 작품 선물 + 스케치</title>

    <style>
        /* ===== 기존 큐레이터 영역 스타일 ===== */
        .curator-box {
            background: transparent;
            border-left: 4px solid #6582ff;
            color: var(--text-primary, #222);
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
            background: transparent;
            text-align: center;
            transition: 0.2s;
            font-size: 15px;
            user-select: none;
            border: 1px solid #ccc;
        }

        .emotion-card:hover, .facility-card:hover {
            opacity: 0.85;
        }

        .selected {
            border: 2px solid #4a80f0;
            background: rgba(116, 144, 228, 0.1);
            color: inherit;
        }

        .preview-panel {
            min-height: 160px;
            border: 1px solid var(--border-color, #d1d1d1);
            background: transparent;
            white-space: pre-line;
        }

        .recommended-box {
            border: 1px dashed #4a80f0;
            background: rgba(74, 128, 240, 0.03);
        }

        /* ===== 스케치 영역 스타일 ===== */
        .sketch-container {
            margin-top: 32px;
            padding: 16px;
            border-radius: 10px;
            border: 1px solid #ddd;
            background: rgba(0, 0, 0, 0.02);
        }

        .sketch-toolbar {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            margin-bottom: 12px;
        }

        .color-btn, .size-btn, .tool-btn {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            background: #f5f5f5;
            cursor: pointer;
            font-size: 13px;
        }

        .color-btn.active,
        .size-btn.active,
        .tool-btn.active {
            border-color: #4a80f0;
            background: #e3ebff;
        }

        .color-circle {
            display: inline-block;
            width: 14px;
            height: 14px;
            border-radius: 50%;
            margin-right: 4px;
            vertical-align: middle;
        }

        /* ★ 여기에서는 width/height를 캔버스 내부 해상도랑 안 어긋나게 최소한만 지정 */
        #sketch-canvas {
            border: 1px solid #ccc;
            border-radius: 8px;
            background: #ffffff;
            display: block;
            width: 100%;   /* 화면 폭에 맞추되 */
            /* height는 JS에서 고정값(예: 300)으로 설정 -> CSS로는 지정 X */
        }

        .sketch-footer {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
        }

        .sketch-footer-left {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .sketch-footer-right {
            display: flex;
            gap: 6px;
        }

        .preview-image-box {
            margin-top: 12px;
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
        }

        .preview-image-box img {
            max-width: 260px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<div class="container mt-5 pt-4" style="max-width: 900px;">

    <!-- 0. AI 큐레이터 인사말 -->
    <div class="mb-4 p-3 rounded curator-box">
        <strong>AI 큐레이터:</strong>
        <span id="curator-text">오늘의 감정을 바탕으로 어울리는 공간을 찾아볼까요?</span>
    </div>

    <!-- 1. 감성 질문 흐름 -->
    <section id="step1" class="mb-5">
        <h5 class="mb-3">1. 오늘의 감정에 어울리는 공간은 어디일까요?</h5>

        <div class="emotion-grid">
            <div class="emotion-card" onclick="chooseEmotion(this, '고요함')">고요한 곳</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '미래감')">미래적 공간</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '따뜻함')">따뜻한 실내</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '활기참')">활기 넘치는 공간</div>
        </div>
    </section>

    <!-- 2. 자동 추천된 시설 + 실제 선택 -->
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

    <!-- 2-1. 직접 스케치해서 작품에 섞기 -->
    <section id="step-sketch" class="mb-5 d-none">
        <div class="sketch-container">
            <h5 class="mb-2">3. 직접 스케치해서 작품에 섞어볼까요?</h5>
            <p style="font-size:13px; margin-bottom:10px;">
                간단하게 선을 그려서 오늘의 작품에 당신의 손길을 더해보세요. 선택하면 이 스케치가 함께 전송됩니다.
            </p>

            <!-- 툴바 -->
            <div class="sketch-toolbar">

                <!-- 색상 선택 -->
                <span style="font-size:13px;">색상:</span>
                <button type="button" class="color-btn active" data-color="#000000">
                    <span class="color-circle" style="background:#000000;"></span>검정
                </button>
                <button type="button" class="color-btn" data-color="#ff6b6b">
                    <span class="color-circle" style="background:#ff6b6b;"></span>레드
                </button>
                <button type="button" class="color-btn" data-color="#4dabf7">
                    <span class="color-circle" style="background:#4dabf7;"></span>블루
                </button>
                <button type="button" class="color-btn" data-color="#51cf66">
                    <span class="color-circle" style="background:#51cf66;"></span>그린
                </button>
                <button type="button" class="color-btn" data-color="#ffd43b">
                    <span class="color-circle" style="background:#ffd43b;"></span>옐로우
                </button>

                <!-- 브러시 굵기 -->
                <span style="font-size:13px; margin-left:10px;">굵기:</span>
                <button type="button" class="size-btn active" data-size="3">얇게</button>
                <button type="button" class="size-btn" data-size="6">보통</button>
                <button type="button" class="size-btn" data-size="10">굵게</button>

                <!-- 도구 -->
                <button type="button" class="tool-btn" id="eraser-btn" style="margin-left:auto;">지우개</button>
                <button type="button" class="tool-btn" id="clear-btn">전체 지우기</button>
            </div>

            <!-- 스케치 캔버스 -->
            <canvas id="sketch-canvas"></canvas>

            <!-- 체크박스 -->
            <div class="sketch-footer">
                <div class="sketch-footer-left">
                    <input type="checkbox" id="use-sketch">
                    <label for="use-sketch">이 스케치를 작품에 함께 보내기</label>
                </div>
            </div>
        </div>
    </section>

    <!-- 3. 작품 미리보기 -->
    <section id="step3" class="mb-4 d-none">
        <h5 class="mb-3">4. 생성된 작품 미리보기</h5>

        <div id="preview-box" class="p-4 rounded preview-panel">
            작품을 생성하면 이곳에 표시됩니다.
        </div>
    </section>

    <!-- 생성 버튼 -->
    <button id="generate-btn"
            class="btn btn-primary px-4 d-none"
            onclick="generateArtwork()">
        작품 생성하기
    </button>

</div>

<script>
    // =========================
    // 1. 감정/공간 선택 관련
    // =========================
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
        document.querySelectorAll('.emotion-card')
            .forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');

        selectedEmotion = emotion;
        matchedFacility = emotionToFacility[emotion];

        document.getElementById('recommended-place').innerText = matchedFacility;
        document.getElementById('curator-text').innerText =
            '"' + emotion + '"이라는 느낌을 선택하셨군요. 그 감성에는 \'' + matchedFacility + '\'이 잘 어울립니다.';
        document.getElementById('step2').classList.remove('d-none');
    }

    // =========================
    // 2. 스케치 캔버스 관련
    // =========================
    const canvas = document.getElementById('sketch-canvas');
    const ctx = canvas.getContext('2d');
    let canvasInitialized = false;

    function initCanvasSize() {
        if (canvasInitialized) return;

        const rect = canvas.getBoundingClientRect();
        if (rect.width === 0) return; // 아직 안 보이면 스킵

        canvas.width = rect.width; // 내부 해상도 = 실제 폭
        canvas.height = 300;       // 고정 높이

        // 흰 배경으로 한번 채워두기 (다크모드에서도 잘 보이게)
        fillWhiteBackground();

        canvasInitialized = true;
    }

    // 캔버스를 흰색으로 채우는 헬퍼 (배경 고정용)
    function fillWhiteBackground() {
        ctx.save();
        ctx.globalCompositeOperation = 'source-over';
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.restore();
    }

    let drawing = false;
    let lastX = 0;
    let lastY = 0;
    let currentColor = '#000000';
    let currentSize = 3;
    let isEraser = false;
    let lastSketchPreview = null; // generate 후 미리보기에서 사용

    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';

    function startDraw(x, y) {
        drawing = true;
        lastX = x;
        lastY = y;
    }

    function drawLine(x, y) {
        if (!drawing) return;

        ctx.globalCompositeOperation = 'source-over';

        // 지우개일 때는 투명으로 지우지 말고 "흰색"으로 칠해서 지우기
        if (isEraser) {
            ctx.strokeStyle = '#ffffff';
        } else {
            ctx.strokeStyle = currentColor;
        }

        ctx.lineWidth = currentSize;

        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.stroke();

        lastX = x;
        lastY = y;
    }

    function endDraw() {
        drawing = false;
    }

    // 마우스 이벤트 (offsetX/offsetY 사용)
    canvas.addEventListener('mousedown', (e) => {
        initCanvasSize(); // 혹시 아직 초기화 안 됐으면 여기서도 한 번 보장
        startDraw(e.offsetX, e.offsetY);
    });

    canvas.addEventListener('mousemove', (e) => {
        drawLine(e.offsetX, e.offsetY);
    });

    canvas.addEventListener('mouseup', endDraw);
    canvas.addEventListener('mouseleave', endDraw);

    // 터치 이벤트
    canvas.addEventListener('touchstart', (e) => {
        e.preventDefault();
        initCanvasSize();
        const rect = canvas.getBoundingClientRect();
        const touch = e.touches[0];
        startDraw(touch.clientX - rect.left, touch.clientY - rect.top);
    }, { passive: false });

    canvas.addEventListener('touchmove', (e) => {
        e.preventDefault();
        const rect = canvas.getBoundingClientRect();
        const touch = e.touches[0];
        drawLine(touch.clientX - rect.left, touch.clientY - rect.top);
    }, { passive: false });

    canvas.addEventListener('touchend', (e) => {
        e.preventDefault();
        endDraw();
    }, { passive: false });

    // 색상 선택
    document.querySelectorAll('.color-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.color-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            currentColor = btn.getAttribute('data-color');
            isEraser = false;
            document.getElementById('eraser-btn').classList.remove('active');
        });
    });

    // 브러시 굵기 선택
    document.querySelectorAll('.size-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            currentSize = parseInt(btn.getAttribute('data-size'), 10);
        });
    });

    // 지우개
    const eraserBtn = document.getElementById('eraser-btn');
    eraserBtn.addEventListener('click', () => {
        isEraser = !isEraser;
        if (isEraser) {
            eraserBtn.classList.add('active');
        } else {
            eraserBtn.classList.remove('active');
        }
    });

    // 전체 지우기 (투명 클리어 대신 흰 배경으로 다시 채우기)
    document.getElementById('clear-btn').addEventListener('click', () => {
        fillWhiteBackground();
    });

    // 시설 선택 시 스케치 섹션 열고 캔버스 크기 초기화
    function selectFacility(el) {
        document.querySelectorAll('.facility-card')
            .forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');

        selectedFacility = el.innerText;

        document.getElementById('preview-box').innerHTML =
            '<strong>선택한 공간:</strong> ' + selectedFacility + '<br>작품 생성 준비 중...';

        document.getElementById('step3').classList.remove('d-none');
        document.getElementById('generate-btn').classList.remove('d-none');
        document.getElementById('step-sketch').classList.remove('d-none'); // 스케치 영역도 함께 오픈

        // 이 시점에 실제 폭이 정해졌으니 한번만 캔버스 해상도 맞추기
        initCanvasSize();
    }

    // =========================
    // 3. 작품 생성 요청
    // =========================
    function generateArtwork() {
        if (!selectedEmotion || !selectedFacility) {
            alert('감정과 공간을 모두 선택해주세요.');
            return;
        }

        const previewBox = document.getElementById('preview-box');

        previewBox.innerHTML =
            '<div>AI가 작품을 스케치하는 중입니다...<br>' +
            '<small>빛과 온도를 섞어 공간을 형상화하는 중...</small></div>';

        // 스케치 사용 여부와 base64 추출
        let sketchBase64 = null;
        const useSketch = document.getElementById('use-sketch')?.checked;
        if (useSketch && canvasInitialized) {
            sketchBase64 = canvas.toDataURL('image/png');
            lastSketchPreview = sketchBase64;
        } else {
            lastSketchPreview = null;
        }

        fetch('<c:url value="/api/artwork/generate"/>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                emotion: selectedEmotion,
                facility: selectedFacility,
                sketchBase64: sketchBase64   // 새 필드
            })
        })
            .then(res => {
                console.log('[artwork] res status =', res.status);
                if (!res.ok) {
                    throw new Error('HTTP error ' + res.status);
                }
                return res.json();
            })
            .then(data => {
                console.log('[artwork] response json =', data);

                const artworkDescription = data.artworkDescription || '(작품 설명 없음)';
                const curatorComment    = data.curatorComment || '(큐레이터 코멘트 없음)';
                const exhibitionNote    = data.exhibitionNote || '(전시 노트 없음)';
                const serverImageBase64 = data.imageBase64; // 서버에서 채워줄 수 있는 이미지 base64

                let html = '';
                html += '<h5>작품 설명</h5>';
                html += '<p>' + artworkDescription + '</p>';

                html += '<h5>큐레이터 코멘트</h5>';
                html += '<p>' + curatorComment + '</p>';

                html += '<h5>전시 작가 노트</h5>';
                html += '<p>' + exhibitionNote + '</p>';

                // 이미지 미리보기 영역
                html += '<div class="preview-image-box">';

                if (lastSketchPreview) {
                    html += '<div>';
                    html += '<div style="font-weight:bold; margin-bottom:4px;">내가 그린 스케치</div>';
                    html += '<img src="' + lastSketchPreview + '" alt="사용자 스케치">';
                    html += '</div>';
                }

                if (serverImageBase64) {
                    html += '<div>';
                    html += '<div style="font-weight:bold; margin-bottom:4px;">AI가 완성한 이미지</div>';
                    html += '<img src="data:image/png;base64,' + serverImageBase64 + '" alt="AI 작품 이미지">';
                    html += '</div>';
                }

                html += '</div>';

                previewBox.innerHTML = html;
            })
            .catch(err => {
                console.error('[artwork] fetch or render error:', err);
                previewBox.innerHTML =
                    '<p style="color:red;">클라이언트에서 응답 처리 중 오류가 발생했습니다.</p>';
            });
    }
</script>

</body>
</html>
