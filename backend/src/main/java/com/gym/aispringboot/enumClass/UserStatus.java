package com.gym.aispringboot.enumClass;

import lombok.Getter;

@Getter
public enum UserStatus {

    DISABLED(0, "Forbidden"),
    NORMAL(1, "Normal");

    private final Integer code;
    private final String description;

    UserStatus(Integer code, String description) {
        this.code = code;
        this.description = description;
    }

    /**
     * get enumeration by code
     */
    public static UserStatus fromCode(Integer code) {
        for (UserStatus status : UserStatus.values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("unknown status code: " + code);
    }
}