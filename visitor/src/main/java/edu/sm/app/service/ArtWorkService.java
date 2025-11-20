package edu.sm.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ArtWorkRequest;
import edu.sm.app.dto.ArtWorkResponse;
import edu.sm.common.frame.SmService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class ArtWorkService implements SmService<ArtWorkRequest, Integer> {

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final ArtWorkImageService imageService;

    public ArtWorkService(
            ChatClient.Builder chatClientBuilder,
            ObjectMapper objectMapper,
            ArtWorkImageService imageService
    ) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
        this.imageService = imageService;
    }

    /**
     * Spring AI ChatClient용 프롬프트 구성
     */
    private Prompt buildPrompt(ArtWorkRequest req) {

        String systemPrompt = """
        당신은 'AI Art Curator'입니다.
        사용자의 감정(emotion), 선택한 시설(facility), 그리고
        사용자가 직접 그린 스케치 제공 여부(hasUserSketch)를 바탕으로
        아래 4개의 필드를 가진 JSON으로만 응답하세요.

        {
          "artworkDescription": "작품의 시각적 설명",
          "curatorComment": "큐레이터 코멘트",
          "exhibitionNote": "전시 작가 노트",
          "sketchPlacement": "사용자 스케치를 배치하기에 가장 어울리는 위치"
        }

        - sketchPlacement는 아래 값 중 하나만 사용하십시오.
          "TOP_LEFT", "TOP_RIGHT", "BOTTOM_LEFT", "BOTTOM_RIGHT", "CENTER", "CENTER_BOTTOM"

        - 사용자가 스케치를 제공한 경우(hasUserSketch=true),
          마치 그 스케치의 선과 구도를 참고해 완성한 작품인 것처럼,
          사용자와 협업한 느낌이 나도록 묘사에 반영하세요.
        - 스케치의 실제 픽셀이나 구체적인 형태를 볼 수 있다고 가정하지 말고,
          단지 '사용자의 손길이 들어간 작품'이라는 느낌만 텍스트로 표현하세요.

        설명 문장이나 기타 텍스트 절대 넣지 마세요.
        "```", "json"와 같은 것 앞뒤로 절대 넣지 마세요.
        JSON만 반환해야 합니다.
        """;

        boolean hasSketch = (req.getSketchBase64() != null && !req.getSketchBase64().isBlank());

        String userPrompt = """
                emotion: %s
                facility: %s
                hasUserSketch: %s
                """.formatted(req.getEmotion(), req.getFacility(), hasSketch);

        log.info("========== [ArtWorkService] OpenAI 요청 프롬프트 ==========");
        log.info("[SYSTEM PROMPT]\n{}", systemPrompt);
        log.info("[USER PROMPT]\n{}", userPrompt);
        log.info("=========================================================");

        return Prompt.builder()
                .messages(
                        new SystemMessage(systemPrompt),
                        new UserMessage(userPrompt)
                )
                .build();
    }

    /**
     * 메인 비즈니스 로직:
     * 1) ChatClient로 JSON 텍스트 생성
     * 2) JSON → ArtWorkResponse 매핑
     * 3) 스케치가 있으면 ArtWorkImageService로 이미지 합성
     */
    public ArtWorkResponse generateArtwork(ArtWorkRequest req) {

        log.info("========== [ArtWorkService] generateArtwork 호출 ==========");
        log.info("[CLIENT REQUEST] emotion={}, facility={}, hasSketch={}",
                req.getEmotion(),
                req.getFacility(),
                (req.getSketchBase64() != null && !req.getSketchBase64().isBlank()));

        // 1) 텍스트 생성 (ChatClient 사용 – 이전 AiImageService 스타일)
        String json = chatClient.prompt(buildPrompt(req))
                .call()
                .content();

        log.info("========== [ArtWorkService] OpenAI 원문 응답 ==========");
        log.info("[RAW JSON]\n{}", json);
        log.info("======================================================");

        try {
            ArtWorkResponse result = objectMapper.readValue(json, ArtWorkResponse.class);

            log.info("========== [ArtWorkService] 파싱된 결과 ==========");
            log.info("[artworkDescription] {}", safePreview(result.getArtworkDescription()));
            log.info("[curatorComment] {}", safePreview(result.getCuratorComment()));
            log.info("[exhibitionNote] {}", safePreview(result.getExhibitionNote()));
            log.info("===================================================");

            // 2) 이미지 생성 + 유저 스케치 합성
            if (req.getSketchBase64() != null && !req.getSketchBase64().isBlank()) {
                String compositeBase64 = imageService.generateCompositeImage(req, result);
                result.setImageBase64(compositeBase64);
            } else {
                result.setImageBase64(null);
            }

            return result;
        } catch (Exception e) {
            log.error("[ArtWorkService] JSON 파싱 중 오류 발생. rawJson = {}", json, e);

            ArtWorkResponse fallback = new ArtWorkResponse();
            fallback.setArtworkDescription("작품 설명 생성 중 오류가 발생했습니다.");
            fallback.setCuratorComment("잠시 후 다시 시도해 주세요.");
            fallback.setExhibitionNote("");
            fallback.setImageBase64(null);
            return fallback;
        }
    }

    private String safePreview(String s) {
        if (s == null) return "null";
        int max = 120;
        return (s.length() > max) ? s.substring(0, max) + "..." : s;
    }

    // ====== SmService 구현부 (현재 기능에서는 사용 안 함, 기존 프로젝트 호환용) ======
    @Override
    public void register(ArtWorkRequest v) throws Exception { }

    @Override
    public void modify(ArtWorkRequest v) throws Exception { }

    @Override
    public void remove(Integer k) throws Exception { }

    @Override
    public java.util.List<ArtWorkRequest> get() throws Exception {
        return null;
    }

    @Override
    public ArtWorkRequest get(Integer k) throws Exception {
        return null;
    }
}
