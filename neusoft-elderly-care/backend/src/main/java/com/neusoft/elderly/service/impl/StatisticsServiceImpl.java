package com.neusoft.elderly.service.impl;

import com.neusoft.elderly.mapper.StatisticsMapper;
import com.neusoft.elderly.service.BedService;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.StatisticsService;
import com.neusoft.elderly.vo.OutingVO;
import com.neusoft.elderly.vo.ResidenceRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
/**
 * 统计分析服务实现
 */
public class StatisticsServiceImpl implements StatisticsService {

    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private BedService bedService;

    @Autowired
    private StatisticsMapper statisticsMapper;

    /** 获取仪表盘汇总数据 */
    @Override
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> data = new HashMap<>();
        data.put("activeElderlyCount", elderlyService.countActiveElderly());
        data.put("checkedOutElderlyCount", elderlyService.countCheckedOutElderly());
        data.put("totalBedCount", bedService.count());
        data.put("availableBedCount", bedService.countAvailableBeds());
        data.put("occupiedBedCount", bedService.countOccupiedBeds());
        return data;
    }

    /** 获取老人数量统计 */
    @Override
    public Map<String, Object> getElderlyCountStatistics() {
        Map<String, Object> data = new HashMap<>();
        data.put("activeCount", elderlyService.countActiveElderly());
        data.put("checkedOutCount", elderlyService.countCheckedOutElderly());
        return data;
    }

    /** 按时间范围查询入住记录 */
    @Override
    public List<ResidenceRecordVO> listCheckInRecords(String range) {
        LocalDate[] dates = resolveDateRange(range);
        List<ResidenceRecordVO> records = statisticsMapper.selectCheckInRecords(dates[0], dates[1]);
        if (records.isEmpty()) {
            records = statisticsMapper.selectCheckInRecordsFromElderly(dates[0], dates[1]);
        }
        return records;
    }

    /** 按时间范围查询退住记录 */
    @Override
    public List<ResidenceRecordVO> listCheckOutRecords(String range) {
        LocalDate[] dates = resolveDateRange(range);
        List<ResidenceRecordVO> records = statisticsMapper.selectCheckOutRecords(dates[0], dates[1]);
        if (records.isEmpty()) {
            records = statisticsMapper.selectCheckOutRecordsFromElderly(dates[0], dates[1]);
        }
        return records;
    }

    /** 查询近期在外的外出记录 */
    @Override
    public List<OutingVO> listRecentActiveOutings(int limit) {
        return statisticsMapper.selectRecentActiveOutings(limit);
    }

    private LocalDate[] resolveDateRange(String range) {
        LocalDate endDate = LocalDate.now();
        LocalDate startDate;
        if ("week".equals(range)) {
            startDate = endDate.minusDays(6);
        } else if ("month".equals(range)) {
            startDate = endDate.minusDays(29);
        } else {
            startDate = endDate;
        }
        return new LocalDate[]{startDate, endDate};
    }
}
