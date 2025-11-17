<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 히어로 섹션 */
    .hero {
        min-height: 600px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: var(--space-24) 0 var(--space-20) 0;
        background: linear-gradient(to bottom, var(--bg-overlay), var(--bg-main));
    }

    .hero-title {
        font-size: var(--font-6xl);
        font-weight: var(--font-black);
        margin-bottom: var(--space-6);
        letter-spacing: var(--letter-tight);
        color: var(--primary-teal);
    }

    .hero-subtitle {
        font-size: var(--font-lg);
        color: var(--text-secondary);
        margin-bottom: var(--space-10);
        line-height: var(--leading-relaxed);
    }

    .hero-buttons {
        display: flex;
        gap: var(--space-4);
        justify-content: center;
        flex-wrap: wrap;
    }

    /* 서비스 섹션 */
    .section-title {
        font-size: var(--font-4xl);
        font-weight: var(--font-bold);
        text-align: center;
        margin-bottom: var(--space-12);
    }

    .service-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: var(--space-8);
    }

    .service-card {
        background: var(--bg-card);
        border: 1px solid var(--border-light);
        border-radius: var(--radius-xl);
        padding: var(--space-8);
        text-align: center;
        transition: all var(--transition-base);
        cursor: pointer;
    }

    .service-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-lg);
        border-color: var(--primary-teal);
    }

    .service-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto var(--space-6);
        border-radius: var(--radius-full);
        background: radial-gradient(circle at 30% 30%, var(--primary-light), var(--primary-teal));
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        color: var(--text-white);
    }

    .service-title {
        font-size: var(--font-2xl);
        font-weight: var(--font-bold);
        margin-bottom: var(--space-4);
        color: var(--primary-dark);
    }

    .service-desc {
        color: var(--text-secondary);
        margin-bottom: 0;
    }

    /* 반응형 */
    @media (max-width: 1024px) {
        .service-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 768px) {
        .hero {
            padding: var(--space-16) 0 var(--space-12) 0;
        }

        .hero-title {
            font-size: var(--font-4xl);
        }

        .hero-subtitle {
            font-size: var(--font-base);
        }

        .service-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<!-- 히어로 섹션 -->
<section class="hero">
    <div class="container-content">
        <h1 class="hero-title">
            AI가 안내하는<br>스마트 문화 공간
        </h1>
        <p class="hero-subtitle">
            음성으로 질문하고, 실시간으로 확인하며,<br>
            AI가 추천하는 최적의 관람 경험을 누리세요.
        </p>
        <div class="hero-buttons">
            <button class="btn btn-primary btn-lg"
                    onclick="location.href='<c:url value='/voice'/>'">
                <i class="fas fa-microphone"></i> AI 음성 안내 시작
            </button>
            <button class="btn btn-outline btn-lg"
                    onclick="location.href='<c:url value='/map'/>'">
                <i class="fas fa-map-marked-alt"></i> 관람 안내 보기
            </button>
        </div>
    </div>
</section>

<!-- 주요 서비스 섹션 -->
<section class="section">
    <div class="container">
        <h2 class="section-title">주요 서비스</h2>

        <div class="service-grid">
            <!-- 1. AI 음성 안내 -->
            <div class="service-card" onclick="location.href='<c:url value='/voice'/>'">
                <div class="service-icon">
                    <i class="fas fa-headphones-alt"></i>
                </div>
                <h3 class="service-title">AI 음성 안내</h3>
                <p class="service-desc">
                    전시 작품과 공간 정보를 음성으로 안내받을 수 있습니다.
                </p>
            </div>

            <!-- 2. 관람 동선 추천 -->
            <div class="service-card" onclick="location.href='<c:url value='/map'/>'">
                <div class="service-icon">
                    <i class="fas fa-route"></i>
                </div>
                <h3 class="service-title">관람 동선 추천</h3>
                <p class="service-desc">
                    현재 위치와 혼잡도를 고려한 최적의 관람 동선을 제안합니다.
                </p>
            </div>

            <!-- 3. AI 작품 생성 -->
            <div class="service-card" onclick="location.href='<c:url value='/artwork'/>'">
                <div class="service-icon">
                    <i class="fas fa-palette"></i>
                </div>
                <h3 class="service-title">AI 작품 생성</h3>
                <p class="service-desc">
                    나만의 예술 작품을 AI로 생성해보세요.
                </p>
            </div>

            <!-- 전염병 알리미 카드 -->
            <div class="service-card epidemic-card" data-toggle="modal" data-target="#epidemicModal">
                <div class="service-icon">
                    <i class="fas fa-virus"></i>
                </div>

                <h3 class="service-title">전염병 알리미</h3>

                <p class="service-desc">
                    질병관리청 · 지자체 공지 기반 전염병 위험도 및 예방 수칙을 제공합니다.
                </p>
            </div>

            <!-- 5. 문화 해설 -->
            <div class="service-card" onclick="location.href='<c:url value='/culture'/>'">
                <div class="service-icon">
                    <i class="fas fa-book-open"></i>
                </div>
                <h3 class="service-title">문화 해설</h3>
                <p class="service-desc">
                    작품을 스캔하면 상세한 해설을 들려드립니다.
                </p>
            </div>

            <!-- 6. 혼잡도 확인 -->
            <div class="service-card" onclick="location.href='<c:url value='/crowd'/>'">
                <div class="service-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="service-title">실시간 혼잡도</h3>
                <p class="service-desc">
                    각 구역의 혼잡도를 실시간으로 확인하세요.
                </p>
            </div>
        </div>
    </div>
</section>
