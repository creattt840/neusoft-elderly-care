package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.mapper.ElderlyMapper;
import com.neusoft.elderly.mapper.BedMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ElderlyService extends ServiceImpl<ElderlyMapper, Elderly> {

    @Autowired
    private BedMapper bedMapper;

    @Transactional
    public void checkIn(Elderly elderly, Long bedId) {
        elderly.setBedId(bedId);
        elderly.setStatus(1);
        baseMapper.insert(elderly);

        Bed bed = bedMapper.selectById(bedId);
        bed.setStatus(1);
        bed.setElderlyId(elderly.getId());
        bedMapper.updateById(bed);
    }

    @Transactional
    public void checkOut(Long elderlyId) {
        Elderly elderly = baseMapper.selectById(elderlyId);
        if (elderly != null && elderly.getBedId() != null) {
            Bed bed = bedMapper.selectById(elderly.getBedId());
            if (bed != null) {
                bed.setStatus(0);
                bed.setElderlyId(null);
                bedMapper.updateById(bed);
            }
        }
        elderly.setStatus(2);
        elderly.setBedId(null);
        baseMapper.updateById(elderly);
    }

    public Long countActiveElderly() {
        return baseMapper.countActiveElderly();
    }

    public Long countCheckedOutElderly() {
        return baseMapper.countCheckedOutElderly();
    }
}
