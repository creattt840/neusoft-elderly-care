package com.neusoft.elderly.controller;

import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.BedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/statistics")
public class StatisticsController {

    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private BedService bedService;

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        Map<String, Object> data = new HashMap<>();
        data.put("activeElderlyCount", elderlyService.countActiveElderly());
        data.put("checkedOutElderlyCount", elderlyService.countCheckedOutElderly());
        data.put("totalBedCount", bedService.count());
        data.put("availableBedCount", bedService.countAvailableBeds());
        data.put("occupiedBedCount", bedService.countOccupiedBeds());
        return Result.success(data);
    }
}
