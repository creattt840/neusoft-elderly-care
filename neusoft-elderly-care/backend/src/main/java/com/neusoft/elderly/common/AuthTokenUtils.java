package com.neusoft.elderly.common;

import jakarta.servlet.http.HttpServletRequest;

public final class AuthTokenUtils {

    private AuthTokenUtils() {
    }

    public static String extractToken(HttpServletRequest request) {
        return extractToken(request.getHeader("Authorization"));
    }

    public static String extractToken(String authorization) {
        if (authorization == null || authorization.isBlank()) {
            return null;
        }
        if (authorization.startsWith("Bearer ")) {
            return authorization.substring(7).trim();
        }
        return authorization.trim();
    }
}
