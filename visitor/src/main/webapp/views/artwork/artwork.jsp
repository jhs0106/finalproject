<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="true" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>AI 작품 선물 + 시설별 스케치 컬러링</title>

    <style>
        .color-picker-wrapper {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-left: 8px;
            font-size: 12px;
            color: #777;
        }

        .color-picker-input {
            width: 26px;
            height: 26px;
            padding: 0;
            border: none;
            background: transparent;
            cursor: pointer;
        }
        /* ===== 큐레이터 / 감정 / 시설 선택 영역 ===== */
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

        /* ===== 스케치 컨테이너 ===== */
        .sketch-container {
            margin-top: 32px;
            padding: 16px;
            border-radius: 10px;
            border: 1px solid #ddd;
            background: rgba(0, 0, 0, 0.02);
        }

        .sketch-footer {
            margin-top: 12px;
            font-size: 13px;
            color: var(--text-secondary, #999);
        }

        /* ===== 시설별 스케치 컬러링 보드 ===== */
        .template-section-title {
            margin-top: 10px;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 14px;
        }

        .template-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 18px;
        }

        .template-card {
            width: 130px;
            border-radius: 10px;
            border: 1px solid #ddd;
            background: #fafafa;
            cursor: pointer;
            padding: 6px;
            box-sizing: border-box;
            transition: 0.15s;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .template-card:hover {
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        }

        .template-card.selected {
            border-color: #4a80f0;
            box-shadow: 0 0 0 2px rgba(74, 128, 240, 0.3);
        }

        .template-card img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            background: #fff;
            display: block;
        }

        .template-card span {
            margin-top: 6px;
            font-size: 12px;
            text-align: center;
        }

        .board-layout {
            display: grid;
            grid-template-columns: minmax(0, 3fr) minmax(0, 2fr);
            gap: 18px;
        }

        @media (max-width: 900px) {
            .board-layout {
                grid-template-columns: 1fr;
            }
        }

        .canvas-box {
            background: #fff;
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #ddd;
        }

        .canvas-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .canvas-header span {
            font-size: 13px;
            color: #666;
        }

        #sketch-canvas {
            width: 100%;
            height: auto;
            border-radius: 8px;
            border: 1px solid #ccc;
            background: #ffffff;
            display: block;
        }

        .tools-box {
            background: #fff;
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #ddd;
            font-size: 13px;
        }

        .section-label {
            font-weight: 600;
            margin-bottom: 6px;
            font-size: 13px;
        }

        .tool-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 8px;
            align-items: center;
        }

        .tool-btn {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            background: #f7f7f7;
            cursor: pointer;
            font-size: 12px;
        }

        .tool-btn.active {
            border-color: #4a80f0;
            background: #e3ebff;
        }

        .color-swatch {
            width: 18px;
            height: 18px;
            border-radius: 999px;
            border: 1px solid #ccc;
            cursor: pointer;
            box-sizing: border-box;
        }

        .color-swatch.active {
            border: 2px solid #4a80f0;
        }

        .brush-size-btn {
            padding: 4px 8px;
            font-size: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            cursor: pointer;
            background: #f7f7f7;
        }

        .brush-size-btn.active {
            border-color: #4a80f0;
            background: #e3ebff;
        }

        .status-bar {
            margin-top: 8px;
            font-size: 12px;
            color: #777;
        }

        .mt-4 {
            margin-top: 16px;
        }

        /* ===== 결과 이미지 영역 ===== */
        .preview-image-box {
            margin-top: 12px;
        }

        .preview-image-box .image-block {
            margin-bottom: 20px;
        }

        .preview-image-box img {
            display: block;
            width: 100%;
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            border: 1px solid #ccc;
            background: #ffffff;
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

    <!-- 1. 감성 질문 -->
    <section id="step1" class="mb-5">
        <h5 class="mb-3">1. 오늘의 감정에 어울리는 공간은 어디일까요?</h5>

        <div class="emotion-grid">
            <div class="emotion-card" onclick="chooseEmotion(this, '고요함')">고요한 곳</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '미래감')">미래적 공간</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '따뜻함')">따뜻한 실내</div>
            <div class="emotion-card" onclick="chooseEmotion(this, '활기참')">활기 넘치는 공간</div>
        </div>
    </section>

    <!-- 2. 추천 시설 + 실제 선택 -->
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

    <!-- 3. 시설별 스케치 컬러링 보드 -->
    <section id="step-sketch" class="mb-5 d-none">
        <div class="sketch-container">
            <h5 class="mb-2">3. 직접 스케치 틀을 색칠해서 작품에 섞어볼까요?</h5>
            <p style="font-size:13px; margin-bottom:10px;">
                선택한 시설에 어울리는 스케치 틀을 고른 뒤, 그 위에 색을 칠해보세요.
                이 컬러링 결과가 AI 작품 이미지에 함께 반영됩니다.
            </p>

            <div style="font-size:13px; margin-bottom:8px;">
                선택한 공간:
                <strong><span id="sketch-facility-label-text">-</span></strong>
            </div>

            <!-- 템플릿 목록 -->
            <div class="template-section-title">시설별 스케치 템플릿</div>
            <div id="template-grid" class="template-grid"></div>

            <!-- 컬러링 보드 -->
            <div class="board-layout">
                <!-- 캔버스 영역 -->
                <div class="canvas-box">
                    <div class="canvas-header">
                        <strong>컬러링 캔버스</strong>
                        <span id="selected-template-label">선택된 스케치 없음</span>
                    </div>
                    <canvas id="sketch-canvas"></canvas>
                </div>

                <!-- 도구 & 옵션 영역 -->
                <div class="tools-box">
                    <div class="section-label">도구</div>
                    <div class="tool-row" id="tool-row">
                        <button type="button" class="tool-btn active" data-tool="pen">펜</button>
                        <button type="button" class="tool-btn" data-tool="eraser">지우개</button>
                        <button type="button" class="tool-btn" data-tool="fill">채우기(페인트통)</button>
                        <button type="button" class="tool-btn" id="btn-undo">되돌리기</button>
                        <button type="button" class="tool-btn" id="btn-redo">다시하기</button>
                        <button type="button" class="tool-btn" id="btn-reset">템플릿 다시 불러오기</button>
                    </div>

                    <div class="section-label mt-4">색상</div>
                    <div class="tool-row" id="color-row"></div>

                    <div class="section-label mt-4">브러시 크기</div>
                    <div class="tool-row" id="size-row">
                        <button type="button" class="brush-size-btn active" data-size="3">얇게</button>
                        <button type="button" class="brush-size-btn" data-size="6">보통</button>
                        <button type="button" class="brush-size-btn" data-size="10">굵게</button>
                    </div>

                    <div class="status-bar">
                        <div id="status-tool">도구: 펜</div>
                        <div id="status-color">색상: #000000</div>
                    </div>
                </div>
            </div>

            <div class="sketch-footer">
                이 스케치는 AI가 생성하는 작품 이미지에 자동으로 합성됩니다.
            </div>
        </div>
    </section>

    <!-- 4. 작품 미리보기 -->
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
    // 2. 시설별 스케치 컬러링 보드 정의
    // =========================
    const CTX = '<c:url value="/"/>';
    const TEMPLATE_MAP = {
        // 미술관(박물관 역할): 이순신, 도자기, 다보탑, 석가탑
        '미술관': [
            { name: '이순신 장군 동상',     url: CTX + 'image/leesunsin.png' },
            { name: '전통 도자기',         url: CTX + 'image/dojagi.png' },
            { name: '다보탑',             url: CTX + 'image/dabo.png' },
            { name: '석가탑',             url: CTX + 'image/suckga.png' }
        ],

        // 도서관: 책장, 사서, 앉아서/서서 책 읽는 사람
        '도서관': [
            { name: '높은 책장',           url: CTX + 'image/book.png' },
            { name: '사서와 데스크',       url: CTX + 'image/sasu.png' },
            { name: '앉아서 책 읽는 사람', url: CTX + 'image/seat_reader.png' },
            { name: '서서 책 읽는 사람',   url: CTX + 'image/standing_reader_square.png' } // ← 실제 파일명으로
        ],
        // 아직 스케치 파일이 없으므로 비워두기 (에러 방지)
        '카페': [],
        '테마파크': []
    };

    const templateGrid = document.getElementById('template-grid');
    const selectedTemplateLabel = document.getElementById('selected-template-label');
    const sketchFacilityLabel = document.getElementById('sketch-facility-label-text');

    const canvas = document.getElementById('sketch-canvas');
    const ctx = canvas.getContext('2d');

    const toolButtons = document.querySelectorAll('.tool-btn');
    const colorRow = document.getElementById('color-row');
    const sizeButtons = document.querySelectorAll('.brush-size-btn');

    const btnUndo = document.getElementById('btn-undo');
    const btnRedo = document.getElementById('btn-redo');
    const btnReset = document.getElementById('btn-reset');

    const statusTool = document.getElementById('status-tool');
    const statusColor = document.getElementById('status-color');

    let currentFacilityForSketch = null;
    let currentTemplate = null;
    let currentTool = 'pen';
    let currentColor = '#000000';
    let brushSize = 3;
    let drawing = false;
    let lastX = 0;
    let lastY = 0;

    let history = [];
    let historyStep = -1;
    let templateImageObj = null;
    let canvasInitialized = false;
    let lastSketchPreview = null;   // generateArtwork에서 사용

    function initCanvasIfNeeded() {
        if (canvasInitialized) return;

        const rect = canvas.getBoundingClientRect();
        let width = rect.width;
        if (!width || width === 0) {
            width = canvas.parentElement ? canvas.parentElement.clientWidth : 600;
        }
        canvas.width = width;
        canvas.height = 500;
        fillWhite();
        saveState();
        canvasInitialized = true;
    }

    function fillWhite() {
        ctx.save();
        ctx.globalCompositeOperation = 'source-over';
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.restore();
    }

    function setSketchFacility(facilityName) {
        currentFacilityForSketch = facilityName;
        if (sketchFacilityLabel) {
            sketchFacilityLabel.textContent = facilityName;
        }

        renderTemplates(facilityName);
        currentTemplate = null;
        templateImageObj = null;
        selectedTemplateLabel.textContent = '선택된 스케치 없음';
    }

    function renderTemplates(facility) {
        templateGrid.innerHTML = '';
        const list = TEMPLATE_MAP[facility] || [];

        if (list.length === 0) {
            templateGrid.innerHTML =
                '<div style="font-size:13px;color:#999;">등록된 스케치 템플릿이 없습니다.</div>';
            return;
        }

        list.forEach(tpl => {
            const card = document.createElement('div');
            card.className = 'template-card';
            card.setAttribute('data-url', tpl.url);

            const img = document.createElement('img');
            img.src = tpl.url;
            img.alt = tpl.name;

            const label = document.createElement('span');
            label.textContent = tpl.name;

            card.appendChild(img);
            card.appendChild(label);

            card.addEventListener('click', () => {
                document.querySelectorAll('.template-card')
                    .forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');

                currentTemplate = tpl;
                selectedTemplateLabel.textContent = '선택된 스케치: ' + tpl.name;
                loadTemplateToCanvas(tpl.url);
            });

            templateGrid.appendChild(card);
        });
    }

    function loadTemplateToCanvas(url) {
        initCanvasIfNeeded();

        const img = new Image();
        img.onload = function () {
            templateImageObj = img;

            fillWhite();

            const cw = canvas.width;
            const ch = canvas.height;
            const iw = img.width;
            const ih = img.height;

            const scale = Math.min(cw / iw, ch / ih) * 0.9; // 여백 10%
            const drawW = iw * scale;
            const drawH = ih * scale;
            const dx = (cw - drawW) / 2;
            const dy = (ch - drawH) / 2;

            ctx.save();
            ctx.drawImage(img, dx, dy, drawW, drawH);
            ctx.restore();

            saveState();
        };
        img.onerror = function () {
            alert('스케치 이미지를 불러오지 못했습니다. 경로를 확인해 주세요.');
        };
        img.src = url;
    }

    // 템플릿 다시 불러오기
    btnReset.addEventListener('click', () => {
        initCanvasIfNeeded();
        if (templateImageObj) {
            loadTemplateToCanvas(templateImageObj.src);
        } else {
            fillWhite();
            saveState();
        }
    });

    // ===== 도구 선택 =====
    toolButtons.forEach(btn => {
        const tool = btn.getAttribute('data-tool');
        if (!tool) return; // undo/redo/reset 버튼은 제외

        btn.addEventListener('click', () => {
            toolButtons.forEach(b => {
                const t = b.getAttribute('data-tool');
                if (t) b.classList.remove('active');
            });
            btn.classList.add('active');
            setTool(tool);
        });
    });

    function setTool(tool) {
        currentTool = tool;
        const nameMap = {
            pen: '펜',
            eraser: '지우개',
            fill: '채우기(페인트통)'
        };
        statusTool.textContent = '도구: ' + (nameMap[tool] || tool);
    }

    // ==============================
    // 5-1. 색상 팔레트 + 직접 선택
    // ==============================
    const colorList = [
        '#000000',
        '#ff6b6b',
        '#4dabf7',
        '#51cf66',
        '#ffd43b',
        '#9b5de5',
        '#ff922b',
        '#ffffff'
    ];

    // 공통으로 현재 색 설정하는 함수
    function applyColor(newColor, activeSwatch) {
        currentColor = newColor;
        statusColor.textContent = '색상: ' + newColor;

        // 스와치 active 표시 갱신
        document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
        if (activeSwatch) {
            activeSwatch.classList.add('active');
        }
    }

    // 1) 기본 색상 스와치들 만들기
    colorList.forEach((c, idx) => {
        const sw = document.createElement('div');
        sw.className = 'color-swatch';
        sw.style.background = c;
        sw.dataset.color = c;

        if (idx === 0) {
            sw.classList.add('active');
            currentColor = c;
            statusColor.textContent = '색상: ' + c;
        }

        sw.addEventListener('click', () => {
            applyColor(c, sw);
        });

        colorRow.appendChild(sw);
    });

    // 2) 사용자 지정 색상 선택기 추가 (스와치 옆에)
    const pickerWrapper = document.createElement('div');
    pickerWrapper.className = 'color-picker-wrapper';

    const pickerLabel = document.createElement('span');
    pickerLabel.textContent = '직접 선택';

    const pickerInput = document.createElement('input');
    pickerInput.type = 'color';
    pickerInput.value = currentColor || '#000000';
    pickerInput.className = 'color-picker-input';

    pickerInput.addEventListener('input', () => {
        // 컬러피커 선택 시엔 스와치 active는 모두 해제
        applyColor(pickerInput.value, null);
    });

    pickerWrapper.appendChild(pickerLabel);
    pickerWrapper.appendChild(pickerInput);
    colorRow.appendChild(pickerWrapper);


    // ===== 캔버스 그리기 / 채우기 =====
    function getPos(e) {
        const rect = canvas.getBoundingClientRect();
        let x, y;
        if (e.touches && e.touches[0]) {
            x = e.touches[0].clientX - rect.left;
            y = e.touches[0].clientY - rect.top;
        } else {
            x = e.clientX - rect.left;
            y = e.clientY - rect.top;
        }
        return { x, y };
    }

    function startDrawing(e) {
        e.preventDefault();
        initCanvasIfNeeded();
        const { x, y } = getPos(e);

        if (currentTool === 'fill') {
            floodFill(x, y, currentColor);
            saveState();
            return;
        }

        drawing = true;
        lastX = x;
        lastY = y;
    }

    function draw(e) {
        if (!drawing) return;
        e.preventDefault();
        const { x, y } = getPos(e);

        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        ctx.lineWidth = brushSize;

        if (currentTool === 'pen') {
            ctx.strokeStyle = currentColor;
            ctx.globalCompositeOperation = 'source-over';
        } else if (currentTool === 'eraser') {
            ctx.strokeStyle = '#ffffff';
            ctx.globalCompositeOperation = 'source-over';
        } else {
            return;
        }

        ctx.beginPath();
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.stroke();

        lastX = x;
        lastY = y;
    }

    function endDrawing(e) {
        if (!drawing) return;
        drawing = false;
        saveState();
    }

    canvas.addEventListener('mousedown', startDrawing);
    canvas.addEventListener('mousemove', draw);
    canvas.addEventListener('mouseup', endDrawing);
    canvas.addEventListener('mouseleave', endDrawing);

    canvas.addEventListener('touchstart', startDrawing, { passive: false });
    canvas.addEventListener('touchmove', draw, { passive: false });
    canvas.addEventListener('touchend', endDrawing, { passive: false });

    // ===== Flood Fill =====
    function hexToRgba(hex) {
        hex = hex.replace('#', '');
        if (hex.length === 3) {
            hex = hex.split('').map(c => c + c).join('');
        }
        const r = parseInt(hex.substring(0, 2), 16);
        const g = parseInt(hex.substring(2, 4), 16);
        const b = parseInt(hex.substring(4, 6), 16);
        return { r, g, b, a: 255 };
    }

    function floodFill(startX, startY, fillHex) {
        const { r: fillR, g: fillG, b: fillB, a: fillA } = hexToRgba(fillHex);

        const imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const data = imgData.data;
        const w = imgData.width;
        const h = imgData.height;

        const x0 = Math.floor(startX);
        const y0 = Math.floor(startY);
        if (x0 < 0 || x0 >= w || y0 < 0 || y0 >= h) return;

        const i0 = (y0 * w + x0) * 4;
        const targetR = data[i0];
        const targetG = data[i0 + 1];
        const targetB = data[i0 + 2];
        const targetA = data[i0 + 3];

        if (targetR === fillR && targetG === fillG &&
            targetB === fillB && targetA === fillA) {
            return;
        }

        const stack = [];
        stack.push({ x: x0, y: y0 });

        while (stack.length > 0) {
            const { x, y } = stack.pop();
            if (x < 0 || x >= w || y < 0 || y >= h) continue;

            const idx = (y * w + x) * 4;
            const r = data[idx];
            const g = data[idx + 1];
            const b = data[idx + 2];
            const a = data[idx + 3];

            if (r === targetR && g === targetG &&
                b === targetB && a === targetA) {
                data[idx] = fillR;
                data[idx + 1] = fillG;
                data[idx + 2] = fillB;
                data[idx + 3] = fillA;

                stack.push({ x: x + 1, y: y });
                stack.push({ x: x - 1, y: y });
                stack.push({ x: x,     y: y + 1 });
                stack.push({ x: x,     y: y - 1 });
            }
        }

        ctx.putImageData(imgData, 0, 0);
    }

    // ===== Undo / Redo =====
    function saveState() {
        if (!canvasInitialized) return;
        const dataUrl = canvas.toDataURL('image/png');
        history = history.slice(0, historyStep + 1);
        history.push(dataUrl);
        historyStep = history.length - 1;
    }

    function restoreFromDataUrl(dataUrl) {
        const img = new Image();
        img.onload = function () {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
        };
        img.src = dataUrl;
    }

    btnUndo.addEventListener('click', () => {
        if (historyStep <= 0) return;
        historyStep--;
        restoreFromDataUrl(history[historyStep]);
    });

    btnRedo.addEventListener('click', () => {
        if (historyStep >= history.length - 1) return;
        historyStep++;
        restoreFromDataUrl(history[historyStep]);
    });

    // =========================
    // 3. 시설 선택 시 보드 열기
    // =========================
    function selectFacility(el) {
        document.querySelectorAll('.facility-card')
            .forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');

        selectedFacility = el.innerText.trim();

        const previewBox = document.getElementById('preview-box');
        previewBox.innerHTML =
            '<strong>선택한 공간:</strong> ' + selectedFacility + '<br>작품 생성 준비 중...';

        document.getElementById('step3').classList.remove('d-none');
        document.getElementById('generate-btn').classList.remove('d-none');
        document.getElementById('step-sketch').classList.remove('d-none');

        setSketchFacility(selectedFacility);
        initCanvasIfNeeded();
    }

    // =========================
    // 4. 작품 생성 요청
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

        let sketchBase64 = null;
        if (canvasInitialized) {
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
                sketchBase64: sketchBase64
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
                const serverImageBase64 = data.imageBase64;

                let html = '';
                html += '<h5>작품 설명</h5>';
                html += '<p>' + artworkDescription + '</p>';

                html += '<h5>큐레이터 코멘트</h5>';
                html += '<p>' + curatorComment + '</p>';

                html += '<h5>전시 작가 노트</h5>';
                html += '<p>' + exhibitionNote + '</p>';

                html += '<div class="preview-image-box">';

                // 1) 내가 그린 스케치
                if (lastSketchPreview) {
                    const sketchSrc = lastSketchPreview;
                    const sketchFileName = 'sketch-' + Date.now() + '.png';

                    html += '<div class="image-block">';
                    html += '  <div class="d-flex justify-content-between align-items-center mb-2">';
                    html += '    <span style="font-weight:bold;">내가 색칠한 스케치</span>';
                    html += '    <a href="' + sketchSrc + '" download="' + sketchFileName + '"';
                    html += '       class="btn btn-sm btn-outline-secondary">Download</a>';
                    html += '  </div>';
                    html += '  <img src="' + sketchSrc + '" alt="사용자 스케치">';
                    html += '</div>';
                }

                // 2) AI가 완성한 이미지
                if (serverImageBase64) {
                    const aiSrc = 'data:image/png;base64,' + serverImageBase64;
                    const aiFileName = 'ai-art-' + Date.now() + '.png';

                    html += '<div class="image-block">';
                    html += '  <div class="d-flex justify-content-between align-items-center mb-2">';
                    html += '    <span style="font-weight:bold;">AI가 완성한 이미지</span>';
                    html += '    <a href="' + aiSrc + '" download="' + aiFileName + '"';
                    html += '       class="btn btn-sm btn-outline-secondary">Download</a>';
                    html += '  </div>';
                    html += '  <img src="' + aiSrc + '" alt="AI 작품 이미지">';
                    html += '</div>';
                }

                html += '</div>'; // .preview-image-box

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
