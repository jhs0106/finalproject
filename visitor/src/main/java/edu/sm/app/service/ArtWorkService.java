package edu.sm.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ArtWorkRequest;
import edu.sm.app.dto.ArtWorkResponse;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ArtWorkService implements SmService<ArtWorkRequest, Integer> {

    private final OpenAiChatModel chatModel;
    private final ObjectMapper objectMapper;

    // ====== 프롬프트 생성 + 보낼 원문 로그 ======
    private Prompt buildPrompt(ArtWorkRequest req) {

        String systemPrompt = """
                당신은 'AI Art Curator'입니다.
                사용자의 감정(emotion), 선택한 시설(facility), 그리고
                사용자가 직접 그린 스케치 제공 여부(hasUserSketch)를 바탕으로
                아래 3개의 필드를 가진 JSON으로만 응답하세요.

                {
                  "artworkDescription": "작품의 시각적 설명",
                  "curatorComment": "큐레이터 코멘트",
                  "exhibitionNote": "전시 작가 노트"
                }

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

        // ==== 여기서 GPT에게 보낼 원문 프롬프트 로그 ====
        log.info("========== [ArtWorkService] OpenAI 요청 프롬프트 ==========");
        log.info("[SYSTEM PROMPT]\n{}", systemPrompt);
        log.info("[USER PROMPT]\n{}", userPrompt);
        log.info("=========================================================");

        return new Prompt(
                new SystemMessage(systemPrompt),
                new UserMessage(userPrompt)
        );
    }

    // ====== GPT 호출 & JSON 파싱 ======
    public ArtWorkResponse generateArtwork(ArtWorkRequest req) {

        // 0) 클라이언트에서 받은 감정/시설/스케치 여부 로그
        log.info("========== [ArtWorkService] generateArtwork 호출 ==========");
        log.info("[CLIENT REQUEST] emotion={}, facility={}, hasSketch={}",
                req.getEmotion(), req.getFacility(),
                (req.getSketchBase64() != null && !req.getSketchBase64().isBlank()));

        // 필요하다면 여기서 req.getSketchBase64()를 파일로 저장해두고
        // 향후 이미지 생성 모델에서 참고 이미지로 사용할 수 있음.

        // 1) 모델 호출
        ChatResponse chatResponse = chatModel.call(buildPrompt(req));

        log.debug("[ArtWorkService] Raw ChatResponse = {}", chatResponse);

        // 2) 결과 텍스트 추출
        String json = chatResponse
                .getResult()
                .getOutput()
                .getText();

        log.info("========== [ArtWorkService] OpenAI 원문 응답 ==========");
        log.info("[RAW JSON]\n{}", json);
        log.info("======================================================");

        try {
            // 3) JSON → ArtWorkResponse 매핑
            ArtWorkResponse result = objectMapper.readValue(json, ArtWorkResponse.class);

            // 현재는 imageBase64는 채우지 않음 (추후 이미지 생성 로직 추가 가능)
            // result.setImageBase64(...);

            // 4) 파싱된 DTO 내용 요약 로그
            log.info("========== [ArtWorkService] 파싱된 결과 ==========");
            log.info("[artworkDescription] {}",
                    safePreview(result.getArtworkDescription()));
            log.info("[curatorComment] {}",
                    safePreview(result.getCuratorComment()));
            log.info("[exhibitionNote] {}",
                    safePreview(result.getExhibitionNote()));
            log.info("===================================================");

            return result;
        } catch (Exception e) {
            log.error("[ArtWorkService] JSON 파싱 중 오류 발생. rawJson = {}", json, e);

            ArtWorkResponse fallback = new ArtWorkResponse();
            fallback.setArtworkDescription("작품 설명 생성 중 오류가 발생했습니다.");
            fallback.setCuratorComment("잠시 후 다시 시도해 주세요.");
            fallback.setExhibitionNote("");
            return fallback;
        }
    }

    private String safePreview(String s) {
        if (s == null) return "null";
        int max = 120;
        return (s.length() > max) ? s.substring(0, max) + "..." : s;
    }

    // ====== SmService 구현부 (현재 기능에서는 사용 안 함) ======
    @Override public void register(ArtWorkRequest v) throws Exception {}
    @Override public void modify(ArtWorkRequest v) throws Exception {}
    @Override public void remove(Integer k) throws Exception {}
    @Override public List<ArtWorkRequest> get() throws Exception { return null; }
    @Override public ArtWorkRequest get(Integer k) throws Exception { return null; }
}
