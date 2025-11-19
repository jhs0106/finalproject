<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>문화 콘텐츠 벡터 적재</title>

  <!-- 1) 스타일 영역 -->
  <style>
    /* 템플릿의 .main-container는 건드리지 않고, 내부만 별도 컨테이너로 조정 */
    .culture-container {
      padding: 20px 10px;
    }

    .culture-card {
      background: #ffffff;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
      border: 1px solid #e5e5e5;
    }

    .gap-2 > * + * {
      margin-left: 0.5rem;
    }

    .text-monospace {
      font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono",
      "Courier New", monospace;
    }

    .title.pb-20 {
      padding-bottom: 20px;
    }
  </style>

  <!-- 2) 스크립트 영역 (DOMContentLoaded 안에서 DOM 접근) -->
  <script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
      const ingestButton = document.getElementById('ingestButton');
      const lastResult = document.getElementById('lastResult');
      const ingestForm = document.getElementById('ingestForm');
      const facilityInput = document.getElementById('facilityId');
      const fileInput = document.getElementById('fileInput');
      const refreshButton = document.getElementById('refreshButton');
      const deleteFacilityButton = document.getElementById('deleteFacilityButton');
      const vectorRows = document.getElementById('vectorRows');

      // 파일 업로드 & 벡터 적재
      ingestForm.addEventListener('submit', async function (event) {
        event.preventDefault();
        if (!facilityInput.value.trim() || fileInput.files.length === 0) {
          ingestForm.classList.add('was-validated');
          return;
        }

        ingestButton.disabled = true;
        ingestButton.innerHTML =
                '<span class="spinner-border spinner-border-sm"></span> 적재 중...';

        const formData = new FormData();
        formData.append('facilityId', facilityInput.value.trim());
        formData.append('file', fileInput.files[0]);

        try {
          const res = await fetch('<c:url value="/api/culture/ingest"/>', {
            method: 'POST',
            body: formData
          });
          if (!res.ok) {
            const message = await res.text();
            throw new Error(message || '서버 오류');
          }
          const data = await res.json();

          // 템플릿 리터럴 대신 문자열 연결 (JSP EL 충돌 방지)
          lastResult.textContent =
                  '시설 ' + data.facilityId +
                  ' · ' + data.count + '건 적재' +
                  ' · ' + data.elapsedMs + 'ms' +
                  ' · 문서ID ' + data.documentId +
                  ' · ' + new Date(data.timestamp).toLocaleString();

          ingestForm.reset();
          ingestForm.classList.remove('was-validated');
          await loadVectors();
        } catch (e) {
          lastResult.textContent = '적재 실패: ' + e.message;
        } finally {
          ingestButton.disabled = false;
          ingestButton.innerHTML =
                  '<i class="icon-copy dw dw-upload2"></i> 벡터스토어에 업로드';
        }
      });

      // 목록 새로고침
      refreshButton.addEventListener('click', function () {
        loadVectors().catch(function () {
          vectorRows.innerHTML =
                  '<tr class="text-muted"><td colspan="5">조회 중 오류가 발생했습니다.</td></tr>';
        });
      });

      // 한 시설의 전체 벡터 문서 삭제
      deleteFacilityButton.addEventListener('click', async function () {
        const facilityId = facilityInput.value.trim();
        const deletingAll = !facilityId;

        const message = deletingAll
                ? '전체 시설의 벡터 문서를 모두 삭제할까요?'
                : '시설 ' + facilityId + '의 벡터 문서를 모두 삭제할까요?';
        if (!confirm(message)) {
          return;
        }
        try {
          const baseUrl = '<c:url value="/api/culture/vectors"/>';
          const targetUrl = deletingAll
                  ? baseUrl
                  : baseUrl + '?facilityId=' + encodeURIComponent(facilityId);
          const res = await fetch(targetUrl, {
            method: 'DELETE'
          });
          if (!res.ok) {
            const msg = await res.text();
            throw new Error(msg || '삭제 중 오류 발생');
          }
          const data = await res.json();
          if (deletingAll) {
            lastResult.textContent = '전체 문서 ' + data.deleted + '건 삭제 완료';
          } else {
            lastResult.textContent =
                    '시설 ' + data.facilityId + ' 문서 ' + data.deleted + '건 삭제 완료';
          }
          facilityInput.value = '';
          await loadVectors();
        } catch (e) {
          alert('삭제 실패: ' + e.message);
        }
      });

      // 벡터 문서 목록 조회
      async function loadVectors() {
        const facilityId = facilityInput.value.trim();
        const params = new URLSearchParams();
        if (facilityId) {
          params.append('facilityId', facilityId);
        }
        params.append('limit', '100');

        const baseUrl = '<c:url value="/api/culture/vectors"/>';
        const res = await fetch(baseUrl + '?' + params.toString());
        if (!res.ok) {
          throw new Error('조회 중 오류 발생');
        }
        const rows = await res.json();
        renderRows(rows);
      }

      // 테이블 렌더링
      function renderRows(rows) {
        vectorRows.innerHTML = '';
        if (!rows || rows.length === 0) {
          vectorRows.innerHTML =
                  '<tr class="text-muted"><td colspan="5">조회 결과가 없습니다.</td></tr>';
          return;
        }

        rows.forEach(function (row) {
          const tr = document.createElement('tr');

          const id = row.id || '';
          const facilityId = row.facilityId || '';
          const filename = row.filename || '';
          const preview = row.contentPreview || '';

          tr.innerHTML =
                  '<td class="text-monospace small">' + id + '</td>' +
                  '<td>' + facilityId + '</td>' +
                  '<td>' + filename + '</td>' +
                  '<td class="small text-muted">' + preview + '</td>' +
                  '<td><button class="btn btn-sm btn-outline-danger" data-id="' + id +
                  '"><i class="icon-copy dw dw-delete-3"></i></button></td>';

          const deleteButton = tr.querySelector('button');
          deleteButton.addEventListener('click', function () {
            deleteRow(id);
          });
          vectorRows.appendChild(tr);
        });
      }

      // 개별 문서 삭제
      async function deleteRow(id) {
        if (!confirm('문서 ' + id + '를 삭제할까요?')) {
          return;
        }
        const baseUrl = '<c:url value="/api/culture/vectors/"/>';
        const res = await fetch(baseUrl + encodeURIComponent(id), {method: 'DELETE'});
        if (!res.ok) {
          alert('삭제 실패');
          return;
        }
        const data = await res.json();
        lastResult.textContent = '문서 ' + data.id + ' 삭제 완료';
        await loadVectors();
      }

      // 초기 로드시 전체 목록 조회
      loadVectors().catch(function () {
        vectorRows.innerHTML =
                '<tr class="text-muted"><td colspan="5">조회 중 오류가 발생했습니다.</td></tr>';
      });
    });
  </script>

  <!-- 3) Bootstrap CSS 포함 -->
  <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous"
  >
