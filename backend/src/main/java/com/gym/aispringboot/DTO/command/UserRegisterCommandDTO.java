package com.gym.aispringboot.DTO.command;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserRegisterCommandDTO {
    @NotBlank(message = "username cannot be empty")
    @Size(min = 3, max = 50, message = "username length must be between 3 and 50")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "username must only contain alphabets, numbers, and underlines")
    private String username;

    @NotBlank(message = "email cannot be empty")
    @Email(message = "incorrect email format")
    @Size(max = 100, message = "email cannot be more than 100")
    private String email;

    @Size(max = 50, message = "nickname length cannot be more than 50")
    private String nickname;

    @Pattern(regexp = "^\\d{10}$", message = "phone format is incorrect")
    private String phone;

    @NotBlank(message = "password cannot be empty")
    @Size(min = 6, max = 50, message = "password length must be between 6 to 50")
    private String password;

    @NotBlank(message = "confirm password cannot be empty")
    private String confirmPassword;

    private Integer gender;
    private Integer userType = 1;

}
