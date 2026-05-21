package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.ServiceSubscription;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ServiceSubscriptionMapper extends BaseMapper<ServiceSubscription> {
    @Select("SELECT * FROM service_subscription WHERE elderly_id = #{elderlyId}")
    List<ServiceSubscription> selectByElderlyId(Long elderlyId);
}
