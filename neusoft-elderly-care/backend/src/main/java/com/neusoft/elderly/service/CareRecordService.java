package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.vo.CareRecordVO;

import java.time.LocalDate;
import java.util.List;

public interface CareRecordService extends IService<CareRecord> {

    List<CareRecordVO> listByElderlyId(Long elderlyId);

    List<CareRecordVO> listByDate(LocalDate date);

    PageResult<CareRecordVO> pageCareRecordVOs(Page<CareRecord> page, Long elderlyId, LocalDate recordDate);

    boolean saveCareRecord(CareRecord careRecord);

    boolean updateCareRecord(CareRecord careRecord);
}
