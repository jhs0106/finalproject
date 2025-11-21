package edu.sm.controller;

import edu.sm.app.dto.SupportSession;
import edu.sm.app.service.SupportAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@RestController
@RequestMapping("/api/support")
@RequiredArgsConstructor
public class SupportRestController {

    private final SupportAdminService service;

    @GetMapping("/session")
    public ResponseEntity<List<SupportSession>> list() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/session/{id}")
    public ResponseEntity<SupportSession> get(@PathVariable String id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PostMapping("/session/{id}/reply")
    public ResponseEntity<SupportSession> reply(@PathVariable String id, @RequestBody String message) {
        return ResponseEntity.ok(service.reply(id, message));
    }

    @PostMapping("/session/{id}/close")
    public ResponseEntity<SupportSession> close(@PathVariable String id) {
        return ResponseEntity.ok(service.close(id));
    }


    @GetMapping(value = "/session/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamAll() {
        return service.subscribeAll();
    }

    @GetMapping(value = "/session/{id}/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamSession(@PathVariable String id) {
        return service.subscribeSession(id);
    }
}