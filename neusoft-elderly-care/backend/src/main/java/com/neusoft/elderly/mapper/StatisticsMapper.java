package com.neusoft.elderly.mapper;

import com.neusoft.elderly.vo.OutingVO;
import com.neusoft.elderly.vo.ResidenceRecordVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface StatisticsMapper {

    List<ResidenceRecordVO> selectCheckInRecords(@Param("startDate") LocalDate startDate,
                                                 @Param("endDate") LocalDate endDate);

    List<ResidenceRecordVO> selectCheckOutRecords(@Param("startDate") LocalDate startDate,
                                                  @Param("endDate") LocalDate endDate);

    List<ResidenceRecordVO> selectCheckInRecordsFromElderly(@Param("startDate") LocalDate startDate,
                                                            @Param("endDate") LocalDate endDate);

    List<ResidenceRecordVO> selectCheckOutRecordsFromElderly(@Param("startDate") LocalDate startDate,
                                                             @Param("endDate") LocalDate endDate);

    List<OutingVO> selectRecentActiveOutings(@Param("limit") int limit);
}
