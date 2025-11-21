package edu.sm.app.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.SupportSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class SupportChatStore {

    private final ObjectMapper objectMapper;

    private Path getStoragePath() throws IOException {
        Path base = Paths.get(System.getProperty("user.dir")).resolve("../shared-data");
        if (!Files.exists(base)) {
            Files.createDirectories(base);
        }
        Path file = base.resolve("support-chats.json");
        if (!Files.exists(file)) {
            Files.writeString(file, "[]");
        }
        return file;
    }
    /**
     * 외부 컴포넌트에서 저장소 파일을 감시하거나 즉시 접근할 수 있도록 노출합니다.
     */
    public Path storageFile() throws IOException {
        return getStoragePath();
    }
    private synchronized List<SupportSession> loadSessions() {
        try {
            Path file = getStoragePath();
            return objectMapper.readValue(file.toFile(), new TypeReference<>() {});
        } catch (Exception e) {
            log.error("고객센터 대화 이력을 불러오는 중 오류", e);
            return new ArrayList<>();
        }
    }

    private synchronized void saveSessions(List<SupportSession> sessions) throws IOException {
        Path file = getStoragePath();
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(file.toFile(), sessions);
    }

    public synchronized SupportSession upsert(SupportSession session) {
        List<SupportSession> sessions = loadSessions();
        sessions.removeIf(s -> s.getId().equals(session.getId()));
        sessions.add(session);
        try {
            saveSessions(sessions);
        } catch (IOException e) {
            log.error("고객센터 대화 이력을 저장하는 중 오류", e);
        }
        return session;
    }

    public synchronized Optional<SupportSession> findById(String id) {
        return loadSessions().stream()
                .filter(s -> s.getId().equals(id))
                .findFirst();
    }

    public synchronized List<SupportSession> findAll() {
        return loadSessions();
    }
}