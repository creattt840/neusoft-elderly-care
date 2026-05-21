package com.neusoft.elderly.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("outing")
public class Outing {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long elderlyId;
    private Integer outingType;
    private LocalDateTime startTime;
    private LocalDateTime expectedReturnTime;
    private LocalDateTime actualReturnTime;
    private String accompanier;
    private String accompanierPhone;
    private String destination;
    private String reason;
    private Integer status;
    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
    public Long getElderlyId() {
        return elderlyId;
    }

    public void setElderlyId(Long elderlyId) {
        this.elderlyId = elderlyId;
    }
    public Integer getOutingType() {
        return outingType;
    }

    public void setOutingType(Integer outingType) {
        this.outingType = outingType;
    }
    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }
    public LocalDateTime getExpectedReturnTime() {
        return expectedReturnTime;
    }

    public void setExpectedReturnTime(LocalDateTime expectedReturnTime) {
        this.expectedReturnTime = expectedReturnTime;
    }
    public LocalDateTime getActualReturnTime() {
        return actualReturnTime;
    }

    public void setActualReturnTime(LocalDateTime actualReturnTime) {
        this.actualReturnTime = actualReturnTime;
    }
    public String getAccompanier() {
        return accompanier;
    }

    public void setAccompanier(String accompanier) {
        this.accompanier = accompanier;
    }
    public String getAccompanierPhone() {
        return accompanierPhone;
    }

    public void setAccompanierPhone(String accompanierPhone) {
        this.accompanierPhone = accompanierPhone;
    }
    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }
    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
