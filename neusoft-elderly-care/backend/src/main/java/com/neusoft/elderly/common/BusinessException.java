package com.neusoft.elderly.common;

/**
 * 业务异常类
 * <p>
 * 所有业务校验失败、业务规则违反等情况应抛出此异常，
 * 由 {@link GlobalExceptionHandler} 统一拦截处理。
 */
public class BusinessException extends RuntimeException {

    private final Integer code;

    public BusinessException(String message) {
        super(message);
        this.code = 400;
    }

    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }
}
