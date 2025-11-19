
package edu.sm.controller;

import edu.sm.app.springai.CultureIngestionService;
import edu.sm.app.springai.CultureVectorAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/culture")
@RequiredArgsConstructor
public class CultureContentController {

    private final CultureIngestionService ingestionService;
    private final CultureVectorAdminService vectorAdminService;

    @PostMapping("/ingest")
    public ResponseEntity<Map<String, Object>> ingest(
            @RequestParam("facilityId") String facilityId,
            @RequestParam("file") MultipartFile file
    ) {
        return ResponseEntity.ok(ingestionService.ingestFile(facilityId, file));
    }

    @GetMapping("/vectors")
    public ResponseEntity<List<CultureVectorAdminService.VectorRow>> list(
            @RequestParam(value = "facilityId", required = false) String facilityId,
            @RequestParam(value = "limit", defaultValue = "50") int limit
    ) {
        return ResponseEntity.ok(vectorAdminService.list(facilityId, limit));
    }

    @DeleteMapping("/vectors/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable("id") String id) {
        int deleted = vectorAdminService.deleteById(id);
        return ResponseEntity.ok(Map.of("deleted", deleted, "id", id));
    }

    @DeleteMapping("/vectors")
    public ResponseEntity<Map<String, Object>> deleteByFacility(
            @RequestParam(value = "facilityId", required = false) String facilityId
    ) {
        if (StringUtils.hasText(facilityId)) {
            int deleted = vectorAdminService.deleteByFacility(facilityId);
            return ResponseEntity.ok(Map.of(
                    "deleted", deleted,
                    "facilityId", facilityId,
                    "scope", "facility"
            ));
        }

        int deleted = vectorAdminService.deleteAll();
        return ResponseEntity.ok(Map.of(
                "deleted", deleted,
                "scope", "all"
        ));
    }
}