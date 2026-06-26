package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.utils.AuthTokenUtils;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.dto.UserLoginDTO;
import com.neusoft.elderly.dto.UserRegisterDTO;
import com.neusoft.elderly.service.UserService;
import com.neusoft.elderly.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 认证接口（注册/登录/登出）
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    /** 用户注册 */
    @PostMapping("/register")
    public Result<UserVO> register(@Valid @RequestBody UserRegisterDTO registerDTO) {
        return Result.success(userService.register(registerDTO));
    }

    /** 用户登录 */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@Valid @RequestBody UserLoginDTO loginDTO) {
        return Result.success(userService.loginWithToken(loginDTO));
    }

    /** 用户登出 */
    @PostMapping("/logout")
    public Result<Void> logout(HttpServletRequest request) {
        userService.logout(AuthTokenUtils.extractToken(request));
        return Result.success();
    }
}
