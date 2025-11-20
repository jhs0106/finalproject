<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/map.css'/>">

<section class="map-hero">
    <div class="map-hero__content">
        <p class="map-hero__eyebrow">Visitor Location Experience</p>
        <h1 class="map-hero__title">위치 기반 경로 시각화</h1>
        <p class="map-hero__desc">
            국립중앙박물관을 기준으로 구현된 방문자 길찾기 화면입니다.
            AI가 안전한 동선과 한산한 구역을 실시간으로 추천해드립니다.
        </p>
        <div class="map-hero__actions">
            <button type="button" class="btn btn-primary btn-lg" id="mockMapClick">
                지도 탐색 시작하기
            </button>
            <button type="button" class="btn btn-secondary" id="scrollToRoutes">추천 동선 보기</button>
        </div>
    </div>
    <div class="map-hero__illustration">
        <div class="pulse"></div>
        <div class="pulse delay"></div>
        <div class="hero-card">
            <p class="hero-card__title">실시간 혼잡도</p>
            <p class="hero-card__value" id="heroCrowdValue" data-crowd-level="">-</p>
            <p class="hero-card__hint">AI 기반 예측</p>
        </div>
    </div>
</section>

<section class="map-layout" id="mapSection">
    <div class="map-panel">
        <div class="map-panel__header">
            <div>
                <p class="map-panel__eyebrow">AI Assisted Map</p>
                <h2>국립중앙박물관 실내 맵</h2>
                <p class="map-panel__sub">구역을 클릭하거나 경로 카드를 선택하면 지도에 표시됩니다.</p>
            </div>
            <button type="button" class="btn btn-outline btn-sm" id="resetSelection">선택 초기화</button>
        </div>
        <div class="map-panel__selector" role="tablist" aria-label="경로 선택 방식">
            <button type="button" class="selector-btn is-active" data-selection-mode="route" role="tab" aria-selected="true">
                추천 경로 카드
                <span>AI 스코어 기반</span>
            </button>
            <button type="button" class="selector-btn" data-selection-mode="facility" role="tab" aria-selected="false">
                시설별 보기
                <span>편의시설 기준</span>
            </button>
        </div>
        <p class="map-mobile-hint">위 탭에서 경로 또는 편의시설 기준 보기를 선택할 수 있습니다.</p>
        <div class="map-panel__toolbar">
            <div class="toolbar-toggle">
                <label>
                    <input type="checkbox" id="mobilityToggle">
                    <span>휠체어·유모차 접근 동선 우선</span>
                </label>
                <label>
                    <input type="checkbox" id="calmToggle" checked>
                    <span>한산 구역 우선</span>
                </label>
            </div>
            <p class="toolbar-hint">필터를 조정하면 지도와 추천 카드가 동시에 업데이트됩니다.</p>
        </div>
        <div class="map-panel__body">
            <div class="map-canvas" id="mapCanvas" data-kakao-app-key="cfa3949fa12f1fde8c2bb2ca997d439a">
                <div class="map-canvas__kakao" id="kakaoMap" aria-label="카카오 지도"></div>
                <div class="map-api-bridge" data-map-api-bridge aria-live="polite"></div>
                <div class="map-canvas__badge" id="mapSelectionBadge">경로를 선택해주세요</div>
                <div class="map-canvas__status" id="mapStatusMessage" aria-live="polite">지도를 불러오는 중...</div>
                <div class="map-canvas__legend">
                    <span>●</span> 안전 동선 &nbsp;|&nbsp; <span class="legend-secondary">●</span> 한산 구역
                </div>
            </div>
            <div class="sr-only" id="mapLiveRegion" aria-live="polite"></div>
        </div>
        <div class="map-mobile-card" id="mapMobileCard" aria-live="polite">
            <p class="map-mobile-card__eyebrow">모바일 요약</p>
            <h3 class="map-mobile-card__title" id="mapMobileRoute">경로를 선택해주세요</h3>
            <p class="map-mobile-card__desc" id="mapMobileDesc">
                추천 카드에서 경로를 선택하면 상세 안내가 표시됩니다.
            </p>
            <div class="map-mobile-card__chips">
                <span class="map-mobile-card__chip" id="mapMobilePrimaryChip">대기 중</span>
                <span class="map-mobile-card__chip is-muted" id="mapMobileSecondaryChip">AI 추천</span>
            </div>
            <div class="map-mobile-card__meta">
                <div>
                    <p class="map-mobile-card__label">예상 소요 시간</p>
                    <p class="map-mobile-card__value" id="mapMobileEta">-</p>
                </div>
                <div>
                    <p class="map-mobile-card__label">혼잡도 지수</p>
                    <p class="map-mobile-card__value" id="mapMobileCrowd">-</p>
                </div>
            </div>
            <p class="map-mobile-card__note" id="mapMobileNote">지도를 불러오는 중...</p>
        </div>
        <div class="map-panel__footer">
            <div class="map-stats">
                <div>
                    <p class="map-stats__label">현재 선택된 경로</p>
                    <p class="map-stats__value" id="selectedZone" aria-live="polite">없음</p>
                </div>
                <div>
                    <p class="map-stats__label">예상 소요 시간</p>
                    <p class="map-stats__value" id="selectedEta" aria-live="polite">-</p>
                </div>
                <div>
                    <p class="map-stats__label">혼잡도 지수</p>
                    <p class="map-stats__value" id="selectedCrowd" aria-live="polite">-</p>
                </div>
            </div>
        </div>
    </div>

    <div class="side-panel">
        <article class="panel-card" id="routesPanel" data-panel="routes">
            <header>
                <p class="panel-card__eyebrow">AI Recommendation</p>
                <h3>안전 동선 &amp; 한산 구역 추천</h3>
                <p class="panel-card__desc">AI가 혼잡도와 접근성을 분석하여 최적의 경로를 추천합니다.</p>
            </header>
            <div class="route-card-list" data-route-list></div>
            <div class="route-details" data-route-details>
                <p>카드에서 경로를 선택하면 상세 정보가 표시됩니다.</p>
            </div>
        </article>

        <article class="panel-card" data-panel="facility">
            <header>
                <p class="panel-card__eyebrow">Facility Filters</p>
                <h3>편의시설 경로</h3>
            </header>
            <div class="facility-filters" data-facility-filters>
                <label><input type="checkbox" value="kids" checked> 키즈존</label>
                <label><input type="checkbox" value="nursing" checked> 수유실</label>
                <label><input type="checkbox" value="wheelchair" checked> 휠체어 보관함</label>
                <label><input type="checkbox" value="rest" checked> 휴식 라운지</label>
            </div>
            <div class="filter-extended">
                <label class="filter-extended__search">
                    <span class="sr-only">편의시설 검색</span>
                    <input type="search" id="facilitySearch" placeholder="시설 이름 검색" autocomplete="off">
                </label>
                <div class="filter-extended__range">
                    <label for="crowdThreshold">허용 혼잡도</label>
                    <input type="range" id="crowdThreshold" min="20" max="100" value="80" step="5">
                    <span id="crowdThresholdValue">혼잡도 80 이하</span>
                </div>
            </div>
            <ul class="facility-list" data-facility-list></ul>
            <p class="facility-hint">시설을 클릭하면 해당 경로가 지도에 표시됩니다.</p>
        </article>
    </div>
