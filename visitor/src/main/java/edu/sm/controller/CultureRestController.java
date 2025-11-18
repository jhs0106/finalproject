package edu.sm.controller;

import edu.sm.app.dto.CultureComparisonRequest;
import edu.sm.app.dto.CultureComparisonResponse;
import edu.sm.app.dto.CultureContextResponse;
import edu.sm.app.dto.CultureGuideRequest;
import edu.sm.app.dto.CultureGuideResponse;
import edu.sm.app.springai.CultureAiService;
import edu.sm.app.springai.CultureContentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/culture", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class CultureRestController {

    private final CultureAiService cultureAiService;
    private final CultureContentRepository repository;

    @GetMapping("/context")
    public CultureContextResponse context() {
        return CultureContextResponse.builder()
                .artifacts(repository.getArtifacts())
                .comparisons(repository.getComparisons())
                .ragHints(repository.getRagHints())
                .build();
    }

    @PostMapping("/guide")
    public CultureGuideResponse guide(@RequestBody CultureGuideRequest request) {
        return cultureAiService.generateGuide(request);
    }

    @PostMapping("/compare")
    public CultureComparisonResponse compare(@RequestBody CultureComparisonRequest request) {
        return cultureAiService.compareEra(request);
    }
}