package com.gym.aispringboot.controller;

import com.auth0.jwt.interfaces.DecodedJWT;
import com.gym.aispringboot.AiService.PsychologicalSupportService;
import com.gym.aispringboot.AiService.StructOuput;
import com.gym.aispringboot.DTO.command.ConsultationSessionCreateDTO;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.util.JwtTokenUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/psychological-chat")
public class PsychologicalChat {
    @Autowired
    private PsychologicalSupportService psychologicalSupportService;

    @PostMapping("/session/start")
    public Result<StructOuput.StreamChatSession> startSession(@Valid @RequestBody ConsultationSessionCreateDTO createDTO) {
        // get current User
        String token = JwtTokenUtil.getCurrentToken();
        DecodedJWT jwt = JwtTokenUtil.verifyToken(token);
        Long userId = jwt.getClaim("userId").asLong();
        psychologicalSupportService.startSession(userId, createDTO);

    }
}
