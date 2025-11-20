package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/page")
public class PageController {

    String dir = "page/";

    @RequestMapping("/page1")
    public String ai1(Model model) {
        model.addAttribute("center", dir+"page1");
        return "index";
    }
    @RequestMapping("/ai2")
    public String ai2(Model model) {
        model.addAttribute("center", dir+"ai2");
        return "index";
    }
    @RequestMapping("/ai3")
    public String ai3(Model model) {
        model.addAttribute("center", dir+"ai3");
        return "index";
    }
    @RequestMapping("/cctv")
    public String cctv(Model model) {
        model.addAttribute("center", dir+"cctv");
        return "index";
    }

    @RequestMapping("/culture-ingest")
    public String cultureIngest(Model model) {
        model.addAttribute("center", dir+"culture-ingest");
        return "index";
    }

    @RequestMapping("/support")
    public String support(Model model) {
        model.addAttribute("center", dir + "support");
        return "index";
    }


}