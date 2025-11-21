<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 1) 스타일 영역 -->
<style>
  #adminChat {
    height: 360px;
    overflow-y: auto;
    background: #f8f9fa;
  }
</style>

<!-- 2) 스크립트 영역 -->
<script>
  document.addEventListener('DOMContentLoaded', () => {
    // ===== DOM 요소 캐시 =====
    const sessionList   = document.getElementById('sessionList');
    const adminChat     = document.getElementById('adminChat');
    const detailStatus  = document.getElementById('detailStatus');
    const detailUser    = document.getElementById('detailUser');
    const adminMsg      = document.getElementById('adminMsg');
    const sendAdminMsg  = document.getElementById('sendAdminMsg');
    const closeBtn      = document.getElementById('closeBtn');

    let currentSession = null;
    let listSource = null;
    let sessionSource = null;

    // API 기본 URL (JSP에서 서버 URL만 주입)
    const SESSION_BASE_URL = '<c:url value="/api/support/session"/>';

    // ===== 상태별 배지 색상 매핑 (JS 함수) =====
    function statusColor(status) {
      switch (status) {
        case 'AGENT_REQUESTED': return 'warning';   // 상담사 요청
        case 'AGENT_CONNECTED': return 'success';   // 상담사 연결됨
        case 'CLOSED':          return 'secondary'; // 종료됨
        default:                return 'info';      // 그 외 상태
      }
    }

    // ===== 세션 목록 조회 =====
    function connectSessionListStream() {
      if (listSource) {
        listSource.close();
      }
      listSource = new EventSource(SESSION_BASE_URL + '/stream');
      listSource.addEventListener('sessions', (event) => {
        try {
          const sessions = JSON.parse(event.data);
          renderSessionList(sessions);
        } catch (e) {
          console.warn('세션 목록 이벤트 파싱 실패', e);
        }
      });
      listSource.onerror = () => {
        console.warn('세션 목록 스트림 오류, 5초 후 재연결');
        setTimeout(connectSessionListStream, 5000);
      };
    }
    // ===== 세션 목록 렌더링 =====
    function renderSessionList(sessions) {
      sessionList.innerHTML = '';

      if (!sessions || sessions.length === 0) {
        const li = document.createElement('li');
        li.className = 'list-group-item text-center text-muted';
        li.innerText = '대기 중인 상담이 없습니다.';
        sessionList.appendChild(li);
        return;
      }

      sessions.forEach(s => {
        const li = document.createElement('li');
        li.className = 'list-group-item list-group-item-action';
        li.innerHTML =
                '<div class="d-flex justify-content-between">' +
                '<div>' +
                '<strong>' + s.userName + '</strong><br>' +
                '<small>' + (s.contact || '연락처 미입력') + '</small>' +
                '</div>' +
                '<span class="badge badge-' + statusColor(s.status) + '">' +
                s.status +
                '</span>' +
                '</div>';

        li.onclick = () => loadSession(s.id);
        sessionList.appendChild(li);
      });
    }

    // ===== 단일 세션 로드 =====
    async function loadSession(id) {
      const res = await fetch(SESSION_BASE_URL + '/' + id);
      const data = await res.json();

      currentSession = data;

      if (sessionSource) {
        sessionSource.close();
      }
      sessionSource = new EventSource(SESSION_BASE_URL + '/' + id + '/stream');
      sessionSource.addEventListener('session', (event) => {
        try {
          const session = JSON.parse(event.data);
          currentSession = session;
          detailStatus.innerText = session.status;
          detailStatus.className = 'badge badge-' + statusColor(session.status);
          detailUser.innerText = session.userName + ' (' + (session.loggedIn ? '로그인' : '비로그인') + ')';
          renderMessages(session.messages);
        } catch (e) {
          console.warn('세션 이벤트 파싱 실패', e);
        }
      });
      sessionSource.onerror = () => {
        console.warn('세션 스트림 오류, 5초 후 재연결');
        setTimeout(() => loadSession(id), 5000);
      };

      // 상태/사용자 영역 갱신
      detailStatus.innerText = data.status;
      detailStatus.className = 'badge badge-' + statusColor(data.status);
      detailUser.innerText = data.userName + ' (' + (data.loggedIn ? '로그인' : '비로그인') + ')';

      // 입력 가능 상태로 전환
      adminMsg.disabled = false;
      sendAdminMsg.disabled = false;
      closeBtn.disabled = false;

      renderMessages(data.messages);
    }

    // ===== 메시지 렌더링 =====
    function renderMessages(messages) {
      adminChat.innerHTML = '';

      (messages || []).forEach(m => {
        const wrap = document.createElement('div');
        wrap.className = (m.sender === 'admin' ? 'text-right mb-2' : 'text-left mb-2');

        const bubble = document.createElement('div');
        bubble.className =
                (m.sender === 'admin'
                        ? 'd-inline-block bg-primary text-white p-2 rounded'
                        : 'd-inline-block bg-light p-2 rounded');

        bubble.innerText =
                '[' + m.timestamp + '] ' +
                m.sender.toUpperCase() + '\n' +
                m.content;

        wrap.appendChild(bubble);
        adminChat.appendChild(wrap);
      });

      adminChat.scrollTop = adminChat.scrollHeight;
    }

    // ===== 상담 종료 요청 =====
    closeBtn.addEventListener('click', async () => {
      if (!currentSession) return;

      await fetch(SESSION_BASE_URL + '/' + currentSession.id + '/close', {
        method: 'POST'
      });

      // 종료 후 세션 내용 갱신
      await loadSession(currentSession.id);
    });

    // ===== 관리자 답변 전송 =====
    async function sendReply() {
      if (!currentSession || !adminMsg.value.trim()) return;

      await fetch(SESSION_BASE_URL + '/' + currentSession.id + '/reply', {
        method: 'POST',
        headers: { 'Content-Type': 'text/plain' },
        body: adminMsg.value
      });

      adminMsg.value = '';
      await loadSession(currentSession.id);
    }

    sendAdminMsg.addEventListener('click', sendReply);
    adminMsg.addEventListener('keypress', e => {
      if (e.key === 'Enter') {
        sendReply();
      }
    });

    // ===== 최초 로드 + 주기적 새로고침 =====
      connectSessionListStream();
  });
