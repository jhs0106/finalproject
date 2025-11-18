package edu.sm.controller;

import edu.sm.app.dto.ArtWorkRequest;
import edu.sm.app.dto.ArtWorkResponse;
import edu.sm.app.service.ArtWorkService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/artwork")
@RequiredArgsConstructor
public class ArtWorkRestController {

//    private final ArtWorkService service;

//    @PostMapping("/generate")
//    public ArtWorkResponse generate(@RequestBody ArtWorkRequest req) {
//        return service.generateArtwork(req);
//        return ;
//    }
}
