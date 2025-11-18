package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CultureContextResponse {
    private List<ArtifactContext> artifacts;
    private Map<String, ComparisonDataset> comparisons;
    private List<String> ragHints;
}