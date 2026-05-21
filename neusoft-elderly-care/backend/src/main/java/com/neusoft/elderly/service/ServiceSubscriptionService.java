package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.mapper.ServiceSubscriptionMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceSubscriptionService extends ServiceImpl<ServiceSubscriptionMapper, ServiceSubscription> {

    public List<ServiceSubscription> getByElderlyId(Long elderlyId) {
        return baseMapper.selectByElderlyId(elderlyId);
    }
}
