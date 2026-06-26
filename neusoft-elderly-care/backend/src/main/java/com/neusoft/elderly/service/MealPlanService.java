package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.vo.MealPlanVO;

import java.util.List;

/**
 * 膳食计划服务接口
 */
public interface MealPlanService extends IService<MealPlan> {

    /**
     * 根据老人ID查询膳食计划
     */
    MealPlanVO getMealPlanVOByElderlyId(Long elderlyId);

    /**
     * 分页查询膳食计划
     */
    PageResult<MealPlanVO> pageMealPlanVOs(Page<MealPlan> page, String keyword);

    /**
     * 查询已分配膳食计划的老人ID列表
     */
    List<Long> listAssignedElderlyIds();

    /**
     * 新增膳食计划
     */
    boolean saveMealPlan(MealPlan mealPlan);

    /**
     * 更新膳食计划
     */
    boolean updateMealPlan(MealPlan mealPlan);

    /**
     * 删除膳食计划
     */
    boolean removeMealPlan(Long id);
}