</script>

<!-- 3) 마크업 영역 -->
<div class="container-fluid">
  <div class="row mb-3">
    <div class="col-12">
      <h3 class="font-weight-bold">고객센터 상담 관리</h3>
      <p class="text-muted">
        방문객이 챗봇과 대화를 시작한 뒤 상담사 연결을 요청하면 이 화면에 표시됩니다.
      </p>
    </div>
  </div>

  <div class="row">
    <!-- 세션 목록 -->
    <div class="col-md-5">
      <div class="card">
        <div class="card-header bg-light">대기/진행 중 세션</div>
        <ul class="list-group list-group-flush" id="sessionList"></ul>
      </div>
    </div>

    <!-- 세션 상세/대화 영역 -->
    <div class="col-md-7">
      <div class="card h-100">
        <div class="card-header d-flex justify-content-between align-items-center">
          <div>
            <span class="badge badge-primary" id="detailStatus">선택되지 않음</span>
            <span class="ml-2" id="detailUser"></span>
          </div>
          <button class="btn btn-outline-secondary btn-sm" id="closeBtn" disabled>종료</button>
        </div>
        <div class="card-body">
          <div id="adminChat" class="p-3 border rounded mb-3">
            <p class="text-muted m-0">세션을 선택하면 대화가 표시됩니다.</p>
          </div>
          <div class="input-group">
            <input type="text"
                   class="form-control"
                   id="adminMsg"
                   placeholder="답변 입력"
                   disabled>
            <div class="input-group-append">
              <button class="btn btn-primary" id="sendAdminMsg" disabled>전송</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
