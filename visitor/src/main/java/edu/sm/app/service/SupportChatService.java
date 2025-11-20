package edu.sm.app.service;

import edu.sm.app.dto.SupportChatMessage;
import edu.sm.app.dto.SupportMessageRequest;
import edu.sm.app.dto.SupportSession;
import edu.sm.app.dto.SupportStartRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class SupportChatService {

    private final ChatClient.Builder chatClientBuilder;
    private final SupportChatStore store;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter
            .ofPattern("yyyy-MM-dd HH:mm:ss")
            .withZone(ZoneId.of("Asia/Seoul"));

    public SupportSession startSession(SupportStartRequest request) {
        SupportSession session = SupportSession.builder()
                .id(UUID.randomUUID().toString())
                .userName(defaultName(request))
                .contact(request.getContact())
                .loggedIn(request.isLoggedIn())
                .status("BOT")
                .build();

        session.getMessages().add(SupportChatMessage.builder()
                .sender("bot")
                .timestamp(now())
                .content("안녕하세요! 무엇을 도와드릴까요? 전시 안내, 시설 정보, 문화 관련 질문을 자유롭게 남겨주세요.")
                .build());

        return store.upsert(session);
    }

    public SupportSession handleMessage(String sessionId, SupportMessageRequest request) {
        SupportSession session = store.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("상담 세션을 찾을 수 없습니다."));

        if (request.getMessage() != null && !request.getMessage().isBlank()) {
            session.getMessages().add(SupportChatMessage.builder()
                    .sender("visitor")
                    .timestamp(now())
                    .content(request.getMessage())
                    .build());
        }

        if (request.isHandoff() || containsHandoffKeyword(request.getMessage())) {
            session.setStatus("AGENT_REQUESTED");
            session.getMessages().add(SupportChatMessage.builder()
                    .sender("bot")
                    .timestamp(now())
                    .content("상담사 연결을 요청했습니다. 잠시만 기다려 주세요.")
                    .build());
            return store.upsert(session);
        }

        if (!"BOT".equals(session.getStatus())) {
            session.getMessages().add(SupportChatMessage.builder()
                    .sender("bot")
                    .timestamp(now())
                    .content("관리자 상담 대기 중입니다. 곧 연결해 드릴게요.")
                    .build());
            return store.upsert(session);
        }

        String botAnswer = askBot(session.getMessages());
        session.getMessages().add(SupportChatMessage.builder()
                .sender("bot")
                .timestamp(now())
                .content(botAnswer)
                .build());
        return store.upsert(session);
    }

    public SupportSession getSession(String id) {
        return store.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("상담 세션을 찾을 수 없습니다."));
    }

    private boolean containsHandoffKeyword(String message) {
        if (message == null) return false;
        String lowered = message.toLowerCase();
        return lowered.contains("상담사 연결") || lowered.contains("관리자") || lowered.contains("사람");
    }

    private String askBot(List<SupportChatMessage> messages) {
        ChatClient chatClient = chatClientBuilder.build();

        String history = messages.stream()
                .limit(6)
                .map(m -> m.getSender() + ": " + m.getContent())
                .reduce("", (a, b) -> a + "\n" + b);

        Prompt prompt = Prompt.builder()
                .messages(
                        new SystemMessage("당신은 문화시설 안내 챗봇입니다. 예의 바르게 3문장 이내로 답변하고, 시설 정보/문화 정보 중심으로 안내하세요."),
                        new UserMessage("최근 대화:\n" + history + "\n방문객 질문에 한국어로 답해주세요.")
                )
                .build();

        try {
            return chatClient.prompt(prompt).call().content();
        } catch (Exception e) {
            log.warn("챗봇 응답 생성 실패", e);
            return "지금은 AI 답변이 지연되고 있어요. 담당자를 호출하거나 잠시 후 다시 시도해 주세요.";
        }
    }

    private String defaultName(SupportStartRequest request) {
        if (request.isLoggedIn() && request.getUserName() != null && !request.getUserName().isBlank()) {
            return request.getUserName();
        }
        if (request.getUserName() == null || request.getUserName().isBlank()) {
            return request.isLoggedIn() ? "로그인 이용자" : "방문객";
        }
        return request.getUserName();
    }

    private String now() {
        return FORMATTER.format(Instant.now());
    }
}