<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5 pt-4" style="max-width: 960px;">
  <div class="text-center mb-4">
    <h2 class="font-weight-bold">챗봇 / 고객센터 문의</h2>
    <p class="text-muted">로그인 여부와 관계없이 상담을 시작할 수 있습니다. 필요 시 "상담사 연결"을 요청하세요.</p>
  </div>

  <div class="card shadow-sm mb-3">
    <div class="card-body">
      <div class="form-row align-items-end">
        <div class="form-group col-md-3">
          <label>접속 상태</label>
          <select id="loginState" class="form-control">
            <option value="false">비로그인 방문객</option>
            <option value="true">로그인 사용자</option>
          </select>
        </div>
        <div class="form-group col-md-4">
          <label>이름</label>
          <input type="text" id="userName" class="form-control" placeholder="이름 또는 닉네임">
        </div>
        <div class="form-group col-md-4">
          <label>연락처 (이메일/전화)</label>
          <input type="text" id="contact" class="form-control" placeholder="답변을 받을 연락처">
        </div>
        <div class="form-group col-md-1 text-right">
          <button class="btn btn-primary w-100" id="startChatBtn">시작</button>
        </div>
      </div>
      <small class="text-muted">로그인 사용자는 입력된 정보로 자동 상담되며, 비로그인 사용자는 연락 가능한 정보를 직접 입력해주세요.</small>
    </div>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
          <span class="badge badge-info" id="sessionStatus">대기 중</span>
          <span class="text-muted" id="sessionUser"></span>
        </div>
        <button class="btn btn-outline-danger btn-sm" id="handoffBtn" disabled>상담사 연결 요청</button>
      </div>
      <div id="chatWindow" class="border rounded p-3" style="height: 360px; overflow-y: auto; background: #f8f9fa;">
        <p class="text-muted m-0">상담을 시작하면 대화가 여기에 표시됩니다.</p>
      </div>
      <div class="input-group mt-3">
        <input type="text" id="messageInput" class="form-control" placeholder="메시지를 입력하세요" disabled>
        <div class="input-group-append">
          <button class="btn btn-primary" id="sendMsgBtn" disabled>전송</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  const chatWindow = document.getElementById('chatWindow');
  const messageInput = document.getElementById('messageInput');
  const sendMsgBtn = document.getElementById('sendMsgBtn');
  const startChatBtn = document.getElementById('startChatBtn');
  const loginState = document.getElementById('loginState');
  const userNameInput = document.getElementById('userName');
  const contactInput = document.getElementById('contact');
  const sessionStatus = document.getElementById('sessionStatus');
  const sessionUser = document.getElementById('sessionUser');
  const handoffBtn = document.getElementById('handoffBtn');

  let sessionId = null;

  loginState.addEventListener('change', () => {
    if (loginState.value === 'true') {
      userNameInput.value = userNameInput.value || '로그인 이용자';
      contactInput.placeholder = '회원 연락처가 자동으로 활용됩니다';
    } else {
      contactInput.placeholder = '답변을 받을 연락처';
    }
  });

  startChatBtn.addEventListener('click', async () => {
    const payload = {
      userName: userNameInput.value,
      contact: contactInput.value,
      loggedIn: loginState.value === 'true'
    };
    const res = await fetch('<c:url value="/api/support/session"/>', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await res.json();
    sessionId = data.id;
    sessionStatus.innerText = data.status;
    sessionUser.innerText = `${data.userName} (${data.loggedIn ? '로그인' : '비로그인'})`;
    handoffBtn.disabled = false;
    messageInput.disabled = false;
    sendMsgBtn.disabled = false;
    chatWindow.innerHTML = '';
    renderMessages(data.messages);
  });

  sendMsgBtn.addEventListener('click', () => sendMessage(false));
  messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage(false);
  });
  handoffBtn.addEventListener('click', () => sendMessage(true));

  async function sendMessage(handoff) {
    if (!sessionId) return alert('먼저 상담을 시작해주세요.');
    const msg = messageInput.value.trim();
    if (!handoff && !msg) return;

    const payload = { message: msg, handoff };
    const res = await fetch(`<c:url value="/api/support/session"/>/${sessionId}/message`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await res.json();
    sessionStatus.innerText = data.status;
    renderMessages(data.messages);
    messageInput.value = '';
  }

  function renderMessages(messages) {
    chatWindow.innerHTML = '';
    messages.forEach(m => {
      const wrapper = document.createElement('div');
      wrapper.className = m.sender === 'visitor' ? 'text-right mb-2' : 'text-left mb-2';
      const bubble = document.createElement('div');
      bubble.className = m.sender === 'visitor' ? 'd-inline-block bg-primary text-white p-2 rounded' : 'd-inline-block bg-light p-2 rounded';
      bubble.innerText = `[${m.timestamp}] ${m.sender.toUpperCase()}\n${m.content}`;
      wrapper.appendChild(bubble);
      chatWindow.appendChild(wrapper);
    });
    chatWindow.scrollTop = chatWindow.scrollHeight;
  }
</script>