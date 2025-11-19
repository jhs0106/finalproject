package edu.sm.app.dto;

import lombok.Data;

@Data
public class ArtWorkRequest {
    private String emotion;
    private String facility;
    private String sketchBase64;
}
