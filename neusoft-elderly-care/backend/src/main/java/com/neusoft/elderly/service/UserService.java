package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.dto.UserLoginDTO;
import com.neusoft.elderly.dto.UserRegisterDTO;
import com.neusoft.elderly.entity.User;
import com.neusoft.elderly.vo.UserVO;

import java.util.Map;

public interface UserService extends IService<User> {

    User findByPhone(String phone);

    UserVO register(UserRegisterDTO registerDTO);

    Map<String, Object> loginWithToken(UserLoginDTO loginDTO);

    void logout(String token);
}
