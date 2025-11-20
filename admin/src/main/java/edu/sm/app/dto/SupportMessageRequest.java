package edu.sm.app.dto;

import lombok.Data;

@Data
public class SupportMessageRequest {
    private String message;
    private boolean handoff;
}