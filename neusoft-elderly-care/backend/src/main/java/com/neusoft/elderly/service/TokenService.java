package com.neusoft.elderly.service;

public interface TokenService {

    String createToken(Long userId);

    Long getUserIdByToken(String token);

    void removeToken(String token);
}
