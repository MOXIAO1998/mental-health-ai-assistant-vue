package com.gym.aispringboot.enumClass;

import lombok.Getter;

@Getter
public enum UserType {

    USER(1, "Normal User"),
    ADMIN(2, "Manager");

    private final Integer code;
    private final String description;

    UserType(Integer code, String description) {
        this.code = code;
        this.description = description;
    }

    /**
     * get enumeration by code
     */
    public static UserType fromCode(Integer code) {
        for (UserType type : UserType.values()) {
            if (type.getCode().equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown UserType code: " + code);
    }

    /**
     * validate code
     */
    public static boolean isValidCode(Integer code) {
        for (UserType type : UserType.values()) {
            if (type.getCode().equals(code)) {
                return true;
            }
        }
        return false;
    }
}