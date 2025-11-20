package edu.sm.controller;

import edu.sm.app.dto.ArtWorkRequest;
import edu.sm.app.dto.ArtWorkResponse;
import edu.sm.app.service.ArtWorkService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/artwork")
@RequiredArgsConstructor
public class ArtWorkRestController {

    private final ArtWorkService service;

    @PostMapping("/generate")
    public ResponseEntity<ArtWorkResponse> generate(@RequestBody ArtWorkRequest req) {

        // 1) 프론트에서 날아온 원본 요청 로그
//        log.info("[ArtWorkRestController] /api/artwork/generate 요청 body = {}", req);

        ArtWorkResponse res = service.generateArtwork(req);

        // 2) 최종 클라이언트로 나가는 응답 로그
//        log.info("[ArtWorkRestController] /api/artwork/generate 응답 = {}", res);

        return ResponseEntity.ok(res);
    }
}
