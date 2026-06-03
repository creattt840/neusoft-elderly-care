package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.Result;
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
public class StatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        return Result.success(statisticsService.getDashboardStatistics());
    }

    @GetMapping("/check-in-records")
    public Result<List<ResidenceRecordVO>> checkInRecords(
            @RequestParam(defaultValue = "today") String range) {
        return Result.success(statisticsService.listCheckInRecords(range));
    }

    @GetMapping("/check-out-records")
    public Result<List<ResidenceRecordVO>> checkOutRecords(
            @RequestParam(defaultValue = "today") String range) {
        return Result.success(statisticsService.listCheckOutRecords(range));
    }

    @GetMapping("/recent-active-outings")
    public Result<List<OutingVO>> recentActiveOutings(
            @RequestParam(defaultValue = "10") Integer limit) {
        return Result.success(statisticsService.listRecentActiveOutings(limit));
    }
}
