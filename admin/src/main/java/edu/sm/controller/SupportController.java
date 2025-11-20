package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/support")
public class SupportController {

    String dir = "page/";

    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir + "support");
        return "index";
    }
}