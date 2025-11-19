
package edu.sm.app.springai;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CultureVectorAdminService {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final TypeReference<Map<String, Object>> MAP_TYPE_REFERENCE = new TypeReference<>() {
    };

    private final JdbcTemplate jdbcTemplate;
    private final VectorStore vectorStore;

    public List<VectorRow> list(String facilityId, int limit) {
        StringBuilder sql = new StringBuilder("select id, metadata, content from vector_store");
        List<Object> params = new ArrayList<>();
        if (StringUtils.hasText(facilityId)) {
            sql.append(" where metadata ->> 'facilityId' = ?");
            params.add(facilityId);
        }
        sql.append(" order by id desc limit ?");
        params.add(limit);

        return jdbcTemplate.query(sql.toString(), params.toArray(), new VectorRowMapper());
    }

    public int deleteById(String documentId) {
        vectorStore.delete(List.of(documentId));
        return 1;
    }

    public int deleteByFacility(String facilityId) {
        List<String> ids = jdbcTemplate.query(
                "select id from vector_store where metadata ->> 'facilityId' = ?",
                (rs, rowNum) -> rs.getString("id"),
                facilityId
        );

        if (ids.isEmpty()) {
            return 0;
        }
        vectorStore.delete(ids);
        return ids.size();
    }
    public int deleteAll() {
        Integer count = jdbcTemplate.queryForObject("select count(*) from vector_store", Integer.class);
        jdbcTemplate.update("TRUNCATE TABLE vector_store");
        return count != null ? count : 0;
    }

    public record VectorRow(String id, String facilityId, String filename, String contentPreview, Map<String, Object> metadata) {
    }

    private static class VectorRowMapper implements RowMapper<VectorRow> {

        @Override
        public VectorRow mapRow(ResultSet rs, int rowNum) throws SQLException {
            String id = rs.getString("id");
            String content = rs.getString("content");
            Map<String, Object> metadata = parseMetadata(rs.getString("metadata"));
            String facilityId = (String) metadata.getOrDefault("facilityId", "");
            String filename = (String) metadata.getOrDefault("filename", "");
            return new VectorRow(id, facilityId, filename, preview(content), metadata);
        }

        private Map<String, Object> parseMetadata(String metadataJson) throws SQLException {
            try {
                return OBJECT_MAPPER.readValue(metadataJson, MAP_TYPE_REFERENCE);
            } catch (Exception e) {
                throw new SQLException("Failed to parse metadata", e);
            }
        }

        private String preview(String content) {
            if (content == null) {
                return "";
            }
            return content.length() > 120 ? content.substring(0, 120) + "…" : content;
        }
    }
}