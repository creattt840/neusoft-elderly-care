package com.neusoft.elderly.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@TableName("meal_calendar")
public class MealCalendar {
    @TableId(type = IdType.AUTO)
    private Long id;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate mealDate;
    private Integer mealType;
    private String menuContent;
    private String nutritionInfo;
    private String remark;
    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
    public LocalDate getMealDate() {
        return mealDate;
    }

    public void setMealDate(LocalDate mealDate) {
        this.mealDate = mealDate;
    }
    public Integer getMealType() {
        return mealType;
    }

    public void setMealType(Integer mealType) {
        this.mealType = mealType;
    }
    public String getMenuContent() {
        return menuContent;
    }

    public void setMenuContent(String menuContent) {
        this.menuContent = menuContent;
    }
    public String getNutritionInfo() {
        return nutritionInfo;
    }

    public void setNutritionInfo(String nutritionInfo) {
        this.nutritionInfo = nutritionInfo;
    }
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
