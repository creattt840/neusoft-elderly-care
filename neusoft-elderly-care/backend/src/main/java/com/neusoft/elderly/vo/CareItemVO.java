package com.neusoft.elderly.vo;

import java.time.LocalDateTime;

/**
 * 护理内容 VO（含护理级别名称，用于返回给前端）
 */
public class CareItemVO {
    private Long id;
    private String itemName;
    private Long careLevelId;
    private String levelName;
    private String frequency;
    private String description;
    private Integer sortOrder;
    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public Long getCareLevelId() {
        return careLevelId;
    }

    public void setCareLevelId(Long careLevelId) {
        this.careLevelId = careLevelId;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
