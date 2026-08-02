package com.gym.aispringboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.aispringboot.DTO.command.UserLoginCommandDTO;
import com.gym.aispringboot.DTO.response.UserLoginResponseDTO;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.entity.User;
import com.gym.aispringboot.exception.BusinessException;
import com.gym.aispringboot.mapper.UserMapper;
import com.gym.aispringboot.service.convert.UserConvert;
import com.gym.aispringboot.util.JwtTokenUtil;
import jakarta.annotation.Resource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Resource
    private UserMapper userMapper;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserLoginResponseDTO login(UserLoginCommandDTO commandDTO) {
        // construct query
        LambdaQueryWrapper<User> queryWapper = new LambdaQueryWrapper<>();
        queryWapper.eq(User::getUsername, commandDTO.getUsername())
                .or().eq(User::getEmail, commandDTO.getUsername());

        // invoke MyBatis Plus API to query
        User user = userMapper.selectOne(queryWapper);

        // validate user if exists
        if (user == null) {
            throw new BusinessException("user not found");
        }
        // validate password
        String inputPassword = commandDTO.getPassword().trim();
        if (!passwordEncoder.matches(inputPassword, user.getPassword())) {
            throw new BusinessException("password is incorrect");
        }

        // validate status
        if (!user.isActive()) {
            throw new BusinessException("user is forbidden to login, please contact admin");
        }

        // generate JWT token
        String token = JwtTokenUtil.generateToken(user.getId(), user.getUsername(), user.getUserType());
        System.out.println(token);
        UserLoginResponseDTO.UserDetailResponseDTO userInfo = UserConvert.entityToDetailResponse(user);


        return UserConvert.entityToLoginResponse(token, userInfo);
    }
}
