package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
public class MapController {

    @RequestMapping("/map")
    public String map(Model model) {
        model.addAttribute("center", "map");
        return "index";
    }
}
