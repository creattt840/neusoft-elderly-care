package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.MealPlan;
import com.neusoft.elderly.mapper.MealPlanMapper;
import org.springframework.stereotype.Service;

@Service
public class MealPlanService extends ServiceImpl<MealPlanMapper, MealPlan> {

    public MealPlan getByElderlyId(Long elderlyId) {
        return baseMapper.selectByElderlyId(elderlyId);
    }
}
