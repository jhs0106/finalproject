<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="main-container">
  <div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
      <div class="page-header">
        <div class="row">
          <div class="col-md-12 col-sm-12">
            <div class="title">
              <h4>CCTV 모니터링</h4>
            </div>
            <p class="text-muted">
              WebRTC 기반 IoT 장비(cctv 모듈)의 실시간 화면을 불러옵니다. 장비 서버가 실행 중인지 확인해주세요.
            </p>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="card-box p-0">
            <iframe
                    src="http://localhost:8090"
                    title="Mun'cok CCTV"
                    class="cctv-frame"
                    allow="camera; microphone; fullscreen"
            ></iframe>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-12">
          <div class="alert alert-info mt-3">
            <h5 class="mb-2">연결 방법</h5>
            <ol class="mb-0 pl-3">
              <li><code>test10/cctv</code> 모듈에서 <code>npm install</code>, <code>npm start</code>를 실행합니다. (기본 포트: <code>8090</code>)</li>
              <li>브라우저가 카메라 접근 권한을 요청하면 허용합니다.</li>
              <li>이 페이지를 새로고침하면 CCTV 프리뷰가 자동으로 나타납니다.</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .cctv-frame {
    width: 100%;
    min-height: 580px;
    border: none;
    border-radius: 20px;
    background-color: #000;
  }
</style>