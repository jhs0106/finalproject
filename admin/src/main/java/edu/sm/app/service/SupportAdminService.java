package edu.sm.app.service;

import edu.sm.app.dto.SupportChatMessage;
import edu.sm.app.dto.SupportSession;
import edu.sm.sse.SupportSseBroadcaster;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SupportAdminService {

    private final SupportChatStore store;
    private final SupportSseBroadcaster broadcaster;
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter
            .ofPattern("yyyy-MM-dd HH:mm:ss")
            .withZone(ZoneId.of("Asia/Seoul"));

    public List<SupportSession> findAll() {
        return store.findAll();
    }

    public SupportSession findById(String id) {
        return store.findById(id).orElseThrow(() -> new IllegalArgumentException("세션을 찾을 수 없습니다."));
    }

    public SseEmitter subscribeAll() {
        return broadcaster.subscribeAll(findAll());
    }

    public SseEmitter subscribeSession(String id) {
        SupportSession session = findById(id);
        return broadcaster.subscribeSession(id, session);
    }

    public SupportSession reply(String id, String message) {
        SupportSession session = findById(id);
        session.getMessages().add(SupportChatMessage.builder()
                .sender("admin")
                .timestamp(now())
                .content(message)
                .build());
        session.setStatus("AGENT_CONNECTED");
        SupportSession saved = store.upsert(session);
        broadcaster.broadcastList(store.findAll());
        broadcaster.broadcastSession(saved);
        return saved;
    }

    public SupportSession close(String id) {
        SupportSession session = findById(id);
        session.setStatus("CLOSED");
        SupportSession saved = store.upsert(session);
        broadcaster.broadcastList(store.findAll());
        broadcaster.broadcastSession(saved);
        return saved;
    }

    private String now() {
        return FORMATTER.format(Instant.now());
    }
}