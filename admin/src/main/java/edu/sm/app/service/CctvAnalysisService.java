package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.content.Media;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import reactor.core.publisher.Flux;
import edu.sm.app.tool.EmergencyCallTool;

/**
 * Service that sends CCTV snapshots to the configured AI model
 * and streams the resulting analysis.
 */
@Service
@Slf4j
public class CctvAnalysisService {

    private final ChatClient chatClient;
    private final EmergencyCallTool emergencyCallTool;

    public CctvAnalysisService(ChatModel chatModel, EmergencyCallTool emergencyCallTool) {
        this.chatClient = ChatClient.builder(chatModel).build();
        this.emergencyCallTool = emergencyCallTool;
    }

    public Flux<String> analyzeAndRespond(String question, String contentType, byte[] bytes) {
        SystemMessage systemMessage = SystemMessage.builder()
                .text("""
                        당신은 CCTV 영상 분석 요원입니다.

                        1. 화재, 붕괴, 폭발, 심각한 사고 등 인명 피해가 우려되는 재난 상황이 명확히 보이면 반드시 EmergencyCallTool의 call119 도구를 호출하세요.
                        2. 재난 상황이 감지되지 않으면 다른 텍스트 없이 'NO_DISASTER_DETECTED'를 출력하세요.
                        3. 재난을 감지했을 때는 신고 결과(도구 응답)와 감지 근거만 간결한 한국어로 설명하세요.
                        """)
                .build();

        Media media = Media.builder()
                .mimeType(MimeType.valueOf(contentType))
                .data(new ByteArrayResource(bytes))
                .build();

        UserMessage userMessage = UserMessage.builder()
                .text(question)
                .media(media)
                .build();

        return chatClient.prompt()
                .messages(systemMessage, userMessage)
                .tools(emergencyCallTool)
                .stream()
                .content();
    }
}