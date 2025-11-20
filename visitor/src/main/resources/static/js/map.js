(function () {
    // 국립중앙박물관 기준 좌표
    const kakaoBaseCoord = { lat: 37.523984, lng: 126.980355 };

    // 구역 데이터 - 카카오 지도 폴리곤용 (실제 위경도)
    const zones = [
        {
            id: 'lobby',
            label: '중앙 로비',
            path: [
                { lat: 37.524284, lng: 126.979855 },
                { lat: 37.524284, lng: 126.980855 },
                { lat: 37.523784, lng: 126.980855 },
                { lat: 37.523784, lng: 126.979855 }
            ],
            color: '#0fadb0',
            type: 'safe'
        },
        {
            id: 'media',
            label: '미디어홀',
            path: [
                { lat: 37.524484, lng: 126.980955 },
                { lat: 37.524484, lng: 126.981655 },
                { lat: 37.523884, lng: 126.981655 },
                { lat: 37.523884, lng: 126.980955 }
            ],
            color: '#0fadb0',
            type: 'safe'
        },
        {
            id: 'family',
            label: '패밀리 라운지',
            path: [
                { lat: 37.523684, lng: 126.980955 },
                { lat: 37.523684, lng: 126.981655 },
                { lat: 37.523184, lng: 126.981655 },
                { lat: 37.523184, lng: 126.980955 }
            ],
            color: '#2e7d5b',
            type: 'relaxed'
        },
        {
            id: 'kids',
            label: '키즈존',
            path: [
                { lat: 37.523684, lng: 126.979555 },
                { lat: 37.523684, lng: 126.980455 },
                { lat: 37.523084, lng: 126.980455 },
                { lat: 37.523084, lng: 126.979555 }
            ],
            color: '#2e7d5b',
            type: 'relaxed'
        }
    ];

    // 경로 데이터
    const routes = [
        {
            id: 'routeA',
            title: '전시관 A → 패밀리 라운지',
            eta: '8분',
            crowd: 32,
            score: '안전도 4.7 / 5',
            status: '안전 동선',
            color: '#38bdf8',
            distance: '210m',
            zone: 'family',
            supportsMobility: true,
            tags: ['패밀리', 'AI 추천'],
            reason: '센서 기반 혼잡도 32, 패밀리 시설까지 경사로 포함',
            confidence: 0.94,
            steps: ['전시관 A 중앙 로비', '안내데스크 우측 복도', '패밀리 라운지'],
            path: [
                { lat: 37.523384, lng: 126.979755 },
                { lat: 37.523484, lng: 126.980355 },
                { lat: 37.523434, lng: 126.981055 },
                { lat: 37.523434, lng: 126.981305 }
            ]
        },
        {
            id: 'routeB',
            title: '키즈존 → 수유실',
            eta: '5분',
            crowd: 20,
            score: '한산도 4.9 / 5',
            status: '한산 구역',
            color: '#4ade80',
            distance: '140m',
            zone: 'kids',
            supportsMobility: true,
            tags: ['키즈', '엘리베이터'],
            reason: '엘리베이터 구간 확보, 키즈존 혼잡도 20 유지',
            confidence: 0.9,
            steps: ['키즈존 북측 출구', '에스컬레이터 B', '패밀리 케어 수유실'],
            path: [
                { lat: 37.523384, lng: 126.980005 },
                { lat: 37.523584, lng: 126.980355 },
                { lat: 37.523634, lng: 126.980755 },
                { lat: 37.523534, lng: 126.981205 }
            ]
        },
        {
            id: 'routeC',
            title: '휠체어 보관함 → 미디어홀',
            eta: '11분',
            crowd: 56,
            score: '안전도 4.2 / 5',
            status: '우회 권장',
            color: '#f97316',
            distance: '260m',
            zone: 'media',
            supportsMobility: true,
            tags: ['보조 동선', '경사로'],
            reason: '보안 게이트 앞 혼잡도 56으로 우회 권장',
            confidence: 0.82,
            steps: ['휠체어 보관존', '보안 게이트 통과', '미디어홀 입구'],
            path: [
                { lat: 37.523284, lng: 126.981305 },
                { lat: 37.523584, lng: 126.981105 },
                { lat: 37.523884, lng: 126.981005 },
                { lat: 37.524184, lng: 126.981305 }
            ]
        },
        {
            id: 'routeD',
            title: '야외 정원 → 중앙 로비',
            eta: '7분',
            crowd: 28,
            score: '한산도 4.6 / 5',
            status: '한산 구역',
            color: '#c084fc',
            distance: '190m',
            zone: 'lobby',
            supportsMobility: false,
            tags: ['야외', '뷰포인트'],
            reason: '야외 구간 혼잡도 28, 로비 진입 혼선 없음',
            confidence: 0.88,
            steps: ['야외 정원 연결통로', '중앙홀 수직 이동 동선', '중앙 로비'],
            path: [
                { lat: 37.524484, lng: 126.979555 },
                { lat: 37.524284, lng: 126.979855 },
                { lat: 37.524084, lng: 126.980155 },
                { lat: 37.524034, lng: 126.980355 }
            ]
        }
    ];

    // 편의시설 데이터
    const facilities = [
        {
            id: 'kids-1',
            type: 'kids',
            label: '키즈존',
            description: '영유아 체험 존',
            distance: '120m',
            coords: { lat: 37.523384, lng: 126.980005 },
            route: 'routeB',
            crowd: 22
        },
        {
            id: 'nursing-1',
            type: 'nursing',
            label: '패밀리 수유실',
            description: '개별 수유 부스 3개',
            distance: '180m',
            coords: { lat: 37.523434, lng: 126.981305 },
            route: 'routeB',
            crowd: 18
        },
        {
            id: 'wheelchair-1',
            type: 'wheelchair',
            label: '휠체어 보관함',
            description: '보관 락커 12기',
            distance: '90m',
            coords: { lat: 37.523284, lng: 126.981305 },
            route: 'routeC',
            crowd: 48
        },
        {
            id: 'rest-1',
            type: 'rest',
            label: '패밀리 라운지',
            description: '소형 카페 & 휴게석',
            distance: '210m',
            coords: { lat: 37.523434, lng: 126.981105 },
            route: 'routeA',
            crowd: 30
        }
    ];

    const facilityIcons = {
        kids: '🧒',
        nursing: '🍼',
        wheelchair: '♿',
        rest: '☕'
    };

    const routeMap = new Map(routes.map(route => [route.id, route]));
    const altRoutes = ['북측 회랑 우회', '중앙홀 수직 이동 동선', '야외 정원 연결통로'];

    // 카카오 지도 관련 상태
    let kakaoMap = null;
    let kakaoReady = false;
    let kakaoLoaderPromise = null;
    let kakaoPolyline = null;
    let kakaoZonePolygons = [];
    let kakaoMarkers = [];
    let kakaoFacilityMarkers = [];

    // DOM 요소
    const els = {
        routeList: document.querySelector('[data-route-list]'),
        routeDetails: document.querySelector('[data-route-details]'),
        facilityList: document.querySelector('[data-facility-list]'),
        facilityFilters: document.querySelector('[data-facility-filters]'),
        selectedZone: document.getElementById('selectedZone'),
        selectedEta: document.getElementById('selectedEta'),
        selectedCrowd: document.getElementById('selectedCrowd'),
        mapCanvas: document.getElementById('mapCanvas'),
        heroCrowd: document.getElementById('heroCrowdValue'),
        currentLocation: document.getElementById('currentLocation'),
        currentEta: document.getElementById('currentEta'),
        currentCrowd: document.getElementById('currentCrowd'),
        alternateRoute: document.getElementById('alternateRoute'),
        mapBadge: document.getElementById('mapSelectionBadge'),
        mapStatus: document.getElementById('mapStatusMessage'),
        mapLiveRegion: document.getElementById('mapLiveRegion'),
        mobileCard: document.getElementById('mapMobileCard'),
        mobileRoute: document.getElementById('mapMobileRoute'),
        mobileDesc: document.getElementById('mapMobileDesc'),
        mobileEta: document.getElementById('mapMobileEta'),
        mobileCrowd: document.getElementById('mapMobileCrowd'),
        mobilePrimaryChip: document.getElementById('mapMobilePrimaryChip'),
        mobileSecondaryChip: document.getElementById('mapMobileSecondaryChip'),
        mobileNote: document.getElementById('mapMobileNote'),
        facilitySearch: document.getElementById('facilitySearch'),
        crowdSlider: document.getElementById('crowdThreshold'),
        crowdValue: document.getElementById('crowdThresholdValue'),
        mobilityToggle: document.getElementById('mobilityToggle'),
        calmToggle: document.getElementById('calmToggle'),
        realtimeTimestamp: document.getElementById('realtimeTimestamp'),
        selectionButtons: document.querySelectorAll('[data-selection-mode]'),
        routePanel: document.querySelector('[data-panel="routes"]'),
        facilityPanel: document.querySelector('[data-panel="facility"]'),
        apiBridge: document.querySelector('[data-map-api-bridge]')
    };

    if (!els.routeList || !els.mapCanvas) return;

    // 앱 상태
    const state = {
        selectedRoute: null,
        previewRoute: null,
        filters: new Set(['kids', 'nursing', 'wheelchair', 'rest']),
        facilityQuery: '',
        crowdThreshold: 80,
        calmMode: true,
        mobilityMode: false,
        selectionMode: 'route'
    };

    // 혼잡도 레벨
    const crowdPalette = [
        { level: 'low', max: 25, label: '여유' },
        { level: 'moderate', max: 50, label: '보통' },
        { level: 'busy', max: 75, label: '혼잡' },
        { level: 'heavy', max: Infinity, label: '매우 혼잡' }
    ];

    function getCrowdLevel(crowd) {
        return crowdPalette.find(scale => crowd <= scale.max)?.level || 'moderate';
    }

    function getCrowdLabel(level) {
        return crowdPalette.find(scale => scale.level === level)?.label || '보통';
    }

    function buildCrowdBadge(crowd) {
        const level = getCrowdLevel(crowd);
        const label = getCrowdLabel(level);
        return `<span class="crowd-badge crowd-badge--${level}" aria-label="혼잡도 ${crowd} (${label})"><span class="crowd-badge__dot"></span>${label} · ${crowd}</span>`;
    }

    // 카카오 지도 API 키 가져오기
    function getKakaoAppKey() {
        return els.mapCanvas?.dataset.kakaoAppKey || '';
    }

    // 카카오 SDK 로드
    function loadKakaoSdk() {
        if (typeof window !== 'undefined' && window.kakao?.maps) {
            return Promise.resolve();
        }
        if (kakaoLoaderPromise) return kakaoLoaderPromise;

        kakaoLoaderPromise = new Promise((resolve, reject) => {
            const appKey = getKakaoAppKey();
            if (!appKey) {
                reject(new Error('카카오 API 키가 설정되지 않았습니다.'));
                return;
            }

            const script = document.createElement('script');
            script.src = `//dapi.kakao.com/v2/maps/sdk.js?autoload=false&appkey=${encodeURIComponent(appKey)}`;
            script.async = true;
            script.onload = () => {
                if (window.kakao?.maps) {
                    kakao.maps.load(() => resolve());
                } else {
                    reject(new Error('카카오 지도 SDK 로드에 실패했습니다.'));
                }
            };
            script.onerror = () => reject(new Error('카카오 지도 SDK를 불러오지 못했습니다.'));
            document.head.appendChild(script);
        });

        return kakaoLoaderPromise;
    }

    // 구역 폴리곤 렌더링
    function renderZonePolygons() {
        if (!kakaoReady || !kakaoMap) return;

        // 기존 폴리곤 제거
        kakaoZonePolygons.forEach(polygon => polygon.setMap(null));
        kakaoZonePolygons = [];

        zones.forEach(zone => {
            const path = zone.path.map(p => new kakao.maps.LatLng(p.lat, p.lng));

            const polygon = new kakao.maps.Polygon({
                map: kakaoMap,
                path: path,
                strokeWeight: 2,
                strokeColor: zone.color,
                strokeOpacity: 0.8,
                strokeStyle: 'solid',
                fillColor: zone.color,
                fillOpacity: 0.15
            });

            // 마우스 오버 이벤트
            kakao.maps.event.addListener(polygon, 'mouseover', function() {
                polygon.setOptions({
                    fillOpacity: 0.35,
                    strokeWeight: 3
                });
            });

            kakao.maps.event.addListener(polygon, 'mouseout', function() {
                polygon.setOptions({
                    fillOpacity: 0.15,
                    strokeWeight: 2
                });
            });

            // 클릭 이벤트 - 해당 구역과 연결된 경로 선택
            kakao.maps.event.addListener(polygon, 'click', function() {
                const relatedRoute = routes.find(r => r.zone === zone.id);
                if (relatedRoute) {
                    selectRoute(relatedRoute.id);
                }
            });

            // 구역 라벨 표시
            const bounds = new kakao.maps.LatLngBounds();
            path.forEach(p => bounds.extend(p));
            const center = bounds.getCenter();

            const content = `<div style="padding: 5px 10px; background: rgba(255,255,255,0.9); border-radius: 8px; font-size: 12px; font-weight: 600; border: 1px solid ${zone.color}; color: #111827;">${zone.label}</div>`;

            const customOverlay = new kakao.maps.CustomOverlay({
                position: center,
                content: content,
                yAnchor: 0.5
            });
            customOverlay.setMap(kakaoMap);

            kakaoZonePolygons.push(polygon);
        });
    }

    // 경로 폴리라인 렌더링
    function renderKakaoRoute(route) {
        if (!kakaoReady || !kakaoMap) return;

        // 기존 경로 제거
        if (kakaoPolyline) {
            kakaoPolyline.setMap(null);
            kakaoPolyline = null;
        }
        kakaoMarkers.forEach(marker => marker.setMap(null));
        kakaoMarkers = [];

        if (!route) return;

        const path = route.path.map(p => new kakao.maps.LatLng(p.lat, p.lng));

        kakaoPolyline = new kakao.maps.Polyline({
            map: kakaoMap,
            path: path,
            strokeWeight: 5,
            strokeColor: route.color,
            strokeOpacity: 0.9,
            strokeStyle: 'solid'
        });

        // 시작/끝 마커
        const startMarkerContent = `<div style="padding: 8px 12px; background: ${route.color}; color: white; border-radius: 20px; font-size: 11px; font-weight: 600; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">출발</div>`;
        const endMarkerContent = `<div style="padding: 8px 12px; background: ${route.color}; color: white; border-radius: 20px; font-size: 11px; font-weight: 600; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">도착</div>`;

        const startOverlay = new kakao.maps.CustomOverlay({
            position: path[0],
            content: startMarkerContent,
            yAnchor: 1.3
        });
        startOverlay.setMap(kakaoMap);

        const endOverlay = new kakao.maps.CustomOverlay({
            position: path[path.length - 1],
            content: endMarkerContent,
            yAnchor: 1.3
        });
        endOverlay.setMap(kakaoMap);

        kakaoMarkers.push(startOverlay, endOverlay);

        // 경로가 보이도록 지도 범위 조정
        const bounds = new kakao.maps.LatLngBounds();
        path.forEach(p => bounds.extend(p));
        kakaoMap.setBounds(bounds, 50);
    }

    // 편의시설 마커 렌더링
    function renderKakaoFacilities(list) {
        if (!kakaoReady || !kakaoMap) return;

        // 기존 마커 제거
        kakaoFacilityMarkers.forEach(marker => marker.setMap(null));
        kakaoFacilityMarkers = [];

        list.forEach(facility => {
            const position = new kakao.maps.LatLng(facility.coords.lat, facility.coords.lng);
            const icon = facilityIcons[facility.type] || '●';
            const crowdLevel = getCrowdLevel(facility.crowd);

            let bgColor = '#0fadb0';
            if (crowdLevel === 'busy') bgColor = '#f97316';
            if (crowdLevel === 'heavy') bgColor = '#ef4444';

            const content = `
                <div style="
                    padding: 8px 12px;
                    background: ${bgColor};
                    color: white;
                    border-radius: 12px;
                    font-size: 14px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: 6px;
                " data-facility-id="${facility.id}">
                    <span>${icon}</span>
                    <span style="font-weight: 600;">${facility.label}</span>
                </div>
            `;

            const overlay = new kakao.maps.CustomOverlay({
                position: position,
                content: content,
                yAnchor: 0.5
            });
            overlay.setMap(kakaoMap);

            // 클릭 이벤트는 DOM에서 처리
            setTimeout(() => {
                const el = document.querySelector(`[data-facility-id="${facility.id}"]`);
                if (el) {
                    el.addEventListener('click', () => selectRoute(facility.route));
                }
            }, 100);

            kakaoFacilityMarkers.push(overlay);
        });

        // 시설이 있으면 해당 영역으로 이동
        if (list.length > 0) {
            const bounds = new kakao.maps.LatLngBounds();
            list.forEach(f => bounds.extend(new kakao.maps.LatLng(f.coords.lat, f.coords.lng)));
            kakaoMap.setBounds(bounds, 80);
        }
    }

    // 카카오 지도 초기화
    function initKakaoMap() {
        if (kakaoMap) return;

        const container = document.getElementById('kakaoMap');
        if (!container) return;

        loadKakaoSdk()
                .then(() => {
                    kakaoMap = new kakao.maps.Map(container, {
                        center: new kakao.maps.LatLng(kakaoBaseCoord.lat, kakaoBaseCoord.lng),
                        level: 3
                    });

                    // 지도 컨트롤 추가
                    const zoomControl = new kakao.maps.ZoomControl();
                    kakaoMap.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                    kakaoReady = true;
                    setMapStatus('지도가 로드되었습니다. 구역을 클릭하거나 경로를 선택해주세요.');

                    // 구역 폴리곤 렌더링
                    renderZonePolygons();

                    // 초기 경로 표시 (선택된 경로가 있다면)
                    if (state.selectedRoute) {
                        renderKakaoRoute(routeMap.get(state.selectedRoute));
                    }
                })
                .catch(error => {
                    console.error(error);
                    setMapStatus('지도를 불러오지 못했습니다. API 키를 확인해주세요.');
                });
    }

    // 경로 카드 생성
    function createRouteCard(route) {
        const card = document.createElement('button');
        card.type = 'button';
        card.className = 'route-card';
        card.dataset.routeId = route.id;
        card.style.borderLeftColor = route.color;
        card.innerHTML = `
            <p class="route-card__title">${route.title}</p>
            <div class="route-card__meta">
                <span>${route.status}</span>
                <span>${route.eta}</span>
                <span>${route.distance}</span>
                ${buildCrowdBadge(route.crowd)}
            </div>
            <p class="route-card__score">${route.score}</p>
            <div class="route-card__tags">
                ${route.tags.map(tag => `<span class="route-card__tag">${tag}</span>`).join('')}
            </div>
        `;
        card.addEventListener('click', () => selectRoute(route.id));
        card.addEventListener('mouseenter', () => {
            if (state.selectedRoute !== route.id) {
                renderKakaoRoute(route);
            }
        });
        card.addEventListener('mouseleave', () => {
            if (state.selectedRoute !== route.id) {
                renderKakaoRoute(state.selectedRoute ? routeMap.get(state.selectedRoute) : null);
            }
        });
        return card;
    }

    // 필터에 맞는 경로 반환
    function getVisibleRoutes() {
        return routes.filter(route => {
            const meetsCalm = !state.calmMode || route.crowd <= state.crowdThreshold;
            const meetsMobility = !state.mobilityMode || route.supportsMobility;
            return meetsCalm && meetsMobility;
        });
    }

    // 경로 목록 렌더링
    function renderRoutes() {
        const visibleRoutes = getVisibleRoutes();
        els.routeList.innerHTML = '';

        if (!visibleRoutes.length) {
            els.routeList.innerHTML = '<p class="route-empty">조건에 맞는 경로가 없습니다. 필터를 조정해 주세요.</p>';
            state.selectedRoute = null;
            renderRouteDetails(null);
            updateStats();
            renderKakaoRoute(null);
            setMapStatus('조건에 맞는 경로를 찾지 못했습니다.');
            return;
        }

        visibleRoutes.forEach(route => {
            const card = createRouteCard(route);
            if (state.selectedRoute === route.id) card.classList.add('active');
            els.routeList.appendChild(card);
        });

        // 선택된 경로가 필터에서 제외되었으면 초기화
        if (state.selectedRoute && !visibleRoutes.some(r => r.id === state.selectedRoute)) {
            state.selectedRoute = null;
        }

        const activeRoute = routeMap.get(state.selectedRoute) || null;
        renderRouteDetails(activeRoute);
        updateStats(state.selectedRoute);

        if (state.selectionMode === 'route') {
            renderKakaoRoute(activeRoute);
        }

        if (state.selectedRoute) {
            setMapStatus(`${visibleRoutes.length}개의 경로 중 "${activeRoute?.title}"이 선택되었습니다.`);
        } else {
            setMapStatus(`${visibleRoutes.length}개의 경로가 있습니다. 원하는 경로를 선택해주세요.`);
        }
    }

    // 경로 상세 정보 렌더링
    function renderRouteDetails(route) {
        if (!route) {
            els.routeDetails.innerHTML = '<p>카드에서 경로를 선택하면 상세 정보가 표시됩니다.</p>';
            return;
        }
        els.routeDetails.innerHTML = `
            <div class="route-detail__header">
                <h4>${route.title}</h4>
                <p>${route.status} · ${route.eta} · ${route.distance} ${buildCrowdBadge(route.crowd)}</p>
            </div>
            <p class="route-detail__note">추천 사유: ${route.reason}</p>
            <ol class="route-detail__steps">
                ${route.steps.map(step => `<li>${step}</li>`).join('')}
            </ol>
            <p class="route-detail__note">AI 신뢰도 ${(route.confidence * 100).toFixed(0)}%</p>
        `;
    }

    // 편의시설 목록 렌더링
    function renderFacilities() {
        if (state.selectionMode !== 'facility') {
            els.facilityList.innerHTML = '';
            kakaoFacilityMarkers.forEach(m => m.setMap(null));
            kakaoFacilityMarkers = [];
            return;
        }

        els.facilityList.innerHTML = '';

        const query = state.facilityQuery;
        const filtered = facilities
                .filter(f => state.filters.has(f.type))
                .filter(f => f.crowd <= state.crowdThreshold)
                .filter(f => !query || f.label.toLowerCase().includes(query));

        if (!filtered.length) {
            els.facilityList.innerHTML = '<li class="facility-item">조건에 맞는 편의시설이 없습니다.</li>';
            kakaoFacilityMarkers.forEach(m => m.setMap(null));
            kakaoFacilityMarkers = [];
            setMapStatus('표시할 편의시설이 없습니다.');
            return;
        }

        filtered.forEach(facility => {
            const item = document.createElement('li');
            item.className = 'facility-item';
            item.innerHTML = `
                <div class="facility-item__label">${facilityIcons[facility.type]} ${facility.label}</div>
                <div class="facility-item__meta">${facility.description} · ${facility.distance} ${buildCrowdBadge(facility.crowd)}</div>
            `;
            item.addEventListener('click', () => selectRoute(facility.route));
            item.tabIndex = 0;
            els.facilityList.appendChild(item);
        });

        renderKakaoFacilities(filtered);
        setMapStatus(`${filtered.length}개의 편의시설을 표시합니다.`);
    }

    // 경로 선택
    function selectRoute(routeId) {
        state.selectedRoute = routeId;
        renderRoutes();

        if (state.selectionMode === 'facility') {
            renderFacilities();
        }

        const route = routeMap.get(routeId);
        if (route) {
            setLiveMessage(`${route.title} 경로가 선택되었습니다.`);
            renderKakaoRoute(route);
        }
    }

    // 통계 업데이트
    function updateStats(routeId) {
        const route = routeMap.get(routeId);
        if (!route) {
            els.selectedZone.textContent = '없음';
            els.selectedEta.textContent = '-';
            els.selectedCrowd.textContent = '-';
            els.heroCrowd.textContent = '-';
            els.heroCrowd.dataset.crowdLevel = '';
            if (els.mapBadge) {
                els.mapBadge.textContent = '경로를 선택해주세요';
            }
            updateMobileCard(null);
            return;
        }

        els.selectedZone.textContent = route.title;
        els.selectedEta.textContent = route.eta;
        els.selectedCrowd.textContent = route.crowd;
        els.heroCrowd.textContent = route.crowd;
        els.heroCrowd.dataset.crowdLevel = getCrowdLevel(route.crowd);

        if (els.mapBadge) {
            els.mapBadge.textContent = `${route.status} · ${route.distance}`;
        }
        updateMobileCard(route);
    }

    // 모바일 카드 업데이트
    function updateMobileCard(route) {
        if (!els.mobileCard) return;

        els.mobileCard.classList.toggle('is-active', Boolean(route));

        if (!route) {
            els.mobileRoute && (els.mobileRoute.textContent = '경로를 선택해주세요');
            els.mobileDesc && (els.mobileDesc.textContent = '추천 카드에서 경로를 선택하면 상세 안내가 표시됩니다.');
            els.mobilePrimaryChip && (els.mobilePrimaryChip.textContent = '대기 중');
            els.mobileSecondaryChip && (els.mobileSecondaryChip.textContent = 'AI 추천');
            els.mobileEta && (els.mobileEta.textContent = '-');
            els.mobileCrowd && (els.mobileCrowd.textContent = '-');
            return;
        }

        els.mobileRoute && (els.mobileRoute.textContent = route.title);
        els.mobileDesc && (els.mobileDesc.textContent = route.reason);
        els.mobilePrimaryChip && (els.mobilePrimaryChip.textContent = route.status);
        els.mobileSecondaryChip && (els.mobileSecondaryChip.textContent = route.distance);
        els.mobileEta && (els.mobileEta.textContent = route.eta);
        els.mobileCrowd && (els.mobileCrowd.textContent = route.crowd);
    }

    // 상태 메시지 설정
    function setMapStatus(message) {
        if (els.mapStatus) els.mapStatus.textContent = message;
        if (els.mobileNote) els.mobileNote.textContent = message;
    }

    function setLiveMessage(message) {
        if (els.mapLiveRegion) els.mapLiveRegion.textContent = message;
    }

    // 선택 모드 변경
    function setSelectionMode(mode) {
        if (!mode) return;
        state.selectionMode = mode;

        els.selectionButtons?.forEach(button => {
            const isActive = button.dataset.selectionMode === mode;
            button.classList.toggle('is-active', isActive);
            button.setAttribute('aria-selected', String(isActive));
        });

        els.routePanel?.classList.toggle('is-hidden', mode !== 'route');
        els.facilityPanel?.classList.toggle('is-hidden', mode !== 'facility');

        if (mode === 'route') {
            kakaoFacilityMarkers.forEach(m => m.setMap(null));
            kakaoFacilityMarkers = [];
            renderKakaoRoute(state.selectedRoute ? routeMap.get(state.selectedRoute) : null);
            setMapStatus('추천 경로 카드 모드입니다.');
        } else {
            if (kakaoPolyline) {
                kakaoPolyline.setMap(null);
                kakaoPolyline = null;
            }
            kakaoMarkers.forEach(m => m.setMap(null));
            kakaoMarkers = [];
            renderFacilities();
            setMapStatus('편의시설 보기 모드입니다.');
        }
    }

    // 실시간 정보 새로고침 (목업)
    function refreshRealtime() {
        const mockLocation = ['중앙 로비', '미디어홀 입구', '야외 정원'][Math.floor(Math.random() * 3)];
        const mockEta = `${Math.floor(Math.random() * 7) + 5}분`;
        const mockCrowd = Math.floor(Math.random() * 70) + 15;
        const alt = altRoutes[Math.floor(Math.random() * altRoutes.length)];

        els.currentLocation.textContent = mockLocation;
        els.currentEta.textContent = mockEta;
        els.currentCrowd.textContent = mockCrowd;
        els.currentCrowd.dataset.crowdLevel = getCrowdLevel(mockCrowd);
        els.alternateRoute.textContent = alt;

        const timestamp = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
        if (els.realtimeTimestamp) {
            els.realtimeTimestamp.textContent = timestamp;
        }

        setMapStatus('실시간 정보가 업데이트되었습니다.');
    }

    // 이벤트 리스너
    function handleFilterChange(event) {
        if (!event.target.matches('input[type="checkbox"]')) return;
        if (event.target.checked) {
            state.filters.add(event.target.value);
        } else {
            state.filters.delete(event.target.value);
        }
        renderFacilities();
    }

    function handleFacilitySearch(event) {
        state.facilityQuery = event.target.value.trim().toLowerCase();
        renderFacilities();
    }

    function handleCrowdThreshold(event) {
        state.crowdThreshold = Number(event.target.value);
        if (els.crowdValue) {
            els.crowdValue.textContent = `혼잡도 ${state.crowdThreshold} 이하`;
        }
        renderFacilities();
        if (state.calmMode) {
            renderRoutes();
        }
    }

    function handleToggleChange() {
        state.mobilityMode = Boolean(els.mobilityToggle?.checked);
        state.calmMode = Boolean(els.calmToggle?.checked);
        renderRoutes();
    }

    // 초기화
    document.getElementById('resetSelection')?.addEventListener('click', () => {
        state.selectedRoute = null;
        renderRoutes();
        renderRouteDetails(null);
        updateStats();
        renderKakaoRoute(null);

        // 지도 초기 위치로
        if (kakaoMap) {
            kakaoMap.setCenter(new kakao.maps.LatLng(kakaoBaseCoord.lat, kakaoBaseCoord.lng));
            kakaoMap.setLevel(3);
        }

        setMapStatus('선택이 초기화되었습니다.');
    });

    document.getElementById('mockMapClick')?.addEventListener('click', () => {
        document.getElementById('mapSection').scrollIntoView({ behavior: 'smooth' });
        selectRoute('routeA');
    });

    document.getElementById('scrollToRoutes')?.addEventListener('click', () => {
        document.getElementById('routesPanel').scrollIntoView({ behavior: 'smooth' });
    });

    document.getElementById('refreshRealtime')?.addEventListener('click', refreshRealtime);

    els.facilityFilters?.addEventListener('change', handleFilterChange);
    els.facilitySearch?.addEventListener('input', handleFacilitySearch);
    els.crowdSlider?.addEventListener('input', handleCrowdThreshold);
    els.mobilityToggle?.addEventListener('change', handleToggleChange);
    els.calmToggle?.addEventListener('change', handleToggleChange);

    els.selectionButtons?.forEach(button => {
        button.addEventListener('click', () => setSelectionMode(button.dataset.selectionMode));
    });

    // 초기 실행
    initKakaoMap();
    setSelectionMode('route');
    renderRoutes();
    renderFacilities();
    updateStats();
})();