</head>
<body>

<div class="main-container">
  <div class="culture-container">
    <div class="title pb-20 d-flex align-items-center justify-content-between">
      <h2 class="h3 mb-0">문화 콘텐츠 벡터 적재</h2>
      <small class="text-muted">시설별로 업로드한 파일만 벡터화합니다.</small>
    </div>

    <div class="alert alert-secondary" role="alert">
      시설 단위로 업로드한 원본 파일을 바로 임베딩해 PGVector에 저장합니다.
      별도의 목업 데이터는 사용하지 않으며, 업로드한 파일에
      <strong>facilityId</strong> 메타데이터를 붙여 검색 시 분리할 수 있습니다.
    </div>

    <!-- 파일 업로드 카드 -->
    <div class="culture-card mb-20">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0">파일 업로드</h5>
        <span id="lastResult" class="text-muted small">아직 적재 기록이 없습니다.</span>
      </div>

      <form id="ingestForm" class="needs-validation" novalidate>
        <div class="row">
          <div class="col-md-4 mb-3">
            <label for="facilityId" class="form-label">시설 ID</label>
            <input type="text" class="form-control" id="facilityId"
                   placeholder="ex) museum-a" required>
            <div class="invalid-feedback">시설 ID를 입력하세요.</div>
          </div>
          <div class="col-md-8 mb-3">
            <label for="fileInput" class="form-label">벡터화할 파일</label>
            <input type="file" class="form-control" id="fileInput"
                   accept=".txt,.md,.pdf" required>
            <div class="invalid-feedback">업로드할 파일을 선택하세요.</div>
          </div>
        </div>
        <button id="ingestButton" class="btn btn-primary" type="submit">
          <i class="icon-copy dw dw-upload2"></i> 벡터스토어에 업로드
        </button>
      </form>
    </div>

    <!-- 적재 이력 & 삭제 카드 -->
    <div class="culture-card mb-20">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0">적재 이력 & 삭제</h5>
        <div class="d-flex gap-2">
          <button id="refreshButton" class="btn btn-outline-secondary btn-sm" type="button">
            <i class="icon-copy dw dw-refresh1"></i> 새로고침
          </button>
          <!-- 🔴 텍스트: 시설 전체 삭제 → 전체 삭제 -->
          <button id="deleteFacilityButton" class="btn btn-outline-danger btn-sm" type="button">
            <i class="icon-copy dw dw-delete-3"></i> 전체 삭제
          </button>
        </div>
      </div>
      <p class="text-muted small mb-3">
        시설 ID를 입력한 뒤 새로고침하면 해당 시설의 벡터 문서를 조회하고,
        각 문서 또는 한 시설의 모든 벡터 문서를 삭제할 수 있습니다. 시설 ID를 비워둔 채
        <strong>전체 삭제</strong>를 누르면 벡터스토어 전체가 초기화됩니다.
      </p>
      <div class="table-responsive">
        <table class="table table-striped">
          <thead>
          <tr>
            <th scope="col">문서 ID</th>
            <th scope="col">시설</th>
            <th scope="col">파일명</th>
            <th scope="col">내용 미리보기</th>
            <th scope="col">삭제</th>
          </tr>
          </thead>
          <tbody id="vectorRows">
          <tr class="text-muted">
            <td colspan="5">조회 결과가 없습니다.</td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<!-- 4) Bootstrap JS (필요 시) -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"
></script>

</body>
</html>
