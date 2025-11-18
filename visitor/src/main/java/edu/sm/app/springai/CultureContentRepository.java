package edu.sm.app.springai;

import edu.sm.app.dto.ArtifactContext;
import edu.sm.app.dto.ComparisonDataset;
import edu.sm.app.dto.ComparisonRegion;
import org.springframework.ai.document.Document;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Component
public class CultureContentRepository {

    private final List<ArtifactContext> artifacts;
    private final Map<String, ComparisonDataset> comparisons;
    private final List<String> ragHints;

    public CultureContentRepository() {
        this.artifacts = buildArtifacts();
        this.comparisons = buildComparisons();
        this.ragHints = buildRagHints();
    }

    public List<ArtifactContext> getArtifacts() {
        return artifacts;
    }

    public Map<String, ComparisonDataset> getComparisons() {
        return comparisons;
    }

    public List<String> getRagHints() {
        return ragHints;
    }

    public Optional<ArtifactContext> findArtifact(String artifactId) {
        return artifacts.stream()
                .filter(item -> item.getId().equalsIgnoreCase(artifactId))
                .findFirst();
    }

    public ComparisonDataset findComparisonDataset(String artifactId) {
        return comparisons.get(artifactId);
    }

    public List<Document> asDocuments() {
        List<Document> documents = new ArrayList<>();
        for (ArtifactContext artifact : artifacts) {
            Map<String, Object> metadata = new HashMap<>();
            metadata.put("id", artifact.getId());
            metadata.put("era", artifact.getEra());
            metadata.put("country", artifact.getCountry());
            metadata.put("hall", artifact.getHall());
            String content = String.join("\n", List.of(
                    artifact.getTitle(),
                    String.join(", ", artifact.getHighlights()),
                    String.join(", ", artifact.getNeighbors()),
                    String.join(", ", artifact.getVectorTopics())
            ));
            documents.add(new Document(content, metadata));
        }
        return documents;
    }

    private List<ArtifactContext> buildArtifacts() {
        List<ArtifactContext> list = new ArrayList<>();
        list.add(ArtifactContext.builder()
                .id("silla-buddha")
                .title("금동미륵보살반가사유상")
                .era("신라 7세기")
                .country("한반도")
                .hall("불교 조각실")
                .vectorTopics(List.of("동아시아 불교 전파", "백제/일본 교류", "청동 주조 기술"))
                .highlights(List.of(
                        "삼국시대 불교 조각의 정점으로 평가, 왕실의 호국 불교 성격 반영",
                        "백제·고구려를 거친 불교 조형 언어가 일본 아스카 양식과 교류",
                        "청동 합금 비율과 금도금 기술이 동시기 서역 재료와 연결"
                ))
                .neighbors(List.of(
                        "일본 아스카 시대 사무하치사 목조 보살상",
                        "당나라 초기 불상과의 의복 표현 비교",
                        "서역 간다라 영향이 남은 얼굴 비례"
                ))
                .build());

        list.add(ArtifactContext.builder()
                .id("joseon-ceramics")
                .title("분청사기 박지연어문 편병")
                .era("조선 15세기")
                .country("한반도")
                .hall("도자기 갤러리")
                .vectorTopics(List.of("분청사기 기술", "무역항/왜관", "명나라 도자 수용"))
                .highlights(List.of(
                        "박지기법과 분청 유약을 활용한 실험적 형태가 특징",
                        "15세기 부산·제포 왜관 교역품으로 일본 다도 문화에 영향",
                        "명나라 경덕진 청화백자와의 기술 교류가 이어짐"
                ))
                .neighbors(List.of(
                        "무로마치 시대 초기 다완과의 형태적 대비",
                        "밍 왕조 청화백자 초기 도상과 문양 교류",
                        "동남아 무역을 통한 해상 실크로드 영향"
                ))
                .build());

        list.add(ArtifactContext.builder()
                .id("goguryeo-mural")
                .title("고구려 무용총 벽화")
                .era("고구려 5세기")
                .country("만주·한반도 북부")
                .hall("벽화실")
                .vectorTopics(List.of("도시 문화", "사냥/무용 모티프", "북방 유목 교류"))
                .highlights(List.of(
                        "무용 장면을 통해 귀족 사교와 제례 문화를 확인",
                        "사냥·무용 모티프가 흉노 및 선비족 벽화와 닮아 있음",
                        "채색 안료에서 실크로드 광물성 안료가 검출"
                ))
                .neighbors(List.of(
                        "북위 용문석굴 초기 부조와의 구도 비교",
                        "수사학적 공간 배치가 로마 모자이크와 유사",
                        "파르티아 벽화 색채 사용과의 공통점"
                ))
                .build());

        return list;
    }

