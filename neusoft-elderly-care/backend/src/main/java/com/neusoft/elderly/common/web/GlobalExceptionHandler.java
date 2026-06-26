package com.neusoft.elderly.common.web;

import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.common.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.util.stream.Collectors;

/**
 * 全局异常处理器
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<String> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.joining(", "));
        return Result.error(400, message);
    }

    @ExceptionHandler(BusinessException.class)
    public Result<String> handleBusinessException(BusinessException e) {
        return Result.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public Result<String> handleIllegalArgument(IllegalArgumentException e) {
        return Result.error(400, e.getMessage());
    }

    @ExceptionHandler(IllegalStateException.class)
    public Result<String> handleIllegalState(IllegalStateException e) {
        return Result.error(400, e.getMessage());
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public Result<String> handleDataIntegrity(DataIntegrityViolationException e) {
        log.warn("数据完整性约束冲突", e);
        return Result.error(400, "存在关联数据，无法删除");
    }

    @ExceptionHandler(SQLException.class)
    public Result<String> handleSQLException(SQLException e) {
        log.error("数据库操作失败", e);
        return Result.error(500, "数据库操作失败");
    }

    @ExceptionHandler(Exception.class)
    public Result<String> handleException(Exception e) {
        log.error("系统异常", e);
        return Result.error(500, "系统繁忙，请稍后重试");
    }
}
