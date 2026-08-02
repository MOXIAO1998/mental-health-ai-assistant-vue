package com.gym.aispringboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gym.aispringboot.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {

}
