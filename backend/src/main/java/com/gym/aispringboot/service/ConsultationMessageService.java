package com.gym.aispringboot.service;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.aispringboot.DTO.response.ConsultationMessageResponseDTO;
import com.gym.aispringboot.entity.ConsultationMessage;
import com.gym.aispringboot.mapper.ConsultationMessageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class ConsultationMessageService {
    @Autowired
    private ConsultationMessageMapper consultationMessageMapper;

    public ConsultationMessage saveUserMessage(Long sessionId, String content, String emotion_tag) {
        // construct user message entity
        ConsultationMessage userMessage = ConsultationMessage.builder().sessionId(sessionId).senderType(1).messageType(1).content(content).emotionTag(emotion_tag).createdAt(LocalDateTime.now()).build();

        consultationMessageMapper.insert(userMessage);
        return userMessage;

    }

    public Integer getMessageCountBySessionId(Long sessionId) {
        LambdaQueryWrapper<ConsultationMessage> queryWrapper = new LambdaQueryWrapper<>();

        queryWrapper.eq(ConsultationMessage::getSessionId, sessionId);

        Long count = consultationMessageMapper.selectCount(queryWrapper);
        return count.intValue();

    }

    // get the last message of a session
    public ConsultationMessageResponseDTO getLastMessageBySessionId(Long sessionId) {
        LambdaQueryWrapper<ConsultationMessage> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(ConsultationMessage::getSessionId, sessionId).orderByDesc(ConsultationMessage::getCreatedAt).last("limit 1");
        ConsultationMessage lastMessage = consultationMessageMapper.selectOne(queryWrapper);
        return lastMessage != null ? convertToResponseDTO(lastMessage) : null;
    }

    private ConsultationMessageResponseDTO convertToResponseDTO(ConsultationMessage message) {
        if (message == null) {
            return null;
        }

        ConsultationMessageResponseDTO responseDTO = new ConsultationMessageResponseDTO();
        responseDTO.setId(message.getId());
        responseDTO.setSessionId(message.getSessionId());
        responseDTO.setSenderType(message.getSenderType());
        responseDTO.setMessageType(message.getMessageType());
        responseDTO.setContent(message.getContent());
        responseDTO.setEmotionTag(message.getEmotionTag());
        responseDTO.setAiModel(message.getAiModel());
        responseDTO.setCreatedAt(message.getCreatedAt());

        // set description
        responseDTO.setSenderTypeDesc(message.getSenderTypeDesc());
        responseDTO.setMessageTypeDesc(message.getMessageTypeDesc());

        // calculate content length
        responseDTO.calculateContentLength();

        return responseDTO;
    }


    public ConsultationMessage saveAiMessage(Long sessionId, String content, String aiModel) {
        ConsultationMessage aiMessage = ConsultationMessage.builder().
                sessionId(sessionId).
                senderType(2).
                messageType(1).
                content(content).
                aiModel(aiModel).
                createdAt(LocalDateTime.now()).
                build();
        // insert to database
        consultationMessageMapper.insert(aiMessage);
        return aiMessage;
    }


}
