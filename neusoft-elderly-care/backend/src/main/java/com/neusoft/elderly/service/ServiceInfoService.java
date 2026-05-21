package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.mapper.ServiceMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceInfoService extends ServiceImpl<ServiceMapper, ServiceInfo> {

    public List<ServiceInfo> getActiveServices() {
        return baseMapper.selectActiveServices();
    }
}
