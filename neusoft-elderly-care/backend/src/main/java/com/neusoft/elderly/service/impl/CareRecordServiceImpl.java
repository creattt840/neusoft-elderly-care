package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.BusinessException;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.mapper.CareRecordMapper;
import com.neusoft.elderly.service.CareRecordService;
import com.neusoft.elderly.vo.CareRecordVO;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class CareRecordServiceImpl extends ServiceImpl<CareRecordMapper, CareRecord> implements CareRecordService {

    @Override
    public List<CareRecordVO> listByElderlyId(Long elderlyId) {
        return baseMapper.selectCareRecordList(elderlyId, null);
    }

    @Override
    public List<CareRecordVO> listByDate(LocalDate date) {
        return baseMapper.selectCareRecordList(null, date);
    }

    @Override
    public PageResult<CareRecordVO> pageCareRecordVOs(Page<CareRecord> page, Long elderlyId, LocalDate recordDate) {
        long total = baseMapper.countCareRecordPage(elderlyId, recordDate);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<CareRecordVO> list = baseMapper.selectCareRecordPage(elderlyId, recordDate, offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    @Override
    public boolean saveCareRecord(CareRecord careRecord) {
        validateCareRecord(careRecord);
        LocalDateTime now = LocalDateTime.now();
        if (careRecord.getRecordDate() == null) {
            careRecord.setRecordDate(now.toLocalDate());
        }
        if (careRecord.getRecordTime() == null) {
            careRecord.setRecordTime(now);
        }
        if (careRecord.getStatus() == null) {
            careRecord.setStatus(0);
        }
        return save(careRecord);
    }

    @Override
    public boolean updateCareRecord(CareRecord careRecord) {
        if (careRecord.getId() == null) {
            throw new BusinessException("记录ID不能为空");
        }
        validateCareRecord(careRecord);
        return updateById(careRecord);
    }

    private void validateCareRecord(CareRecord careRecord) {
        if (careRecord.getElderlyId() == null) {
            throw new BusinessException("请选择老人");
        }
        if (careRecord.getCareItemId() == null) {
            throw new BusinessException("请选择护理项目");
        }
    }
}
