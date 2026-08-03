package com.gym.aispringboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.gym.aispringboot.enumClass.UserStatus;
import com.gym.aispringboot.enumClass.UserType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("user")
@Builder
public class User {
    // user id
    @TableId(type = IdType.AUTO)
    private Long id;

    // username
    @NotBlank(message = "username or email cannot be empty")
    @Size(min = 3, max = 50, message = "username length must be between 3 and 50 chars.")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "username must only contain alphabets, numbers, and underlines.")
    private String username;

    // email
    @NotBlank(message = "email cannot be empty")
    @Email(message = "incorrect email format")
    @Size(max = 100, message = "email cannot be more than 100 chars")
    private String email;

    // phone
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "invalid phone number format")
    private String phone;

    // password
    @NotBlank(message = "password cannot be empty")
    @Size(min = 6, max = 255, message = "password length must be between 6 to 255 chars")
    private String password;

    // nickname
    @Size(max = 50, message = "nickname length cannot be more than 50 chars")
    private String nickname;

    // avatar
    @Size(max = 255, message = "avatar path length cannot be more than 255 chars")
    private String avatar;

    // gender
    private Integer gender;

    // birthday
    private LocalDate birthday;

    // userType 1:normal user 2:manager
    @TableField("user_type")
    private Integer userType;

    // status 0:disabled 1:normal
    private Integer status;

    // create date time
    @TableField("created_at")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    private LocalDateTime updatedAt;

    /**
     * isUser
     */
    public boolean isUser() {
        return UserType.USER.getCode().equals(this.userType);
    }

    /**
     * isActive
     */
    public boolean isActive() {
        return UserStatus.NORMAL.getCode().equals(this.status);
    }

    /**
     * isDisabled
     */
    public boolean isDisabled() {
        return UserStatus.DISABLED.getCode().equals(this.status);
    }

    /**
     * getDisplayName（priority for nickname，otherwise username）
     */
    public String getDisplayName() {
        return nickname != null && !nickname.trim().isEmpty() ? nickname : username;
    }

    /**
     * getUserTypeDisplayName
     */
    public String getUserTypeDisplayName() {
        try {
            return UserType.fromCode(userType).getDescription();
        } catch (IllegalArgumentException e) {
            return "unknown";
        }
    }

    /**
     * getStatusDisplayName
     */
    public String getStatusDisplayName() {
        try {
            return UserStatus.fromCode(status).getDescription();
        } catch (IllegalArgumentException e) {
            return "unknown";
        }
    }


}
