package com.gym.aispringboot.controller;

import com.gym.aispringboot.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api")
public class Test {
    @GetMapping("/test")
    public Result<String> test() {
//        Result result = new Result();
//        result.setCode("200");
        return Result.ok();
    }
}
