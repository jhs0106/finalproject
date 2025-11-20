package edu.sm.app.dto;

import lombok.Data;

@Data
public class ArtWorkResponse {
    private String artworkDescription;  // AI 작품 설명
    private String curatorComment;      // 큐레이터 멘트
    private String exhibitionNote;      // 작가의 전시 노트
    private String imageBase64;         // 합성된 최종 이미지 (PNG, prefix 없이 base64)

}
