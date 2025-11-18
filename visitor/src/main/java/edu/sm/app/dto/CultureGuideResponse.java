package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CultureGuideResponse {
    private String artifactId;
    private String title;
    private String era;
    private String summary;
    private String ttsScript;
    private int contextCount;
    private long latencyMs;
}