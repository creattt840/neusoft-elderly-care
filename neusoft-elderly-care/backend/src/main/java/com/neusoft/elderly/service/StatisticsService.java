package com.neusoft.elderly.service;

import com.neusoft.elderly.vo.OutingVO;
import com.neusoft.elderly.vo.ResidenceRecordVO;

import java.util.List;
import java.util.Map;

public interface StatisticsService {

    Map<String, Object> getDashboardStatistics();

    Map<String, Object> getElderlyCountStatistics();

    List<ResidenceRecordVO> listCheckInRecords(String range);

    List<ResidenceRecordVO> listCheckOutRecords(String range);

    List<OutingVO> listRecentActiveOutings(int limit);
}
