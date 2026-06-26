package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.dto.UserLoginDTO;
import com.neusoft.elderly.dto.UserRegisterDTO;
import com.neusoft.elderly.entity.User;
import com.neusoft.elderly.vo.UserVO;

import java.util.Map;

/**
 * 用户服务接口
 */
public interface UserService extends IService<User> {

    /**
     * 根据手机号查询用户
     */
    User findByPhone(String phone);

    /**
     * 用户注册
     */
    UserVO register(UserRegisterDTO registerDTO);

    /**
     * 用户登录（返回令牌）
     */
    Map<String, Object> loginWithToken(UserLoginDTO loginDTO);

    /**
     * 用户登出（清除令牌）
     */
    void logout(String token);
}
