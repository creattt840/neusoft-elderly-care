package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.vo.MealCalendarVO;

import java.time.LocalDate;
import java.util.List;

/**
 * 膳食日历服务接口
 */
public interface MealCalendarService extends IService<MealCalendar> {

    /**
     * 根据日期查询当日菜单
     */
    List<MealCalendarVO> listByDate(LocalDate date);

    /**
     * 根据日期范围查询菜单
     */
    List<MealCalendarVO> listByDateRange(LocalDate startDate, LocalDate endDate);

    /**
     * 新增膳食日历记录
     */
    boolean saveMealCalendar(MealCalendar mealCalendar);

    /**
     * 更新膳食日历记录
     */
    boolean updateMealCalendar(MealCalendar mealCalendar);
}
