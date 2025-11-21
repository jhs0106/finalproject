package edu.sm.sse;

import edu.sm.app.dto.SupportSession;
import edu.sm.app.service.SupportChatStore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class SupportSessionWatcher {

    private final SupportChatStore store;
    private final SupportSseBroadcaster broadcaster;

    private FileTime lastModified;

    @Scheduled(fixedDelay = 2000)
    public void watchFileChanges() {
        try {
            Path file = store.storageFile();
            FileTime modifiedTime = Files.getLastModifiedTime(file);
            if (lastModified == null || modifiedTime.compareTo(lastModified) > 0) {
                lastModified = modifiedTime;
                List<SupportSession> sessions = store.findAll();
                sessions.forEach(broadcaster::broadcast);
            }
        } catch (IOException e) {
            log.debug("지원 세션 파일 감시 중 오류", e);
        }
    }
}