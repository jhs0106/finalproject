package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/map")
public class MapController {

    String dir = "map/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "map");
        return "index";
    }
}