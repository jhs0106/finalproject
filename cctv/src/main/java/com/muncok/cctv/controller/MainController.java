package com.muncok.cctv.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class MainController {

    // [중요] static 리소스(css, js, favicon 등)는 제외하고 'cam'으로 시작하는 주소만 받거나
    // 충돌을 피하기 위해 파일명을 리턴값과 다르게 설정해야 합니다.
    @GetMapping("/{id}")
    public String cctvView(@PathVariable String id, Model model) {
        // "favicon.ico" 같은 시스템 요청은 무시
        if(id.contains(".")) {
            return "forward:/" + id;
        }

        model.addAttribute("cctvId", id);
        return "cctv"; // [수정] index -> cctv (templates/cctv.html을 찾음)
    }
}