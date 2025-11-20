<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container-fluid">
  <div class="row mb-3">
    <div class="col-12">
      <h3 class="font-weight-bold">고객센터 상담 관리</h3>
      <p class="text-muted">방문객이 챗봇과 대화를 시작한 뒤 상담사 연결을 요청하면 이 화면에 표시됩니다.</p>
    </div>
  </div>
  <div class="row">
    <div class="col-md-5">
      <div class="card">
        <div class="card-header bg-light">대기/진행 중 세션</div>
        <ul class="list-group list-group-flush" id="sessionList"></ul>
      </div>
    </div>
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
          <div id="adminChat" style="height:360px; overflow-y:auto; background:#f8f9fa;" class="p-3 border rounded mb-3">
            <p class="text-muted m-0">세션을 선택하면 대화가 표시됩니다.</p>
          </div>
          <div class="input-group">
            <input type="text" class="form-control" id="adminMsg" placeholder="답변 입력" disabled>
            <div class="input-group-append">
              <button class="btn btn-primary" id="sendAdminMsg" disabled>전송</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  const sessionList = document.getElementById('sessionList');
  const adminChat = document.getElementById('adminChat');
  const detailStatus = document.getElementById('detailStatus');
  const detailUser = document.getElementById('detailUser');
  const adminMsg = document.getElementById('adminMsg');
  const sendAdminMsg = document.getElementById('sendAdminMsg');
  const closeBtn = document.getElementById('closeBtn');
  let currentSession = null;

  async function fetchSessions() {
    const res = await fetch('<c:url value="/api/support/session"/>' );
    const data = await res.json();
    renderSessionList(data);
  }

  function renderSessionList(sessions) {
    sessionList.innerHTML = '';
    if (sessions.length === 0) {
      const li = document.createElement('li');
      li.className = 'list-group-item text-center text-muted';
      li.innerText = '대기 중인 상담이 없습니다.';
      sessionList.appendChild(li);
      return;
    }
    sessions.forEach(s => {
      const li = document.createElement('li');
      li.className = 'list-group-item list-group-item-action';
      li.innerHTML = `<div class="d-flex justify-content-between">`+
              `<div><strong>${s.userName}</strong><br><small>${s.contact || '연락처 미입력'}</small></div>`+
              `<span class="badge badge-${statusColor(s.status)}">${s.status}</span>`+
              `</div>`;
      li.onclick = () => loadSession(s.id);
      sessionList.appendChild(li);
    });
  }

  async function loadSession(id) {
    const res = await fetch(`<c:url value="/api/support/session"/>/${id}`);
    const data = await res.json();
    currentSession = data;
    detailStatus.innerText = data.status;
    detailStatus.className = 'badge badge-' + statusColor(data.status);
    detailUser.innerText = `${data.userName} (${data.loggedIn ? '로그인' : '비로그인'})`;
    adminMsg.disabled = false;
    sendAdminMsg.disabled = false;
    closeBtn.disabled = false;
    renderMessages(data.messages);
  }

  function renderMessages(messages) {
    adminChat.innerHTML = '';
    messages.forEach(m => {
      const wrap = document.createElement('div');
      wrap.className = m.sender === 'admin' ? 'text-right mb-2' : 'text-left mb-2';
      const bubble = document.createElement('div');
      bubble.className = m.sender === 'admin' ? 'd-inline-block bg-primary text-white p-2 rounded' : 'd-inline-block bg-light p-2 rounded';
      bubble.innerText = `[${m.timestamp}] ${m.sender.toUpperCase()}\n${m.content}`;
      wrap.appendChild(bubble);
      adminChat.appendChild(wrap);
    });
    adminChat.scrollTop = adminChat.scrollHeight;
  }

  sendAdminMsg.addEventListener('click', sendReply);
  adminMsg.addEventListener('keypress', e => { if (e.key === 'Enter') sendReply(); });
  closeBtn.addEventListener('click', async () => {
    if (!currentSession) return;
    await fetch(`<c:url value="/api/support/session"/>/${currentSession.id}/close`, { method: 'POST' });
    await loadSession(currentSession.id);
  });

  async function sendReply() {
    if (!currentSession || !adminMsg.value.trim()) return;
    await fetch(`<c:url value="/api/support/session"/>/${currentSession.id}/reply`, {
      method: 'POST',
      headers: { 'Content-Type': 'text/plain' },
      body: adminMsg.value
    });
    adminMsg.value = '';
    await loadSession(currentSession.id);
  }

  function statusColor(status) {
    switch (status) {
      case 'AGENT_REQUESTED': return 'warning';
      case 'AGENT_CONNECTED': return 'success';
      case 'CLOSED': return 'secondary';
      default: return 'info';
    }
  }

  fetchSessions();
  setInterval(fetchSessions, 8000);
</script>