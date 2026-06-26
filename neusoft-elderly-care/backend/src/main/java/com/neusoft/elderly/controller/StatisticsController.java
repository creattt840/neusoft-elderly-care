package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.service.StatisticsService;
import com.neusoft.elderly.vo.OutingVO;
import com.neusoft.elderly.vo.ResidenceRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/statistics")
/**
 * 数据统计接口
 */
public class StatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    /** 控制台仪表盘数据 */
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        return Result.success(statisticsService.getDashboardStatistics());
    }

    /** 入住记录统计 */
    @GetMapping("/check-in-records")
    public Result<List<ResidenceRecordVO>> checkInRecords(
            @RequestParam(defaultValue = "today") String range) {
        return Result.success(statisticsService.listCheckInRecords(range));
    }

    /** 退住记录统计 */
    @GetMapping("/check-out-records")
    public Result<List<ResidenceRecordVO>> checkOutRecords(
            @RequestParam(defaultValue = "today") String range) {
        return Result.success(statisticsService.listCheckOutRecords(range));
    }

    /** 最近活跃外出记录 */
    @GetMapping("/recent-active-outings")
    public Result<List<OutingVO>> recentActiveOutings(
            @RequestParam(defaultValue = "10") Integer limit) {
        return Result.success(statisticsService.listRecentActiveOutings(limit));
    }
}
