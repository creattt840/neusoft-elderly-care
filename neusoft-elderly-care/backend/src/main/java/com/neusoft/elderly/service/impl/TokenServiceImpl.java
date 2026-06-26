package com.neusoft.elderly.service.impl;

import com.neusoft.elderly.service.TokenService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 认证令牌服务实现（基于Redis存储）
 */
@Service
public class TokenServiceImpl implements TokenService {

    private static final String TOKEN_PREFIX = "elderly:login:token:";

    private final StringRedisTemplate redisTemplate;

    @Value("${auth.token-expire-hours:24}")
    private long tokenExpireHours;

    public TokenServiceImpl(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    /** 创建登录令牌存入Redis */
    @Override
    public String createToken(Long userId) {
        String token = UUID.randomUUID().toString().replace("-", "");
        redisTemplate.opsForValue().set(
                TOKEN_PREFIX + token,
                String.valueOf(userId),
                tokenExpireHours,
                TimeUnit.HOURS
        );
        return token;
    }

    /** 根据令牌获取用户ID */
    @Override
    public Long getUserIdByToken(String token) {
        String userId = redisTemplate.opsForValue().get(TOKEN_PREFIX + token);
        if (userId == null) {
            return null;
        }
        return Long.parseLong(userId);
    }

    /** 删除令牌 */
    @Override
    public void removeToken(String token) {
        redisTemplate.delete(TOKEN_PREFIX + token);
    }
}
