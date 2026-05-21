package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.service.MealCalendarService;
import com.neusoft.elderly.service.MealPlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/meal")
public class MealController {

    @Autowired
    private MealCalendarService mealCalendarService;

    @Autowired
    private MealPlanService mealPlanService;

    // 膳食日历
    @GetMapping("/calendar/list")
    public Result<List<MealCalendar>> calendarList(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(mealCalendarService.getByDate(date));
    }

    @GetMapping("/calendar/week")
    public Result<List<MealCalendar>> calendarWeek(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(mealCalendarService.getByDateRange(startDate, endDate));
    }

    @PostMapping("/calendar")
    public Result<Boolean> saveCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.save(mealCalendar));
    }

    @PutMapping("/calendar")
    public Result<Boolean> updateCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.updateById(mealCalendar));
    }

    @DeleteMapping("/calendar/{id}")
    public Result<Boolean> deleteCalendar(@PathVariable Long id) {
        return Result.success(mealCalendarService.removeById(id));
    }

    // 膳食计划
    @GetMapping("/plan/{elderlyId}")
    public Result<MealPlan> getPlanByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(mealPlanService.getByElderlyId(elderlyId));
    }

    @PostMapping("/plan")
    public Result<Boolean> savePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.save(mealPlan));
    }

    @PutMapping("/plan")
    public Result<Boolean> updatePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.updateById(mealPlan));
    }
}