    private Map<String, ComparisonDataset> buildComparisons() {
        Map<String, ComparisonDataset> map = new HashMap<>();

        map.put("silla-buddha", ComparisonDataset.builder()
                .dataset("동아시아 불교 확산 데이터셋 v1.2")
                .baseMetrics(List.of(85, 72, 78, 80))
                .regions(List.of(
                        ComparisonRegion.builder()
                                .id("asuka")
                                .label("일본 아스카 시대")
                                .metrics(List.of(78, 65, 72, 80))
                                .summary("아스카 불교는 백제 승려와 장인이 전한 양식을 기반으로 하며, 금동 주조 기술은 한반도와 동일 계통입니다.")
                                .build(),
                        ComparisonRegion.builder()
                                .id("tang")
                                .label("당 초기 장안")
                                .metrics(List.of(82, 74, 76, 85))
                                .summary("장안 불교 조각은 실크로드 재료와 서역 비례를 결합해 금동상 표준을 주도했습니다.")
                                .build()
                ))
                .build());

        map.put("joseon-ceramics", ComparisonDataset.builder()
                .dataset("동아시아 도자 무역 그래프 v0.9")
                .baseMetrics(List.of(82, 76, 74, 70))
                .regions(List.of(
                        ComparisonRegion.builder()
                                .id("ming")
                                .label("명나라 경덕진")
                                .metrics(List.of(70, 88, 79, 68))
                                .summary("명 초기 청화백자는 해상 교역을 통해 코발트 안료를 수입하며, 조선 분청과 문양 교류가 활발했습니다.")
                                .build(),
                        ComparisonRegion.builder()
                                .id("muromachi")
                                .label("일본 무로마치")
                                .metrics(List.of(65, 72, 60, 58))
                                .summary("무로마치 다도 문화는 분청의 소박함을 선호하며 일본식 변주를 만들어냈습니다.")
                                .build()
                ))
                .build());

        map.put("goguryeo-mural", ComparisonDataset.builder()
                .dataset("유라시아 벽화·도시문화 네트워크")
                .baseMetrics(List.of(80, 68, 70, 75))
                .regions(List.of(
                        ComparisonRegion.builder()
                                .id("northern-wei")
                                .label("북위 용문석굴")
                                .metrics(List.of(74, 69, 71, 77))
                                .summary("북위 불교 부조는 고구려 벽화와 비슷한 도상 체계를 공유하며, 북방 유목 시각 언어가 반영되었습니다.")
                                .build(),
                        ComparisonRegion.builder()
                                .id("sasanian")
                                .label("사산 왕조 페르시아")
                                .metrics(List.of(60, 58, 75, 66))
                                .summary("사산 모티프가 실크로드를 통해 전달되어 색채와 장식 패턴에 영향을 미쳤습니다.")
                                .build()
                ))
                .build());

        return map;
    }

    private List<String> buildRagHints() {
        return List.of(
                "전시실/층수/위치 정보를 포함해 길 안내까지 TTS로 제공",
                "시대 배경은 연대/왕조/도시 키워드를 최소 2개 포함",
                "인접국 비교는 동시기 + 상대 시대(앞/뒤) 사례 1개씩 포함",
                "기술/재료/양식 요소는 숫자(%)·측정값으로 구체화",
                "고객 질문을 VectorStore에 저장해 다음 답변에 반영",
                "TTS는 12초 이내, 속도 1.0~1.05 유지, 2문단 이하"
        );
    }
}