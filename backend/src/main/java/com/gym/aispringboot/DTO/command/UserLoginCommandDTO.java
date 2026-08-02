package com.gym.aispringboot.DTO.command;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserLoginCommandDTO {
    @NotBlank(message = "username or email cannot be empty")
    @Size(max = 100, message = "username or email length must be less than 100")
    private String username;

    @NotBlank(message = "password cannot be empty")
    @Size(min = 6, max = 50, message = "password length must be between 6 and 50")
    private String password;
}
