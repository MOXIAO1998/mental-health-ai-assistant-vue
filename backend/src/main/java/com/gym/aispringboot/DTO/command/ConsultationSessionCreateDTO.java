package com.gym.aispringboot.DTO.command;


import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ConsultationSessionCreateDTO {
    @Size(max = 200, message = "session title length must be less than 200")
    private String sessionTitle;

    @NotNull(message = "initial message cannot be empty")
    @Size(max = 2000, message = "initial message length must be less than 2000")
    private String initialMessage;
}
