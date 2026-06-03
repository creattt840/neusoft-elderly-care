package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.MealCalendar;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.service.MealCalendarService;
import com.neusoft.elderly.service.MealPlanService;
import com.neusoft.elderly.vo.MealCalendarVO;
import com.neusoft.elderly.vo.MealPlanVO;
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

    @GetMapping("/calendar/list")
    public Result<List<MealCalendarVO>> calendarList(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(mealCalendarService.listByDate(date));
    }

    @GetMapping("/calendar/week")
    public Result<List<MealCalendarVO>> calendarWeek(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(mealCalendarService.listByDateRange(startDate, endDate));
    }

    @PostMapping("/calendar")
    public Result<Boolean> saveCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.saveMealCalendar(mealCalendar));
    }

    @PutMapping("/calendar")
    public Result<Boolean> updateCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.updateMealCalendar(mealCalendar));
    }

    @DeleteMapping("/calendar/{id}")
    public Result<Boolean> deleteCalendar(@PathVariable Long id) {
        return Result.success(mealCalendarService.removeById(id));
    }

    @GetMapping("/plan/page")
    public Result<PageResult<MealPlanVO>> planPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                  @RequestParam(defaultValue = "10") Integer pageSize,
                                                  @RequestParam(required = false) String keyword) {
        Page<MealPlan> page = new Page<>(pageNum, pageSize);
        return Result.success(mealPlanService.pageMealPlanVOs(page, keyword));
    }

    @GetMapping("/plan/assigned-elderly-ids")
    public Result<List<Long>> assignedElderlyIds() {
        return Result.success(mealPlanService.listAssignedElderlyIds());
    }

    @GetMapping("/plan/{elderlyId}")
    public Result<MealPlanVO> getPlanByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(mealPlanService.getMealPlanVOByElderlyId(elderlyId));
    }

    @PostMapping("/plan")
    public Result<Boolean> savePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.saveMealPlan(mealPlan));
    }

    @PutMapping("/plan")
    public Result<Boolean> updatePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.updateMealPlan(mealPlan));
    }

    @DeleteMapping("/plan/{id}")
    public Result<Boolean> deletePlan(@PathVariable Long id) {
        return Result.success(mealPlanService.removeMealPlan(id));
    }
}
