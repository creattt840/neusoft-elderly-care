package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.MealCalendar;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface MealCalendarMapper extends BaseMapper<MealCalendar> {
    @Select("SELECT * FROM meal_calendar WHERE meal_date = #{date}")
    List<MealCalendar> selectByDate(LocalDate date);

    @Select("SELECT * FROM meal_calendar WHERE meal_date BETWEEN #{startDate} AND #{endDate}")
    List<MealCalendar> selectByDateRange(LocalDate startDate, LocalDate endDate);
}
