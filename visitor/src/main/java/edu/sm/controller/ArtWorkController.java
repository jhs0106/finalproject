package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/artwork")
public class ArtWorkController {

    String dir = "artwork/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "artwork");
        return "index";
    }

    @RequestMapping("/ai1")
    public String ai1(Model model) {
        model.addAttribute("center", dir+"ai1");
        return "index";
    }
}