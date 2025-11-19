<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .culture-hero {
        background: linear-gradient(135deg, #0b3d55, #0e6b76);
        color: #fff;
        border-radius: 20px;
        padding: 32px;
        margin-bottom: 24px;
    }

    .qr-preview {
        background: #0b1220;
        border-radius: 12px;
        overflow: hidden;
        min-height: 220px;
    }

    .qr-preview video {
        width: 100%;
        height: 220px;
        object-fit: cover;
    }

    .pill {
        display: inline-flex;
        align-items: center;
        padding: 6px 12px;
        border-radius: 999px;
        background: #e8f4f6;
        color: #0e6b76;
        font-weight: 600;
        margin: 4px 4px 0 0;
    }

    .section-card {
        border: 1px solid #e5e7eb;
        border-radius: 14px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        padding: 20px;
        background: #fff;
        margin-bottom: 16px;
    }

    .section-title {
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 12px;
    }

    .result-box {
        min-height: 140px;
        background: #f7fbfc;
        border: 1px dashed #c7e7ed;
        border-radius: 12px;
        padding: 14px;
    }
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    (function ($) {
        var streamRef = null;
        var cameraOn = false; // ✅ 카메라 상태 플래그

        function isMobile() {
            return /Mobi|Android|iPhone|iPad|iPod/i.test(navigator.userAgent);
        }

        // ✅ 해상도 요청 + 모바일 후면 카메라 우선
        function startCamera() {
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                $('#qrStatus').text('카메라를 사용할 수 없습니다.');
                return;
            }

            var commonVideoConfig = {
                width:  { ideal: 1280 },   // 720p 이상 권장
                height: { ideal: 720 }
            };

            var constraints;
            if (isMobile()) {
                constraints = {
                    video: Object.assign({}, commonVideoConfig, {
                        facingMode: { ideal: 'environment' }   // 모바일 후면 카메라 우선
                    })
                };
            } else {
                constraints = {
                    video: commonVideoConfig   // PC는 해상도만 지정
                };
            }

            navigator.mediaDevices.getUserMedia(constraints)
                .then(function (stream) {
                    streamRef = stream;
                    var video = document.getElementById('qrVideo');
                    if (video) {
                        video.srcObject = stream;
                        video.play();
                    }
                    cameraOn = true;
                    $('#qrStatus').text('카메라가 준비되었습니다.');
                    $('#toggleCamera')
                        .text('카메라 중지')
                        .removeClass('btn-outline-secondary')
                        .addClass('btn-outline-danger');
                })
                .catch(function () {
                    $('#qrStatus').text('카메라 접근에 실패했습니다.');
                    cameraOn = false;
                    $('#toggleCamera')
                        .text('카메라 켜기')
                        .removeClass('btn-outline-danger')
                        .addClass('btn-outline-secondary');
                });
        }

        function stopCamera() {
            if (streamRef) {
                streamRef.getTracks().forEach(function (track) { track.stop(); });
                streamRef = null;
            }
            cameraOn = false;
            $('#qrStatus').text('카메라를 중지했습니다.');
            $('#toggleCamera')
                .text('카메라 켜기')
                .removeClass('btn-outline-danger')
                .addClass('btn-outline-secondary');
        }

        function renderGuide(response) {
            var detail = response && response.guideDetail
                ? response.guideDetail
                : '해설을 불러오지 못했습니다.';
            var tips = response && response.vectorTopics ? response.vectorTopics : [];

            $('#guideResult').text(detail);

            var html = '';
            for (var i = 0; i < tips.length; i++) {
                html += '<span class="pill">' + tips[i] + '</span>';
            }
            $('#guideTopics').html(html);
        }

        function renderComparison(response) {
            var content = response && response.overview
                ? response.overview
                : '비교 결과를 불러오지 못했습니다.';
            $('#compareResult').text(content);
        }

        function speak(text) {
            if (!('speechSynthesis' in window)) {
                alert('브라우저에서 음성 안내를 지원하지 않습니다.');
                return;
            }
            window.speechSynthesis.cancel();
            var utter = new SpeechSynthesisUtterance(text);
            utter.lang = 'ko-KR';
            window.speechSynthesis.speak(utter);
        }

        $(function () {
            // 처음 로딩 시 자동으로 카메라 켬
            startCamera();

            // ✅ 토글 버튼: 중지 ↔ 켜기
            $('#toggleCamera').on('click', function () {
                if (cameraOn) {
                    // 현재 켜져 있으면 중지
                    stopCamera();
                } else {
                    // 꺼져 있으면 다시 켜기
                    $('#qrStatus').text('카메라를 준비하는 중입니다.');
                    startCamera();
                }
            });

            $('#loadGuide').on('click', function () {
                var artifactId = $('#artifactId').val();
                if (!artifactId) {
                    alert('전시물 ID를 입력하거나 QR 정보를 스캔해 주세요.');
                    return;
                }

                $.ajax({
                    url: '<c:url value="/api/culture/guide"/>',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({artifactId: artifactId})
                }).done(function (data) {
                    renderGuide(data);
                }).fail(function () {
                    renderGuide(null);
                });
            });

            $('#speakGuide').on('click', function () {
                var text = $('#guideResult').text();
                if (text) {
                    speak(text);
                }
            });

            $('#loadCompare').on('click', function () {
                var baseId = $('#baseId').val();
                var regionId = $('#regionId').val();
                if (!baseId || !regionId) {
                    alert('비교할 전시물과 지역을 선택해 주세요.');
                    return;
                }

                $.ajax({
                    url: '<c:url value="/api/culture/comparison"/>',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        artifactId: baseId,
                        comparisonRegionId: regionId
                    })
                }).done(function (data) {
                    renderComparison(data);
                }).fail(function () {
                    renderComparison(null);
                });
            });
        });
    })(jQuery);
