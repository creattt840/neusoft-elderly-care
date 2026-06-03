package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.AuthTokenUtils;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.dto.UserLoginDTO;
import com.neusoft.elderly.dto.UserRegisterDTO;
import com.neusoft.elderly.service.UserService;
import com.neusoft.elderly.vo.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<UserVO> register(@Valid @RequestBody UserRegisterDTO registerDTO) {
        return Result.success(userService.register(registerDTO));
    }

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@Valid @RequestBody UserLoginDTO loginDTO) {
        return Result.success(userService.loginWithToken(loginDTO));
    }

    @PostMapping("/logout")
    public Result<Void> logout(HttpServletRequest request) {
        userService.logout(AuthTokenUtils.extractToken(request));
        return Result.success();
    }
}
