package com.neusoft.elderly.service;

/**
 * 认证令牌服务接口
 */
public interface TokenService {

    /**
     * 为用户创建登录令牌
     */
    String createToken(Long userId);

    /**
     * 根据令牌获取用户ID
     */
    Long getUserIdByToken(String token);

    /**
     * 删除令牌（登出）
     */
    void removeToken(String token);
}
