package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.vo.CareRecordVO;

import java.time.LocalDate;
import java.util.List;

/**
 * 护理记录服务接口
 */
public interface CareRecordService extends IService<CareRecord> {

    /**
     * 根据老人ID查询护理记录
     */
    List<CareRecordVO> listByElderlyId(Long elderlyId);

    /**
     * 根据日期查询护理记录
     */
    List<CareRecordVO> listByDate(LocalDate date);

    /**
     * 分页查询护理记录
     */
    PageResult<CareRecordVO> pageCareRecordVOs(Page<CareRecord> page, Long elderlyId, LocalDate recordDate);

    /**
     * 新增护理记录
     */
    boolean saveCareRecord(CareRecord careRecord);

    /**
     * 更新护理记录
     */
    boolean updateCareRecord(CareRecord careRecord);
}
