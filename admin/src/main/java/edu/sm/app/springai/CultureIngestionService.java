package edu.sm.app.springai;

import lombok.RequiredArgsConstructor;
import org.springframework.ai.document.Document;
import org.springframework.ai.document.DocumentReader;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.reader.pdf.PagePdfDocumentReader;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
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
        List<Document> extracted = extractDocuments(file);
        if (extracted == null || extracted.isEmpty()) {
            throw new IllegalArgumentException(".txt, .pdf, .doc, .docx 파일 중 하나를 올려주세요.");
        }

        List<Document> transformed = transformDocuments(extracted);
        if (transformed.isEmpty()) {
            throw new IllegalStateException("파일에서 추출된 텍스트가 없습니다.");
        }

        List<Document> documents = prepareDocuments(transformed, facilityId, file);
        vectorStore.add(documents);

        Map<String, Object> result = new HashMap<>();
        result.put("count", documents.size());
        result.put("elapsedMs", Duration.between(start, Instant.now()).toMillis());
        result.put("timestamp", Instant.now().toString());
        result.put("facilityId", facilityId);
        List<String> documentIds = documents.stream()
                .map(Document::getId)
                .toList();
        result.put("documentIds", documentIds);
        result.put("documentId", documentIds.isEmpty() ? null : documentIds.get(0));
        return result;
    }

    private String documentId() {
        return UUID.randomUUID().toString();
    }

    private List<Document> extractDocuments(MultipartFile file) {
        try {
            Resource resource = asResource(file);
            DocumentReader reader = resolveReader(file, resource);
            return reader != null ? reader.read() : List.of();
        } catch (IOException e) {
            throw new IllegalStateException("파일을 읽는 중 오류가 발생했습니다.", e);
        }
    }

    private List<Document> transformDocuments(List<Document> documents) {
        TokenTextSplitter splitter = new TokenTextSplitter();
        return splitter.apply(documents);
    }

    private List<Document> prepareDocuments(List<Document> documents, String facilityId, MultipartFile file) {
        List<Document> prepared = new ArrayList<>(documents.size());
        for (int index = 0; index < documents.size(); index++) {
            Document original = documents.get(index);
            Map<String, Object> metadata = new HashMap<>(
                    original.getMetadata() != null ? original.getMetadata() : Map.of()
            );
            metadata.put("facilityId", facilityId);
            metadata.put("filename", file.getOriginalFilename());
            metadata.put("contentType", file.getContentType());
            metadata.put("chunk", index);
            metadata.put("chunkCount", documents.size());
            prepared.add(new Document(documentId(), original.getText(), metadata));
        }
        return prepared;
    }

    private DocumentReader resolveReader(MultipartFile file, Resource resource) {
        String contentType = file.getContentType();
        String filename = file.getOriginalFilename();
        if (isText(contentType, filename)) {
            return new TextReader(resource);
        }
        if (isPdf(contentType, filename)) {
            return new PagePdfDocumentReader(resource);
        }
        if (isWord(contentType, filename)) {
            return new TikaDocumentReader(resource);
        }
        return null;
    }

    private Resource asResource(MultipartFile file) throws IOException {
        byte[] bytes = file.getBytes();
        return new ByteArrayResource(bytes) {
            @Override
            public String getFilename() {
                return file.getOriginalFilename();
            }
        };
    }

    private boolean isText(String contentType, String filename) {
        return (contentType != null && contentType.startsWith("text/"))
                || (filename != null && filename.toLowerCase().endsWith(".txt"));
    }

    private boolean isPdf(String contentType, String filename) {
        return (contentType != null && contentType.equalsIgnoreCase("application/pdf"))
                || (filename != null && filename.toLowerCase().endsWith(".pdf"));
    }

    private boolean isWord(String contentType, String filename) {
        if (contentType != null && contentType.contains("word")) {
            return true;
        }
        if (filename == null) {
            return false;
        }
        String lower = filename.toLowerCase();
        return lower.endsWith(".doc") || lower.endsWith(".docx");
    }
}