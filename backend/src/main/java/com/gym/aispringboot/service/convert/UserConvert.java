package com.gym.aispringboot.service.convert;

import com.gym.aispringboot.DTO.response.UserLoginResponseDTO;
import com.gym.aispringboot.entity.User;

public class UserConvert {
    // construct response DTO
    public static UserLoginResponseDTO.UserDetailResponseDTO entityToDetailResponse(User user) {
        return UserLoginResponseDTO.UserDetailResponseDTO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .phone(user.getPhone())
                .gender(user.getGender())
                .genderDisplayName(getGenderDisplayName(user.getGender()))
                .birthday(user.getBirthday())
                .userType(user.getUserType())
                .userTypeDisplayName(user.getUserTypeDisplayName())
                .status(user.getStatus())
                .statusDisplayName(user.getStatusDisplayName())
                .displayName(user.getDisplayName())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .build();
    }


    public static UserLoginResponseDTO entityToLoginResponse(String token, UserLoginResponseDTO.UserDetailResponseDTO userInfo){
        return UserLoginResponseDTO.builder().
                userInfo(userInfo).
                token(token).
                roleType(userInfo.getUserType().toString()).
                build();
    }


    private static String getGenderDisplayName(Integer gender) {
        if (gender == null) {
            return "Unknown";
        }
        switch (gender) {
            case 1:
                return "Male";
            case 2:
                return "Female";
            default:
                return "Unknown";
        }
    }
}
