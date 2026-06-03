package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.vo.MealPlanVO;

import java.util.List;

public interface MealPlanService extends IService<MealPlan> {

    MealPlanVO getMealPlanVOByElderlyId(Long elderlyId);

    PageResult<MealPlanVO> pageMealPlanVOs(Page<MealPlan> page, String keyword);

    List<Long> listAssignedElderlyIds();

    boolean saveMealPlan(MealPlan mealPlan);

    boolean updateMealPlan(MealPlan mealPlan);

    boolean removeMealPlan(Long id);
}
