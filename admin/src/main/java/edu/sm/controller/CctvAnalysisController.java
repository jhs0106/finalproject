package edu.sm.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;
import edu.sm.app.service.CctvAnalysisService;

import java.io.IOException;

@RestController
@RequestMapping("/cctv/api")
@RequiredArgsConstructor
@Slf4j
public class CctvAnalysisController {

    private final CctvAnalysisService cctvAnalysisService;

    @CrossOrigin(origins = "*", allowedHeaders = "*")
    @PostMapping(value = "/analysis", produces = MediaType.APPLICATION_NDJSON_VALUE)
    public Flux<String> analyzeSnapshot(
            @RequestParam("question") String question,
            @RequestParam("attach") MultipartFile attach
    ) throws IOException {
        if (attach == null || attach.isEmpty() || attach.getContentType() == null || !attach.getContentType().startsWith("image/")) {
            log.warn("Invalid attachment received for CCTV analysis. Returning NO_DISASTER_DETECTED.");
            return Flux.just("NO_DISASTER_DETECTED");
        }

        return cctvAnalysisService.analyzeAndRespond(question, attach.getContentType(), attach.getBytes());
    }
}