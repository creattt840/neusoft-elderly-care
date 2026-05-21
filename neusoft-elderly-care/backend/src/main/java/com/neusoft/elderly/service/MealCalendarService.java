package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.mapper.MealCalendarMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class MealCalendarService extends ServiceImpl<MealCalendarMapper, MealCalendar> {

    public List<MealCalendar> getByDate(LocalDate date) {
        return baseMapper.selectByDate(date);
    }

    public List<MealCalendar> getByDateRange(LocalDate startDate, LocalDate endDate) {
        return baseMapper.selectByDateRange(startDate, endDate);
    }
}
