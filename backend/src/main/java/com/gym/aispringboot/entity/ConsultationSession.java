package com.gym.aispringboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Data
@Table("consultation_session")
@Builder
public class ConsultationSession {
    // session id
    @TableId(type = IdType.AUTO)
    private Long id;

    // user id
    @TableField("user_id")
    private Long userId;

    // session title
    @Size(max = 200, message = "session title must be less than 200 chars")
    @TableField("session_title")
    private String sessionTitle;

    // start time
    @TableField("started_at")
    private LocalDateTime startedAt;

    //  last emotion analysis result JSON format
    @TableField("last_emotion_analysis")
    private String lastEmotionAnalysis;

    // last emotion analysis time
    @TableField("last_emotion_updated_at")
    private LocalDateTime lastEmotionUpdatedAt;
}