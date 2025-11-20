<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<div class="main-container">
  <div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
      <div class="page-header">
        <div class="row">
          <div class="col-md-12 col-sm-12">
            <div class="title">
              <h4>CCTV 실시간 모니터링</h4>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="ai-analysis-card">
            <div class="ai-analysis-header">
              <h5 class="mb-1">AI 재난 감지 상태</h5>
              <span id="ai-analysis-status" class="status waiting">연결 대기 중...</span>
            </div>
            <p id="ai-analysis-detail" class="ai-analysis-detail">
              CCTV와 연결되면 30초마다 분석 결과가 이곳에 표시됩니다.
            </p>
            <ul id="ai-analysis-history" class="ai-analysis-history placeholder">
              <li>아직 수신된 분석 결과가 없습니다.</li>
            </ul>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="card-box p-0" style="position: relative; background: #000; border-radius: 20px; overflow: hidden; display: flex; justify-content: center; align-items: center; min-height: 480px;">

            <video id="remoteVideo" autoplay playsinline controls
                   style="width: 100%; max-width: 860px; height: auto; max-height: 480px; object-fit: contain;">
            </video>

            <div style="position: absolute; bottom: 30px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px; z-index: 100;">
              <button id="connectBtn" class="btn btn-primary btn-lg" onclick="startMonitoring()">
                <i class="fa fa-play"></i> 서버 연결 시작
              </button>
              <button id="callBtn" class="btn btn-success btn-lg" onclick="callCamera()" style="display: none;">
                <i class="fa fa-video-camera"></i> 카메라 호출 (재시도)
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .ai-analysis-card {
    background: #101322;
    border-radius: 20px;
    padding: 24px;
    color: #f7f9ff;
    box-shadow: 0 20px 45px rgba(10, 12, 24, 0.45);
    border: 1px solid rgba(255,255,255,0.05);
    margin-bottom: 20px;
  }
  .ai-analysis-header { display: flex; align-items: center; justify-content: space-between; gap: 16px; }
  .ai-analysis-detail { margin-bottom: 12px; color: rgba(255,255,255,0.75); font-size: 1rem; }

  .ai-analysis-history { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 8px; }
  .ai-analysis-history.placeholder { color: rgba(255,255,255,0.5); }
  .ai-analysis-history li { background: rgba(255,255,255,0.08); border-radius: 14px; padding: 8px 14px; font-size: 0.85rem; display: flex; gap: 10px; }
  .ai-analysis-history li .time { font-weight: 600; color: rgba(255,255,255,0.9); }

  .status { font-size: 0.9rem; padding: 6px 14px; border-radius: 999px; background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.9); font-weight: 600; }
  .status.waiting { background: rgba(255,255,255,0.12); }
  .status.safe { background: rgba(62, 201, 144, 0.15); color: #85f0c0; }
  .status.alert { background: rgba(255, 94, 94, 0.18); color: #ff9494; }
  .status.error { background: rgba(255, 173, 66, 0.2); color: #ffdd9b; }

  .text-danger { color: #ff9494 !important; }
  .text-warning { color: #ffdd9b !important; }
  .text-success { color: #85f0c0 !important; }
</style>

<script>
  (function() {
    const remoteVideo = document.getElementById('remoteVideo');
    const statusEl = document.getElementById('ai-analysis-status');
    const detailEl = document.getElementById('ai-analysis-detail');
    const historyEl = document.getElementById('ai-analysis-history');
    const connectBtn = document.getElementById('connectBtn');
    const callBtn = document.getElementById('callBtn');

    const SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.hostname + ':8444/signal';

    let socket;
    let peerConnection;
    const rtcConfig = {
      iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
    };

    // UI 업데이트 함수
    const updateStatus = (state, text, detail) => {
      statusEl.textContent = text;
      statusEl.className = `status ${state}`;
      if(detail) detailEl.textContent = detail;
    };

    const addHistory = (timeText, summary, accentClass) => {
      if (historyEl.classList.contains('placeholder')) {
        historyEl.innerHTML = '';
        historyEl.classList.remove('placeholder');
      }
      const item = document.createElement('li');
      if (accentClass) item.classList.add(accentClass);
      item.innerHTML = `<span class="time">${timeText}</span><span class="message">${summary}</span>`;
      historyEl.prepend(item);
      while (historyEl.children.length > 5) {
        historyEl.removeChild(historyEl.lastElementChild);
      }
    };

    // 1. 서버 연결 시작
    window.startMonitoring = function() {
      connectBtn.style.display = 'none';
      updateStatus('waiting', '서버 연결 시도 중...', '시그널링 서버에 접속하고 있습니다.');

      socket = new WebSocket(SIGNALING_URL);

      socket.onopen = () => {
        updateStatus('waiting', 'CCTV 호출 중...', '서버에 접속했습니다. CCTV 응답을 기다립니다.');
        callBtn.style.display = 'inline-block';
        callCamera();
      };

      socket.onmessage = async (event) => {
        const msg = JSON.parse(event.data);

        // AI 분석 결과 처리 로직
        if (msg.type === 'CCTV_ANALYSIS_RESULT') {
          handleAnalysisResult(msg.payload);
          return;
        }

        // WebRTC 신호 처리
        if (msg.type === 'offer') {
          console.log("영상 신호 수신!");
          createPeerConnection();
          await peerConnection.setRemoteDescription(new RTCSessionDescription(msg));
          const answer = await peerConnection.createAnswer();
          await peerConnection.setLocalDescription(answer);
          socket.send(JSON.stringify({ type: 'answer', sdp: answer.sdp }));
        }
        else if (msg.type === 'candidate') {
          if (peerConnection && msg.candidate) {
            await peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate));
          }
        }
      };

      socket.onclose = () => {
        updateStatus('error', '연결 끊김', '서버와의 연결이 끊어졌습니다.');
        connectBtn.style.display = 'inline-block';
        callBtn.style.display = 'none';
      };
    };

    window.callCamera = function() {
      if (socket && socket.readyState === WebSocket.OPEN) {
        socket.send(JSON.stringify({ type: 'viewer_joined' }));
      }
    };

    // [수정됨] AI 분석 결과 핸들러 (문구 수정)
    function handleAnalysisResult(payload) {
      const timestamp = payload.timestamp ? new Date(payload.timestamp) : new Date();
      const timeText = timestamp.toLocaleTimeString('ko-KR', { hour12: false });
      const severity = payload.severity || 'info';
      const message = payload.message || '상세 정보 없음';

      if (severity === 'alert') {
        updateStatus('alert', '재난 징후 감지!', `[${timeText}] 경고: ${message}`);
        addHistory(timeText, message, 'text-danger');
      } else if (severity === 'error') {
        updateStatus('error', '분석 오류', message);
        addHistory(timeText, message, 'text-warning');
      } else {
        // 여기가 수정된 부분입니다.
        updateStatus('safe', '이상 징후 없음', `최근 분석(${timeText}) : 이상 징후가 발견되지 않았습니다.`);
        addHistory(timeText, '이상 없음', 'text-success');
      }
    }

    function createPeerConnection() {
      if (peerConnection) peerConnection.close();
      peerConnection = new RTCPeerConnection(rtcConfig);

      peerConnection.ontrack = (event) => {
        remoteVideo.srcObject = event.streams[0];
        callBtn.style.display = 'none';
        if (statusEl.classList.contains('waiting')) {
          updateStatus('safe', '영상 수신 중', 'AI 분석 데이터를 기다리고 있습니다...');
        }
      };

      peerConnection.onicecandidate = (event) => {
        if (event.candidate) {
          socket.send(JSON.stringify({ type: 'candidate', candidate: event.candidate }));
        }
      };
    }
  })();
</script>