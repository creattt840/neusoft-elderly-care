package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.mapper.BedMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BedService extends ServiceImpl<BedMapper, Bed> {

    public List<Bed> getBedsByRoomId(Long roomId) {
        return baseMapper.selectByRoomId(roomId);
    }

    public List<Bed> getAvailableBeds() {
        return baseMapper.selectAvailableBeds();
    }

    public long countAvailableBeds() {
        return baseMapper.selectAvailableBeds().size();
    }

    public long countOccupiedBeds() {
        return baseMapper.selectCount(null) - countAvailableBeds();
    }
}
