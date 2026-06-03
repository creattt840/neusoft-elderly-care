package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.vo.CareRecordVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface CareRecordMapper extends BaseMapper<CareRecord> {
    @Select("SELECT * FROM care_record WHERE elderly_id = #{elderlyId}")
    List<CareRecord> selectByElderlyId(Long elderlyId);

    @Select("SELECT * FROM care_record WHERE record_date = #{date}")
    List<CareRecord> selectByDate(LocalDate date);

    long countCareRecordPage(@Param("elderlyId") Long elderlyId,
                             @Param("recordDate") LocalDate recordDate);

    List<CareRecordVO> selectCareRecordPage(@Param("elderlyId") Long elderlyId,
                                            @Param("recordDate") LocalDate recordDate,
                                            @Param("offset") long offset,
                                            @Param("pageSize") long pageSize);

    List<CareRecordVO> selectCareRecordList(@Param("elderlyId") Long elderlyId,
                                            @Param("recordDate") LocalDate recordDate);
}