</section>

<section class="realtime-panel" id="predictionSection">
    <header>
        <div>
            <p class="realtime-panel__eyebrow">Live Prediction</p>
            <h2>현재 위치 기반 소요 시간 &amp; 혼잡도 예측</h2>
            <p>AI가 실시간 센서 데이터를 분석하여 최적의 이동 경로를 제안합니다.</p>
        </div>
        <div class="realtime-panel__actions">
            <button type="button" class="btn btn-primary btn-lg" id="refreshRealtime">정보 새로고침</button>
            <p class="realtime-panel__timestamp">마지막 업데이트: <span id="realtimeTimestamp">-</span></p>
        </div>
    </header>
    <div class="realtime-grid">
        <div class="realtime-card">
            <p class="realtime-card__label">현재 위치</p>
            <p class="realtime-card__value" id="currentLocation">-</p>
            <p class="realtime-card__hint">GPS 기반 위치 추적</p>
        </div>
        <div class="realtime-card">
            <p class="realtime-card__label">예상 소요 시간</p>
            <p class="realtime-card__value" id="currentEta">-</p>
            <p class="realtime-card__hint">AI 추천 동선 기준</p>
        </div>
        <div class="realtime-card">
            <p class="realtime-card__label">혼잡도 예측</p>
            <p class="realtime-card__value" id="currentCrowd" data-crowd-level="">-</p>
            <p class="realtime-card__hint">0(여유) ~ 100(매우 혼잡)</p>
        </div>
        <div class="realtime-card">
            <p class="realtime-card__label">대체 경로 제안</p>
            <p class="realtime-card__value" id="alternateRoute">-</p>
            <p class="realtime-card__hint">혼잡 시 우회 경로</p>
        </div>
    </div>
</section>

<script src="<c:url value='/js/map.js'/>"></script>
