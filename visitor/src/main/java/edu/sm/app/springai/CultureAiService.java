package edu.sm.app.springai;

import edu.sm.app.dto.ArtifactContext;
import edu.sm.app.dto.ComparisonDataset;
import edu.sm.app.dto.ComparisonRegion;
import edu.sm.app.dto.CultureComparisonRequest;
import edu.sm.app.dto.CultureComparisonResponse;
import edu.sm.app.dto.CultureGuideRequest;
import edu.sm.app.dto.CultureGuideResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.time.Duration;
import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CultureAiService {

    private final ChatClient chatClient;
    private final VectorStore vectorStore;
    private final CultureContentRepository repository;

    public CultureGuideResponse generateGuide(CultureGuideRequest request) {
        ArtifactContext artifact = repository.findArtifact(request.getArtifactId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 전시물입니다."));

        String question = request.getVisitorQuestion() == null || request.getVisitorQuestion().isBlank()
                ? "방문객에게 작품을 소개할 수 있도록 시대적 배경과 인접국 비교를 알려줘"
                : request.getVisitorQuestion();

        Instant start = Instant.now();
        List<Document> documents = safeSearch(question + " " + artifact.getTitle());
        String context = documents.stream()
                .map(Document::getText)          // 텍스트만
                .filter(Objects::nonNull)        // null 방지
                .collect(Collectors.joining("\n"));

        String prompt = "전시 작품: " + artifact.getTitle() + " (" + artifact.getEra() + ")\n" +
                "전시 국가/홀: " + artifact.getCountry() + " / " + artifact.getHall() + "\n" +
                "주요 하이라이트: " + String.join(", ", artifact.getHighlights()) + "\n" +
                "인접국 비교: " + String.join(", ", artifact.getNeighbors()) + "\n" +
                "질문: " + question + "\n" +
                "VectorStore 컨텍스트:\n" + context;

        String summary = chatClient.prompt()
                .system("문화재 도슨트처럼 3~4문장으로 시대적 배경과 인접국 비교, 이동 동선을 안내하세요.")
                .user(prompt)
                .call()
                .content();

        if (summary == null || summary.isBlank()) {
            summary = fallbackGuide(artifact);
        }

        long latency = Duration.between(start, Instant.now()).toMillis();
        int contextCount = documents.size();

        return CultureGuideResponse.builder()
                .artifactId(artifact.getId())
                .title(artifact.getTitle())
                .era(artifact.getEra())
                .summary(summary)
                .ttsScript(summary)
                .contextCount(contextCount)
                .latencyMs(latency)
                .build();
    }

    public CultureComparisonResponse compareEra(CultureComparisonRequest request) {
        ArtifactContext base = repository.findArtifact(request.getBaseArtifactId())
                .orElseThrow(() -> new IllegalArgumentException("기준 전시물이 없습니다."));
        ComparisonDataset dataset = repository.findComparisonDataset(request.getBaseArtifactId());
        if (dataset == null || CollectionUtils.isEmpty(dataset.getRegions())) {
            throw new IllegalArgumentException("비교 데이터셋이 없습니다.");
        }

        ComparisonRegion region = dataset.getRegions().stream()
                .filter(r -> r.getId().equalsIgnoreCase(request.getRegionId()))
                .findFirst()
                .orElse(dataset.getRegions().get(0));

        String context = String.join("\n", List.of(
                "기준 작품 하이라이트: " + String.join("; ", base.getHighlights()),
                "인접국 단서: " + String.join("; ", base.getNeighbors()),
                "선택 지역 요약: " + region.getSummary()
        ));

        String prompt = "기준 작품: " + base.getTitle() + " (" + base.getEra() + ")\n" +
                "비교 대상: " + region.getLabel() + "\n" +
                "주요 지표: 교류 지수/사상 확산/기술 혁신/문화 파급\n" +
                "사용 데이터셋: " + dataset.getDataset() + "\n" +
                "RAG 문맥:\n" + context;

        String summary = chatClient.prompt()
                .system("전시 비교 도슨트로서 차이점과 공통점을 3문장으로 요약하고, 한 문장으로 이동 동선 또는 관람 포인트를 제시하세요.")
                .user(prompt)
                .call()
                .content();

        if (summary == null || summary.isBlank()) {
            summary = fallbackComparison(base, region);
        }

        return CultureComparisonResponse.builder()
                .baseTitle(base.getTitle())
                .regionLabel(region.getLabel())
                .summary(summary)
                .dataset(dataset.getDataset())
                .contextCount(dataset.getRegions().size())
                .regionMetrics(region.getMetrics())
                .build();
    }

    private String fallbackGuide(ArtifactContext artifact) {
        return String.join("\n", List.of(
                "• " + artifact.getTitle() + "는 " + artifact.getEra() + "의 대표 유물로, 위치: " + artifact.getHall() + ".",
                "• 시대 배경: " + artifact.getHighlights().get(0) + ".",
                "• 인접국 비교: " + artifact.getNeighbors().get(0) + ".",
                "• 다음 안내 스피커에서 음성을 들을 수 있습니다."
        ));
    }

    private String fallbackComparison(ArtifactContext base, ComparisonRegion region) {
        return String.join("\n", List.of(
                "• " + base.getTitle() + "와 " + region.getLabel() + "는 동일 시기 교류권에 속합니다.",
                "• 특징 대비: " + region.getSummary(),
                "• 다음 전시 구역에서 두 사례를 나란히 비교해 보세요."
        ));
    }

    private List<Document> safeSearch(String query) {
        try {
            return vectorStore.similaritySearch(
                    SearchRequest.builder()
                            .query(query)
                            .topK(5)
                            .build()
            );
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }
}