package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.MealPlan;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface MealPlanMapper extends BaseMapper<MealPlan> {
    @Select("SELECT * FROM meal_plan WHERE elderly_id = #{elderlyId}")
    MealPlan selectByElderlyId(Long elderlyId);
}
