package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArtifactContext {
    private String id;
    private String title;
    private String era;
    private String country;
    private String hall;
    private List<String> vectorTopics;
    private List<String> highlights;
    private List<String> neighbors;
}