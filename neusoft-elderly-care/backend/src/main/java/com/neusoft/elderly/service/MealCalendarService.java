package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.vo.MealCalendarVO;

import java.time.LocalDate;
import java.util.List;

public interface MealCalendarService extends IService<MealCalendar> {

    List<MealCalendarVO> listByDate(LocalDate date);

    List<MealCalendarVO> listByDateRange(LocalDate startDate, LocalDate endDate);

    boolean saveMealCalendar(MealCalendar mealCalendar);

    boolean updateMealCalendar(MealCalendar mealCalendar);
}
