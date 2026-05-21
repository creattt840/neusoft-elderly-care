package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.mapper.CareRecordMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class CareRecordService extends ServiceImpl<CareRecordMapper, CareRecord> {

    public List<CareRecord> getByElderlyId(Long elderlyId) {
        return baseMapper.selectByElderlyId(elderlyId);
    }

    public List<CareRecord> getByDate(LocalDate date) {
        return baseMapper.selectByDate(date);
    }
}
