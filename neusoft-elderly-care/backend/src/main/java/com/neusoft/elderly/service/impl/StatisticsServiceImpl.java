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
public class StatisticsServiceImpl implements StatisticsService {

    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private BedService bedService;

    @Autowired
    private StatisticsMapper statisticsMapper;

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

    @Override
    public Map<String, Object> getElderlyCountStatistics() {
        Map<String, Object> data = new HashMap<>();
        data.put("activeCount", elderlyService.countActiveElderly());
        data.put("checkedOutCount", elderlyService.countCheckedOutElderly());
        return data;
    }

    @Override
    public List<ResidenceRecordVO> listCheckInRecords(String range) {
        LocalDate[] dates = resolveDateRange(range);
        List<ResidenceRecordVO> records = statisticsMapper.selectCheckInRecords(dates[0], dates[1]);
        if (records.isEmpty()) {
            records = statisticsMapper.selectCheckInRecordsFromElderly(dates[0], dates[1]);
        }
        return records;
    }

    @Override
    public List<ResidenceRecordVO> listCheckOutRecords(String range) {
        LocalDate[] dates = resolveDateRange(range);
        List<ResidenceRecordVO> records = statisticsMapper.selectCheckOutRecords(dates[0], dates[1]);
        if (records.isEmpty()) {
            records = statisticsMapper.selectCheckOutRecordsFromElderly(dates[0], dates[1]);
        }
        return records;
    }

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
