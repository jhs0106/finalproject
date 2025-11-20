package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SupportSession {
    private String id;
    private String userName;
    private String contact;
    private boolean loggedIn;
    private String status;
    @Builder.Default
    private List<SupportChatMessage> messages = new ArrayList<>();
}