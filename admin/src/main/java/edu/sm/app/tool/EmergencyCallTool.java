package edu.sm.app.tool;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Component;

/**
 * Spring AI tool that simulates contacting emergency services when a disaster is detected.
 */
@Component
@Slf4j
public class EmergencyCallTool {

    @Tool(description = "화재, 사고 등 재난 상황 감지 시 119에 신고하는 시뮬레이션을 수행합니다.")
    public String call119(
            @ToolParam(description = "감지된 재난 유형 (예: 화재, 붕괴, 사고)", required = true) String disasterType,
            @ToolParam(description = "상황 또는 위치 설명", required = true) String location) {
        String confirmation = String.format(
                "119에 신고하는 중... [시뮬레이션] 재난 유형: %s, 위치/상황: %s",
                disasterType,
                location
        );
        log.warn(confirmation);
        return "🚨 " + confirmation;
    }
}