package com.gym.aispringboot.DTO.response;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ConsultationMessageResponseDTO {
    // message id
    private Long id;

    // session od
    private Long sessionId;

    // sender type 1:user 2:AI assistant
    private Integer senderType;

    // sender type description
    private String senderTypeDesc;

    // message type 1:text
    private Integer messageType;

    // message type description
    private String messageTypeDesc;

    // message content
    private String content;

    // emotion tag
    private String emotionTag;

    // ai model
    private String aiModel;

    // create date time
    private LocalDateTime createdAt;

    // message content length
    private Integer contentLength;

    /**
     * message content length calculation
     */
    public void calculateContentLength() {
        this.contentLength = content != null ? content.length() : 0;
    }

}