package com.gym.aispringboot.controller;

import com.gym.aispringboot.DTO.command.UserLoginCommandDTO;
import com.gym.aispringboot.DTO.command.UserRegisterCommandDTO;
import com.gym.aispringboot.DTO.response.UserLoginResponseDTO;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.service.UserService;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class User {
    @Resource
    private UserService userService;

    // login
    @PostMapping("/login")
    public Result<UserLoginResponseDTO> login(@Valid @RequestBody UserLoginCommandDTO commandDTO) {
        System.out.println(commandDTO.getUsername());
        System.out.println(commandDTO.getPassword());

        // invoke service login method
        UserLoginResponseDTO result = userService.login(commandDTO);

        return Result.ok(result);
    }

    // register
    @PostMapping("/add")
    public Result<UserLoginResponseDTO.UserDetailResponseDTO> register(@Valid @RequestBody UserRegisterCommandDTO commandDTO) {
        UserLoginResponseDTO.UserDetailResponseDTO result = userService.register(commandDTO);
        return Result.ok(result);
    }


}
