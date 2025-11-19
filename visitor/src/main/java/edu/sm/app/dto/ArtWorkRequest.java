package edu.sm.app.dto;

import lombok.Data;

@Data
public class ArtWorkRequest {
    private String emotion;      // 사용자가 선택한 감정
    private String facility;     // 미술관 / 도서관 / 카페 / 테마파크 등
    private String sketchBase64; // data:image/png;base64,... 형식
}
