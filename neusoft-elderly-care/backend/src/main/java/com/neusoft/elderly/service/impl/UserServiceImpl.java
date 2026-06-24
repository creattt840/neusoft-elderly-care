package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.dto.UserLoginDTO;
import com.neusoft.elderly.dto.UserRegisterDTO;
import com.neusoft.elderly.entity.User;
import com.neusoft.elderly.mapper.UserMapper;
import com.neusoft.elderly.service.TokenService;
import com.neusoft.elderly.service.UserService;
import com.neusoft.elderly.vo.UserVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private TokenService tokenService;

    @Override
    public User findByPhone(String phone) {
        return baseMapper.selectByPhone(phone);
    }

    @Override
    public UserVO register(UserRegisterDTO registerDTO) {
        User existUser = findByPhone(registerDTO.getPhone());
        if (existUser != null) {
            throw new BusinessException("手机号已注册");
        }

        User user = new User();
        BeanUtils.copyProperties(registerDTO, user);
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setStatus(1);
        save(user);
        return toUserVO(user);
    }

    @Override
    public Map<String, Object> loginWithToken(UserLoginDTO loginDTO) {
        User user = authenticate(loginDTO);
        String token = tokenService.createToken(user.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", toUserVO(user));
        return result;
    }

    @Override
    public void logout(String token) {
        if (StringUtils.hasText(token)) {
            tokenService.removeToken(token);
        }
    }

    private User authenticate(UserLoginDTO loginDTO) {
        User user = findByPhone(loginDTO.getPhone());
        if (user == null) {
            throw new BusinessException("手机号或密码错误");
        }
        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException("手机号或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException("账号已禁用");
        }
        return user;
    }

    private UserVO toUserVO(User user) {
        UserVO vo = new UserVO();
        vo.setId(user.getId());
        vo.setPhone(user.getPhone());
        vo.setRealName(user.getRealName());
        vo.setAge(user.getAge());
        vo.setGender(user.getGender());
        vo.setStatus(user.getStatus());
        vo.setLastLoginTime(user.getLastLoginTime());
        vo.setCreateTime(user.getCreateTime());
        vo.setUpdateTime(user.getUpdateTime());
        return vo;
    }
}
