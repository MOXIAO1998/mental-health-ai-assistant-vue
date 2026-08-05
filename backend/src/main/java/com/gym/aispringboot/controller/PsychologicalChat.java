package com.gym.aispringboot.controller;

import cn.hutool.json.JSONUtil;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.gym.aispringboot.AiService.PsychologicalSupportService;
import com.gym.aispringboot.AiService.StructOutput;
import com.gym.aispringboot.DTO.command.ConsultationSessionCreateDTO;
import com.gym.aispringboot.DTO.command.ConsultationStreamDTO;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.common.ResultCode;
import com.gym.aispringboot.util.JwtTokenUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.support.SessionStatus;
import reactor.core.publisher.Flux;

import java.time.Duration;
import java.util.Map;

@RestController
@RequestMapping("/api/psychological-chat")
public class PsychologicalChat {
    @Autowired
    private PsychologicalSupportService psychologicalSupportService;

    @PostMapping("/session/start")
    public Result<StructOutput.StreamChatSession> startSession(@Valid @RequestBody ConsultationSessionCreateDTO createDTO, SessionStatus sessionStatus) {
        // get current User
        String token = JwtTokenUtil.getCurrentToken();
        DecodedJWT jwt = JwtTokenUtil.verifyToken(token);
        Long userId = jwt.getClaim("userId").asLong();
        StructOutput.StreamChatSession session = psychologicalSupportService.startSession(userId, createDTO);
        return Result.ok(session);

    }

    @PostMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<String>> streamChat(@Valid @RequestBody ConsultationStreamDTO streamDTO) {
        String token = JwtTokenUtil.getCurrentToken();
        DecodedJWT jwt = JwtTokenUtil.verifyToken(token);
        Long userId = jwt.getClaim("userId").asLong();

        if (userId == null) {
            return Flux.just(ServerSentEvent.<String>builder()
                    .event("error")
                    .data(JSONUtil.toJsonStr(Result.error(ResultCode.UNAUTHORIZED.getCode(), ResultCode.UNAUTHORIZED.getMsg(), "user has not login yet")))
                    .build()
            );
        }

        // start streamed chat
        return psychologicalSupportService.streamPsychologicalChat(streamDTO.getSessionId(), streamDTO.getUserMessage())
                .map(Fragment -> {
                    return ServerSentEvent.<String>builder()
                            .event("message")
                            .data(JSONUtil.toJsonStr(Result.ok(Map.of("content", Fragment, "type", "normal"))))
                            .build();
                })
                .concatWith(Flux.just(ServerSentEvent.<String>builder()
                        .event("done")
                        .data("{}")
                        .build()
                ))
                .delayElements(Duration.ofMillis(50)); // add delay to make sure the client can receive the message as streamed experience
    }
}
