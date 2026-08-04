package com.gym.aispringboot.service;

import cn.hutool.core.date.DateUnit;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.gym.aispringboot.DTO.command.ConsultationSessionCreateDTO;
import com.gym.aispringboot.entity.ConsultationSession;
import com.gym.aispringboot.entity.User;
import com.gym.aispringboot.mapper.ConsultationSessionMapper;
import com.gym.aispringboot.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class ConsultationSessionService {
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ConsultationSessionMapper consultationSessionMapper;

    public ConsultationSession createSession(Long userId, ConsultationSessionCreateDTO createDTO) {
        // validate the user
        User user = userMapper.selectById(userId);
        if (user != null) {
            // create a session record
            ConsultationSession session = ConsultationSession.builder().
                    userId(userId).
                    sessionTitle(createDTO.getSessionTitle()).
                    startedAt(LocalDateTime.now()).
                    build();
            // if title is not provided
            if (StrUtil.isBlank(createDTO.getSessionTitle())) {
                session.setSessionTitle("AI Assistant" + DateUtil.format(LocalDateTime.now(), "MM-dd HH:mm"));
            }

            // insert into database
            consultationSessionMapper.insert(session);
            return session;


        }

        return null;
    }
}
