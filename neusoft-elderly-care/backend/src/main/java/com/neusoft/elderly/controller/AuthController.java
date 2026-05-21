package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.User;
import com.neusoft.elderly.service.UserService;
import com.neusoft.elderly.config.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public Result<User> register(@RequestBody User user) {
        User existUser = userService.findByPhone(user.getPhone());
        if (existUser != null) {
            return Result.error("手机号已注册");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setStatus(1);
        userService.save(user);
        return Result.success(user);
    }

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody User loginUser) {
        User user = userService.findByPhone(loginUser.getPhone());
        if (user == null || !passwordEncoder.matches(loginUser.getPassword(), user.getPassword())) {
            return Result.error("手机号或密码错误");
        }
        if (user.getStatus() == 0) {
            return Result.error("账号已禁用");
        }

        String token = jwtUtil.generateToken(user.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", user);
        return Result.success(result);
    }
}
