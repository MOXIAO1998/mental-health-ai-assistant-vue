package com.gym.aispringboot.DTO.command;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ConsultationStreamDTO {
    @NotBlank(message = "sessionId cannot be empty")
    private String sessionId;

    @NotBlank(message = "userMessage (initial message) cannot be empty")
    @Size(max = 2000, message = "userMessage length must be less than 2000")
    private String userMessage;
}
