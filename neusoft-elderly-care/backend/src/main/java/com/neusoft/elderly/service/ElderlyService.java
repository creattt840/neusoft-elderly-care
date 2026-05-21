package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.mapper.ElderlyMapper;
import com.neusoft.elderly.mapper.BedMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

@Service
public class ElderlyService extends ServiceImpl<ElderlyMapper, Elderly> {

    @Autowired
    private BedMapper bedMapper;

    @Transactional
    public void checkIn(Elderly elderly, Long bedId) {
        // 校验床位是否存在
        Bed bed = bedMapper.selectById(bedId);
        Assert.notNull(bed, "床位不存在");

        // 校验床位是否已被占用
        if (bed.getStatus() != null && bed.getStatus() == 1) {
            throw new IllegalStateException("该床位已被占用");
        }

        elderly.setBedId(bedId);
        elderly.setStatus(1);
        baseMapper.insert(elderly);

        bed.setStatus(1);
        bed.setElderlyId(elderly.getId());
        bedMapper.updateById(bed);
    }

    @Transactional
    public void checkOut(Long elderlyId) {
        Elderly elderly = baseMapper.selectById(elderlyId);
        Assert.notNull(elderly, "老人信息不存在");

        if (elderly.getBedId() != null) {
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
