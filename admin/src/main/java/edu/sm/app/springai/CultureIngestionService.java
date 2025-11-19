
package edu.sm.app.springai;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CultureIngestionService {

    private final VectorStore vectorStore;

    public Map<String, Object> ingestFile(String facilityId, MultipartFile file) {
        if (facilityId == null || facilityId.isBlank()) {
            throw new IllegalArgumentException("facilityId는 필수입니다.");
        }
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("업로드할 파일이 비어 있습니다.");
        }

        Instant start = Instant.now();
        String content = readFile(file);

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("facilityId", facilityId);
        metadata.put("filename", file.getOriginalFilename());
        metadata.put("contentType", file.getContentType());
        metadata.put("id", documentId(facilityId));
        List<Document> documents = List.of(new Document((String) metadata.get("id"), content, metadata));
        vectorStore.add(documents);

        Map<String, Object> result = new HashMap<>();
        result.put("count", documents.size());
        result.put("elapsedMs", Duration.between(start, Instant.now()).toMillis());
        result.put("timestamp", Instant.now().toString());
        result.put("facilityId", facilityId);
        result.put("documentId", metadata.get("id"));
        return result;
    }

    private String documentId(String facilityId) {
        return facilityId + ":" + UUID.randomUUID();
    }

    private String readFile(MultipartFile file) {
        try {
            byte[] bytes = file.getBytes();
            return new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new IllegalStateException("파일을 읽는 중 오류가 발생했습니다.", e);
        }
    }
}