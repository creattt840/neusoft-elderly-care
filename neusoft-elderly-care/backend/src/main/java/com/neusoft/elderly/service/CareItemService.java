package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.mapper.CareItemMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CareItemService extends ServiceImpl<CareItemMapper, CareItem> {

    public List<CareItem> getByCareLevelId(Long careLevelId) {
        return baseMapper.selectByCareLevelId(careLevelId);
    }
}
