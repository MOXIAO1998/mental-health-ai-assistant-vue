package com.gym.aispringboot.service;

import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.gym.aispringboot.DTO.command.UserLoginCommandDTO;
import com.gym.aispringboot.DTO.command.UserRegisterCommandDTO;
import com.gym.aispringboot.DTO.response.UserLoginResponseDTO;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.entity.User;
import com.gym.aispringboot.enumClass.UserType;
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



    public UserLoginResponseDTO.UserDetailResponseDTO register(UserRegisterCommandDTO commandDTO) {
        System.out.println(JSONUtil.parseObj(commandDTO));
        // check password and confirm password
        if (!commandDTO.getPassword().equals(commandDTO.getConfirmPassword())) {
            throw new BusinessException("password and confirm password are not the same");
        }

        // check if username already exists
        LambdaQueryWrapper<User> usernameQuery = new LambdaQueryWrapper<>();
        usernameQuery.eq(User::getUsername, commandDTO.getUsername());

        if (userMapper.selectCount(usernameQuery) > 0) {
            throw new BusinessException("username already exists");
        }


        // check email already exists
        LambdaQueryWrapper<User> emailQuery = new LambdaQueryWrapper<>();
        emailQuery.eq(User::getEmail, commandDTO.getEmail());
        if (userMapper.selectCount(emailQuery) > 0) {
            throw new BusinessException("email already exists");
        }

        // userType is 1 by default
        if (!UserType.isValidCode(commandDTO.getUserType())) {
            throw new BusinessException("userType is invalid");
        }

        // create user
        String password = commandDTO.getPassword().trim();
        String encodedPassword = passwordEncoder.encode(password);
        User user = UserConvert.registerCommandToEntity(commandDTO, encodedPassword);

        // insert to database
        userMapper.insert(user);

        return UserConvert.entityToDetailResponse(user);
    }
}
