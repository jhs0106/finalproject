package edu.sm.app.service;

import edu.sm.app.dto.ArtWorkRequest;
import edu.sm.app.dto.ArtWorkResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.openai.OpenAiImageOptions;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Base64;

@Service
@RequiredArgsConstructor
@Slf4j
public class ArtWorkImageService {

    // 이전 예제의 ImageModel 스타일 그대로
    private final ImageModel imageModel;

    /**
     * 사용자의 스케치 PNG + 텍스트 설명을 바탕으로
     * 1) 시설 테마 배경 이미지 생성
     * 2) 흰 배경 제거한 스케치 합성
     * 3) 최종 이미지를 base64 PNG로 반환
     */
    public String generateCompositeImage(ArtWorkRequest req, ArtWorkResponse textRes) {
        try {
            if (req.getSketchBase64() == null || req.getSketchBase64().isBlank()) {
                log.warn("[ArtWorkImageService] 스케치가 없어 이미지 합성을 건너뜁니다.");
                return null;
            }

            // 1) 스케치 base64 → BufferedImage
            String sketchData = stripDataUriPrefix(req.getSketchBase64());
            byte[] sketchBytes = Base64.getDecoder().decode(sketchData);
            BufferedImage rawSketch = ImageIO.read(new ByteArrayInputStream(sketchBytes));

            if (rawSketch == null) {
                log.warn("[ArtWorkImageService] 스케치 디코딩 실패");
                return null;
            }

            // 2) 흰 배경 제거 (투명 처리)
            BufferedImage sketchTransparent = removeWhiteBackground(rawSketch);

            // 3) 배경 이미지 생성 (이미지 모델 호출)
            String imagePrompt = buildImagePrompt(req, textRes);
            String backgroundBase64 = generateBackground(imagePrompt);

            if (backgroundBase64 == null) {
                log.warn("[ArtWorkImageService] 배경 이미지 생성 실패");
                return null;
            }

            byte[] bgBytes = Base64.getDecoder().decode(backgroundBase64);
            BufferedImage background = ImageIO.read(new ByteArrayInputStream(bgBytes));

            if (background == null) {
                log.warn("[ArtWorkImageService] 배경 이미지 디코딩 실패");
                return null;
            }

            // 4) 배경 위에 스케치 합성
            BufferedImage combined = compose(background, sketchTransparent);

            // 5) 최종 PNG → base64 반환 (prefix 없이)
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            ImageIO.write(combined, "png", out);
            return Base64.getEncoder().encodeToString(out.toByteArray());

        } catch (Exception e) {
            log.error("[ArtWorkImageService] 이미지 생성/합성 중 오류", e);
            return null;
        }
    }

    /**
     * 이미지 생성용 프롬프트:
     * - 시설(facility) 테마의 배경
     * - 사용자 스케치는 우리가 합성하므로, 모델은 선 그림을 그리지 않게 안내
     */
    private String buildImagePrompt(ArtWorkRequest req, ArtWorkResponse textRes) {
        String facility = (req.getFacility() != null && !req.getFacility().isBlank())
                ? req.getFacility()
                : "문화 시설";
        String desc = textRes.getArtworkDescription() != null
                ? textRes.getArtworkDescription()
                : "";

        return """
                Create a high-quality, detailed background illustration for a %s.

                - The mood and atmosphere should match the following description (Korean): "%s"
                - Draw only the background scene (architecture, sky, lighting, environment, etc.).
                - DO NOT draw any line sketches or doodles yourself.
                - Leave some visually calm area where a user's sketch can be placed later.
                - The style should be slightly artistic and dreamy, but still clearly show that it is a %s.
                """.formatted(facility, desc, facility);
    }

    /**
     * OpenAI 이미지 모델 호출해서 배경 이미지를 base64로 생성
     * (이전 AiImageService의 generateImage 스타일을 따른다)
     */
    private String generateBackground(String prompt) {
        try {
            OpenAiImageOptions options = OpenAiImageOptions.builder()
                    .model("dall-e-3")        // 이전 예제와 동일한 모델 스타일
                    .responseFormat("b64_json")
                    .width(1024)
                    .height(1024)
                    .N(1)
                    .build();

            ImagePrompt imagePrompt = new ImagePrompt(prompt, options);
            ImageResponse imageResponse = imageModel.call(imagePrompt);

            String b64 = imageResponse.getResult().getOutput().getB64Json();
            return b64;
        } catch (Exception e) {
            log.error("[ArtWorkImageService] 배경 이미지 생성 중 오류", e);
            return null;
        }
    }

    /**
     * data:image/png;base64, ... prefix 제거
     */
    private String stripDataUriPrefix(String dataUri) {
        if (dataUri == null) return null;
        return dataUri.replaceFirst("^data:image/[^;]+;base64,", "");
    }

    /**
     * 완전한 흰색(또는 거의 흰색)에 가까운 픽셀을 투명하게 만든다.
     * → 스케치 선만 남기기 위해 사용.
     */
    private BufferedImage removeWhiteBackground(BufferedImage src) {
        int w = src.getWidth();
        int h = src.getHeight();

        BufferedImage dst = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);

        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                int rgb = src.getRGB(x, y);

                int a = (rgb >> 24) & 0xff;
                int r = (rgb >> 16) & 0xff;
                int g = (rgb >> 8) & 0xff;
                int b = (rgb) & 0xff;

                // 거의 흰색이면 투명 처리 (threshold 250)
                if (a > 0 && r > 250 && g > 250 && b > 250) {
                    dst.setRGB(x, y, 0x00000000); // 완전 투명
                } else {
                    dst.setRGB(x, y, rgb);
                }
            }
        }
        return dst;
    }

    /**
     * 배경 위에 스케치를 적당한 크기로 배치해서 합성.
     * 현재는 중앙 하단 쪽에 50~60% 크기로 배치.
     */
    private BufferedImage compose(BufferedImage background, BufferedImage sketch) {
        int bgW = background.getWidth();
        int bgH = background.getHeight();

        BufferedImage combined = new BufferedImage(bgW, bgH, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = combined.createGraphics();

        // 배경 그리기
        g.drawImage(background, 0, 0, null);

        // 스케치 스케일링 비율 계산 (배경의 약 55% 폭 차지)
        int sw = sketch.getWidth();
        int sh = sketch.getHeight();

        double maxSketchWidth = bgW * 0.55;
        double maxSketchHeight = bgH * 0.55;
        double scale = Math.min(maxSketchWidth / sw, maxSketchHeight / sh);

        int drawW = (int) (sw * scale);
        int drawH = (int) (sh * scale);

        // 위치: 중앙 하단 근처
        int x = (bgW - drawW) / 2;
        int y = (int) (bgH - drawH - bgH * 0.08); // 아래에서 살짝 위쪽

        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.drawImage(sketch, x, y, drawW, drawH, null);

        g.dispose();
        return combined;
    }
}
