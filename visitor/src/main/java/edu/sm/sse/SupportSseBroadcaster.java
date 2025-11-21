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

    private final Map<String, List<SseEmitter>> emittersBySession = new ConcurrentHashMap<>();

    public SseEmitter subscribe(String sessionId, SupportSession snapshot) {
        SseEmitter emitter = new SseEmitter(0L);
        emittersBySession.computeIfAbsent(sessionId, id -> new CopyOnWriteArrayList<>()).add(emitter);

        emitter.onCompletion(() -> removeEmitter(sessionId, emitter));
        emitter.onTimeout(() -> removeEmitter(sessionId, emitter));
        emitter.onError((ex) -> removeEmitter(sessionId, emitter));

        try {
            emitter.send(SseEmitter.event().name("session").data(snapshot));
        } catch (IOException e) {
            log.warn("초기 SSE 전송 실패", e);
            emitter.complete();
        }

        return emitter;
    }

    public void broadcast(SupportSession session) {
        List<SseEmitter> emitters = emittersBySession.get(session.getId());
        if (emitters == null || emitters.isEmpty()) {
            return;
        }

        emitters.forEach(emitter -> {
            try {
                emitter.send(SseEmitter.event().name("session").data(session));
            } catch (IOException e) {
                log.debug("SSE 전송 실패, 구독자 정리", e);
                emitter.complete();
            }
        });
    }

    private void removeEmitter(String sessionId, SseEmitter emitter) {
        List<SseEmitter> emitters = emittersBySession.get(sessionId);
        if (emitters != null) {
            emitters.remove(emitter);
        }
    }
}