package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.BusinessException;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.mapper.MealPlanMapper;
import com.neusoft.elderly.service.MealPlanService;
import com.neusoft.elderly.vo.MealPlanVO;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MealPlanServiceImpl extends ServiceImpl<MealPlanMapper, MealPlan> implements MealPlanService {

    @Override
    public MealPlanVO getMealPlanVOByElderlyId(Long elderlyId) {
        return baseMapper.selectMealPlanVOByElderlyId(elderlyId);
    }

    @Override
    public PageResult<MealPlanVO> pageMealPlanVOs(Page<MealPlan> page, String keyword) {
        String searchKeyword = normalizeKeyword(keyword);
        long total = baseMapper.countMealPlanPage(searchKeyword);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<MealPlanVO> list = baseMapper.selectMealPlanPage(searchKeyword, offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    @Override
    public List<Long> listAssignedElderlyIds() {
        return list().stream()
                .map(MealPlan::getElderlyId)
                .collect(Collectors.toList());
    }

    @Override
    public boolean saveMealPlan(MealPlan mealPlan) {
        validateMealPlan(mealPlan);
        if (existsByElderlyId(mealPlan.getElderlyId(), null)) {
            throw new BusinessException("该老人已有膳食计划");
        }
        return save(mealPlan);
    }

    @Override
    public boolean updateMealPlan(MealPlan mealPlan) {
        if (mealPlan.getId() == null) {
            throw new BusinessException("计划ID不能为空");
        }
        validateMealPlan(mealPlan);
        if (existsByElderlyId(mealPlan.getElderlyId(), mealPlan.getId())) {
            throw new BusinessException("该老人已有膳食计划");
        }
        return updateById(mealPlan);
    }

    @Override
    public boolean removeMealPlan(Long id) {
        if (id == null) {
            throw new BusinessException("计划ID不能为空");
        }
        if (getById(id) == null) {
            throw new BusinessException("膳食计划不存在");
        }
        return removeById(id);
    }

    private void validateMealPlan(MealPlan mealPlan) {
        if (mealPlan.getElderlyId() == null) {
            throw new BusinessException("请选择老人");
        }
    }

    private boolean existsByElderlyId(Long elderlyId, Long excludeId) {
        return lambdaQuery()
                .eq(MealPlan::getElderlyId, elderlyId)
                .ne(excludeId != null, MealPlan::getId, excludeId)
                .count() > 0;
    }

    private String normalizeKeyword(String keyword) {
        if (keyword == null) {
            return null;
        }
        String trimmed = keyword.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
