package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
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

/**
 * 膳食管理接口（日历+计划）
 */
@RestController
@RequestMapping("/api/meal")
public class MealController {

    @Autowired
    private MealCalendarService mealCalendarService;

    @Autowired
    private MealPlanService mealPlanService;

    /** 查询指定日期膳食日历 */
    @GetMapping("/calendar/list")
    public Result<List<MealCalendarVO>> calendarList(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(mealCalendarService.listByDate(date));
    }

    /** 查询一周膳食日历 */
    @GetMapping("/calendar/week")
    public Result<List<MealCalendarVO>> calendarWeek(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(mealCalendarService.listByDateRange(startDate, endDate));
    }

    /** 新增膳食日历 */
    @PostMapping("/calendar")
    public Result<Boolean> saveCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.saveMealCalendar(mealCalendar));
    }

    /** 更新膳食日历 */
    @PutMapping("/calendar")
    public Result<Boolean> updateCalendar(@RequestBody MealCalendar mealCalendar) {
        return Result.success(mealCalendarService.updateMealCalendar(mealCalendar));
    }

    /** 删除膳食日历 */
    @DeleteMapping("/calendar/{id}")
    public Result<Boolean> deleteCalendar(@PathVariable Long id) {
        return Result.success(mealCalendarService.removeById(id));
    }

    /** 分页查询膳食计划 */
    @GetMapping("/plan/page")
    public Result<PageResult<MealPlanVO>> planPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                   @RequestParam(defaultValue = "10") Integer pageSize,
                                                   @RequestParam(required = false) String keyword) {
        Page<MealPlan> page = new Page<>(pageNum, pageSize);
        return Result.success(mealPlanService.pageMealPlanVOs(page, keyword));
    }

    /** 查询已分配膳食计划的老人ID */
    @GetMapping("/plan/assigned-elderly-ids")
    public Result<List<Long>> assignedElderlyIds() {
        return Result.success(mealPlanService.listAssignedElderlyIds());
    }

    /** 查询指定老人的膳食计划 */
    @GetMapping("/plan/{elderlyId}")
    public Result<MealPlanVO> getPlanByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(mealPlanService.getMealPlanVOByElderlyId(elderlyId));
    }

    /** 新增膳食计划 */
    @PostMapping("/plan")
    public Result<Boolean> savePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.saveMealPlan(mealPlan));
    }

    /** 更新膳食计划 */
    @PutMapping("/plan")
    public Result<Boolean> updatePlan(@RequestBody MealPlan mealPlan) {
        return Result.success(mealPlanService.updateMealPlan(mealPlan));
    }

    /** 删除膳食计划 */
    @DeleteMapping("/plan/{id}")
    public Result<Boolean> deletePlan(@PathVariable Long id) {
        return Result.success(mealPlanService.removeMealPlan(id));
    }
}
