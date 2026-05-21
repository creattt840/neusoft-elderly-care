package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.mapper.OutingMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OutingService extends ServiceImpl<OutingMapper, Outing> {

    public List<Outing> getActiveOutings() {
        return baseMapper.selectActiveOutings();
    }
}
