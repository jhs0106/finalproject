package edu.sm.sse;

import edu.sm.app.dto.SupportSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Component
@RequiredArgsConstructor
@Slf4j
public class SupportSseBroadcaster {

    private final List<SseEmitter> listEmitters = new CopyOnWriteArrayList<>();
    private final Map<String, List<SseEmitter>> sessionEmitters = new ConcurrentHashMap<>();

    public SseEmitter subscribeAll(List<SupportSession> snapshot) {
        SseEmitter emitter = new SseEmitter(0L);
        listEmitters.add(emitter);
        wireCleanup(null, emitter);
        trySend(emitter, "sessions", snapshot);
        return emitter;
    }

    public SseEmitter subscribeSession(String sessionId, SupportSession snapshot) {
        SseEmitter emitter = new SseEmitter(0L);
        sessionEmitters.computeIfAbsent(sessionId, id -> new CopyOnWriteArrayList<>()).add(emitter);
        wireCleanup(sessionId, emitter);
        trySend(emitter, "session", snapshot);
        return emitter;
    }

    public void broadcastList(List<SupportSession> sessions) {
        listEmitters.forEach(emitter -> trySend(emitter, "sessions", sessions));
    }

    public void broadcastSession(SupportSession session) {
        List<SseEmitter> emitters = sessionEmitters.get(session.getId());
        if (emitters == null || emitters.isEmpty()) return;
        emitters.forEach(emitter -> trySend(emitter, "session", session));
    }

    private void wireCleanup(String sessionId, SseEmitter emitter) {
        Runnable cleanup = () -> {
            listEmitters.remove(emitter);
            if (sessionId != null) {
                List<SseEmitter> emitters = sessionEmitters.get(sessionId);
                if (emitters != null) emitters.remove(emitter);
            }
        };
        emitter.onCompletion(cleanup);
        emitter.onTimeout(cleanup);
        emitter.onError(ex -> cleanup.run());
    }

    private void trySend(SseEmitter emitter, String name, Object data) {
        try {
            emitter.send(SseEmitter.event().name(name).data(data));
        } catch (IOException e) {
            log.debug("SSE 전송 실패 - 정리 진행", e);
            emitter.complete();
        }
    }
}