</script>

<div class="culture-hero">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between">
        <div>
            <div class="text-uppercase mb-2"
                 style="font-weight:700;letter-spacing:1px;opacity:0.8;">AI 문화 해설</div>
            <h2 class="mb-2">QR 스캔 + RAG 해설 + 음성 안내</h2>
            <p class="mb-0">전시 앞에서 QR을 스캔하고, AI가 전시물의 배경과 주변 시대 정보를 빠르게 전달합니다.</p>
        </div>
        <div class="mt-3 mt-md-0">
            <span class="badge badge-light text-dark">모바일 후면 카메라 사용</span>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-6">
        <div class="section-card">
            <div class="section-title">QR 스캔</div>
            <div class="qr-preview mb-2">
                <video id="qrVideo" playsinline muted></video>
            </div>
            <p id="qrStatus" class="text-muted mb-2">카메라를 준비하는 중입니다.</p>
            <div class="form-group mb-2">
                <label for="artifactId" class="font-weight-bold mb-1">
                    전시물 ID (QR로 읽은 코드 입력 가능)
                </label>
                <input type="text" id="artifactId" class="form-control" placeholder="예: goryeo_celadon"/>
            </div>
            <div class="d-flex gap-2">
                <button type="button" id="loadGuide" class="btn btn-primary mr-2">
                    AI 해설 가져오기
                </button>
                <!-- ✅ 토글 버튼으로 변경 -->
                <button type="button" id="toggleCamera" class="btn btn-outline-danger">
                    카메라 중지
                </button>
            </div>
        </div>
    </div>

    <div class="col-lg-6">
        <div class="section-card">
            <div class="section-title">AI 문화 해설 (RAG)</div>
            <div id="guideTopics" class="mb-2"></div>
            <div id="guideResult" class="result-box"></div>
            <div class="mt-2 d-flex align-items-center">
                <button type="button" id="speakGuide" class="btn btn-outline-primary btn-sm mr-2">
                    <i class="fas fa-volume-up"></i> 음성 안내
                </button>
                <small class="text-muted">TTS는 브라우저 음성 합성을 사용합니다.</small>
            </div>
        </div>
    </div>
</div>

<div class="section-card">
    <div class="section-title">시대간 비교 체험</div>
    <div class="row">
        <div class="col-md-4">
            <div class="form-group">
                <label for="baseId" class="font-weight-bold">전시물</label>
                <input type="text" id="baseId" class="form-control" placeholder="예: goryeo_celadon"/>
            </div>
        </div>
        <div class="col-md-4">
            <div class="form-group">
                <label for="regionId" class="font-weight-bold">비교 지역</label>
                <input type="text" id="regionId" class="form-control" placeholder="예: song_china"/>
            </div>
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button type="button" id="loadCompare" class="btn btn-success btn-block">
                비교 결과 보기
            </button>
        </div>
    </div>
    <div id="compareResult" class="result-box"></div>
</div>
