package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.vo.MealPlanVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MealPlanMapper extends BaseMapper<MealPlan> {
    @Select("SELECT * FROM meal_plan WHERE elderly_id = #{elderlyId}")
    MealPlan selectByElderlyId(Long elderlyId);

    long countMealPlanPage(@Param("keyword") String keyword);

    List<MealPlanVO> selectMealPlanPage(@Param("keyword") String keyword,
                                        @Param("offset") long offset,
                                        @Param("pageSize") long pageSize);

    MealPlanVO selectMealPlanVOByElderlyId(@Param("elderlyId") Long elderlyId);
}
