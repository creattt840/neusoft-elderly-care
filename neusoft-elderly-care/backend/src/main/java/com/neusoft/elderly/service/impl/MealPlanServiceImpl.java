package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.mapper.MealPlanMapper;
import com.neusoft.elderly.service.MealPlanService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.vo.MealPlanVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 膳食计划服务实现
 */
@Service
public class MealPlanServiceImpl extends ServiceImpl<MealPlanMapper, MealPlan> implements MealPlanService {

    @Autowired
    private PageCacheService pageCacheService;

    /** 根据老人ID查询膳食计划 */
    @Override
    public MealPlanVO getMealPlanVOByElderlyId(Long elderlyId) {
        return baseMapper.selectMealPlanVOByElderlyId(elderlyId);
    }

    /** 分页查询膳食计划，缓存 */
    @Override
    @Cacheable(cacheNames = CacheNames.MEAL_PLAN_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size, #keyword)")
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

    /** 查询已分配膳食计划的老人ID */
    @Override
    public List<Long> listAssignedElderlyIds() {
        return list().stream()
                .map(MealPlan::getElderlyId)
                .collect(Collectors.toList());
    }

    /** 新增膳食计划，清除缓存 */
    @Override
    public boolean saveMealPlan(MealPlan mealPlan) {
        validateMealPlan(mealPlan);
        if (existsByElderlyId(mealPlan.getElderlyId(), null)) {
            throw new BusinessException("该老人已有膳食计划");
        }
        boolean saved = save(mealPlan);
        if (saved) {
            pageCacheService.clearMealPlanRelated();
        }
        return saved;
    }

    /** 更新膳食计划，清除缓存 */
    @Override
    public boolean updateMealPlan(MealPlan mealPlan) {
        if (mealPlan.getId() == null) {
            throw new BusinessException("计划ID不能为空");
        }
        validateMealPlan(mealPlan);
        if (existsByElderlyId(mealPlan.getElderlyId(), mealPlan.getId())) {
            throw new BusinessException("该老人已有膳食计划");
        }
        boolean updated = updateById(mealPlan);
        if (updated) {
            pageCacheService.clearMealPlanRelated();
        }
        return updated;
    }

    /** 删除膳食计划，清除缓存 */
    @Override
    public boolean removeMealPlan(Long id) {
        if (id == null) {
            throw new BusinessException("计划ID不能为空");
        }
        if (getById(id) == null) {
            throw new BusinessException("膳食计划不存在");
        }
        boolean removed = removeById(id);
        if (removed) {
            pageCacheService.clearMealPlanRelated();
        }
        return removed;
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
