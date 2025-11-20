package edu.sm.app.dto;

import lombok.Data;

@Data
public class SupportStartRequest {
    private String userName;
    private String contact;
    private boolean loggedIn;
}