package com.neusoft.elderly.service;

import com.neusoft.elderly.vo.OutingVO;
import com.neusoft.elderly.vo.ResidenceRecordVO;

import java.util.List;
import java.util.Map;

/**
 * 统计分析服务接口
 */
public interface StatisticsService {

    /**
     * 获取仪表盘统计数据（在住、退住、床位等汇总数据）
     */
    Map<String, Object> getDashboardStatistics();

    /**
     * 获取老人数量统计（在住/退住人数）
     */
    Map<String, Object> getElderlyCountStatistics();

    /**
     * 按时间范围查询入住记录
     */
    List<ResidenceRecordVO> listCheckInRecords(String range);

    /**
     * 按时间范围查询退住记录
     */
    List<ResidenceRecordVO> listCheckOutRecords(String range);

    /**
     * 查询近期在外的外出记录
     */
    List<OutingVO> listRecentActiveOutings(int limit);
}
