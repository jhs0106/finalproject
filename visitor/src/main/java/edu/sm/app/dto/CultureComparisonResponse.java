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
public class CultureComparisonResponse {
    private String baseTitle;
    private String regionLabel;
    private String summary;
    private String dataset;
    private int contextCount;
    private List<Integer> regionMetrics;
}