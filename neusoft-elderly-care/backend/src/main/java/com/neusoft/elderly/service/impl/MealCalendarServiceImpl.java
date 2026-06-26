package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.mapper.MealCalendarMapper;
import com.neusoft.elderly.service.MealCalendarService;
import com.neusoft.elderly.service.RelatedRecordCleanupService;
import com.neusoft.elderly.vo.MealCalendarVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.Serializable;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 膳食日历服务实现
 */
@Service
public class MealCalendarServiceImpl extends ServiceImpl<MealCalendarMapper, MealCalendar> implements MealCalendarService {

    private final RelatedRecordCleanupService relatedRecordCleanupService;

    public MealCalendarServiceImpl(RelatedRecordCleanupService relatedRecordCleanupService) {
        this.relatedRecordCleanupService = relatedRecordCleanupService;
    }

    /** 删除膳食日历（含老人配餐关联） */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeById(Serializable id) {
        relatedRecordCleanupService.removeElderlyMealsByCalendarId(Long.valueOf(id.toString()));
        return super.removeById(id);
    }

    /** 根据日期查询菜单 */
    @Override
    public List<MealCalendarVO> listByDate(LocalDate date) {
        return baseMapper.selectByDate(date).stream()
                .map(this::toMealCalendarVO)
                .collect(Collectors.toList());
    }

    /** 根据日期范围查询菜单 */
    @Override
    public List<MealCalendarVO> listByDateRange(LocalDate startDate, LocalDate endDate) {
        return baseMapper.selectByDateRange(startDate, endDate).stream()
                .map(this::toMealCalendarVO)
                .collect(Collectors.toList());
    }

    /** 新增膳食日历 */
    @Override
    public boolean saveMealCalendar(MealCalendar mealCalendar) {
        validateMealCalendar(mealCalendar);
        if (existsByDateAndType(mealCalendar.getMealDate(), mealCalendar.getMealType(), null)) {
            throw new BusinessException("该日期已存在此餐次菜单");
        }
        return save(mealCalendar);
    }

    /** 更新膳食日历 */
    @Override
    public boolean updateMealCalendar(MealCalendar mealCalendar) {
        if (mealCalendar.getId() == null) {
            throw new BusinessException("菜单ID不能为空");
        }
        validateMealCalendar(mealCalendar);
        if (existsByDateAndType(mealCalendar.getMealDate(), mealCalendar.getMealType(), mealCalendar.getId())) {
            throw new BusinessException("该日期已存在此餐次菜单");
        }
        return updateById(mealCalendar);
    }

    private MealCalendarVO toMealCalendarVO(MealCalendar mealCalendar) {
        MealCalendarVO vo = new MealCalendarVO();
        BeanUtils.copyProperties(mealCalendar, vo);
        return vo;
    }

    private void validateMealCalendar(MealCalendar mealCalendar) {
        if (mealCalendar.getMealDate() == null) {
            throw new BusinessException("请选择日期");
        }
        if (mealCalendar.getMealType() == null) {
            throw new BusinessException("请选择餐次");
        }
        if (!StringUtils.hasText(mealCalendar.getMenuContent())) {
            throw new BusinessException("请输入菜单内容");
        }
    }

    private boolean existsByDateAndType(LocalDate date, Integer mealType, Long excludeId) {
        return lambdaQuery()
                .eq(MealCalendar::getMealDate, date)
                .eq(MealCalendar::getMealType, mealType)
                .ne(excludeId != null, MealCalendar::getId, excludeId)
                .count() > 0;
    }
}
