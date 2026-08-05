package com.gym.aispringboot.entity;


import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("consultation_message")
@Builder
public class ConsultationMessage {
    // message ID
    @TableId(type = IdType.AUTO)
    private Long id;

    // session id
    @NotNull(message = "session id cannot be empty")
    @TableField("session_id")
    private Long sessionId;

    // sender type: 1. user 2. AI assistant
    @NotNull(message = "sender type cannot be empty")
    @TableField("sender_type")
    private Integer senderType;

    // message type: text
    @NotNull(message = "message type cannot be empty")
    @TableField("message_type")
    private Integer messageType;

    // message content
    @NotBlank(message = "Message content cannot be empty")
    private String content;

    // emotion tag
    @Size(max = 50, message = "emotion tag length cannot be more than 50")
    @TableField("emotion_tag")
    private String emotionTag;

    // AI model
    @Size(max = 50, message = "AI model length cannot be more than 50")
    @TableField("ai_model")
    private String aiModel;

    // create date time
    @TableField("created_at")
    private LocalDateTime createdAt;

    /**
     * get sender type description
     */
    public String getSenderTypeDesc() {
        if (senderType == null) {
            return "unknown";
        }
        return switch (senderType) {
            case 1 -> "user";
            case 2 -> "AI assistant";
            default -> "unknown";
        };
    }

    /**
     * get message type description
     */
    public String getMessageTypeDesc() {
        if (messageType == null) {
            return "unknown";
        }
        return switch (messageType) {
            case 1 -> "text";
            default -> "unknown";
        };
    }
}