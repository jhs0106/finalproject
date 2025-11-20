package edu.sm.controller;

import edu.sm.app.dto.SupportMessageRequest;
import edu.sm.app.dto.SupportSession;
import edu.sm.app.dto.SupportStartRequest;
import edu.sm.app.service.SupportChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/support")
@RequiredArgsConstructor
public class SupportRestController {

    private final SupportChatService service;

    @PostMapping("/session")
    public ResponseEntity<SupportSession> start(@RequestBody SupportStartRequest request) {
        return ResponseEntity.ok(service.startSession(request));
    }

    @PostMapping("/session/{id}/message")
    public ResponseEntity<SupportSession> message(
            @PathVariable String id,
            @RequestBody SupportMessageRequest request
    ) {
        return ResponseEntity.ok(service.handleMessage(id, request));
    }

    @GetMapping("/session/{id}")
    public ResponseEntity<SupportSession> get(@PathVariable String id) {
        return ResponseEntity.ok(service.getSession(id));
    }
}