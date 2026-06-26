package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.entity.CheckIn;
import com.neusoft.elderly.entity.CheckOut;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.mapper.CareRecordMapper;
import com.neusoft.elderly.mapper.CheckInMapper;
import com.neusoft.elderly.mapper.CheckOutMapper;
import com.neusoft.elderly.mapper.ElderlyMapper;
import com.neusoft.elderly.mapper.ServiceSubscriptionMapper;
import org.springframework.stereotype.Service;

/**
 * 删除前清理关联记录，避免外键约束导致删除失败
 */
@Service
public class RelatedRecordCleanupService {

    private final CheckInMapper checkInMapper;
    private final CheckOutMapper checkOutMapper;
    private final CareRecordMapper careRecordMapper;
    private final ServiceSubscriptionMapper serviceSubscriptionMapper;
    private final ElderlyMapper elderlyMapper;

    public RelatedRecordCleanupService(CheckInMapper checkInMapper,
                                       CheckOutMapper checkOutMapper,
                                       CareRecordMapper careRecordMapper,
                                       ServiceSubscriptionMapper serviceSubscriptionMapper,
                                       ElderlyMapper elderlyMapper) {
        this.checkInMapper = checkInMapper;
        this.checkOutMapper = checkOutMapper;
        this.careRecordMapper = careRecordMapper;
        this.serviceSubscriptionMapper = serviceSubscriptionMapper;
        this.elderlyMapper = elderlyMapper;
    }

    public void removeCheckRecordsByBedId(Long bedId) {
        checkInMapper.delete(new LambdaQueryWrapper<CheckIn>().eq(CheckIn::getBedId, bedId));
        checkOutMapper.delete(new LambdaQueryWrapper<CheckOut>().eq(CheckOut::getBedId, bedId));
    }

    public void removeCareRecordsByCareItemId(Long careItemId) {
        careRecordMapper.delete(new LambdaQueryWrapper<CareRecord>().eq(CareRecord::getCareItemId, careItemId));
    }

    public void removeSubscriptionsByServiceId(Long serviceId) {
        serviceSubscriptionMapper.delete(new LambdaQueryWrapper<ServiceSubscription>()
                .eq(ServiceSubscription::getServiceId, serviceId));
    }

    public void removeElderlyMealsByCalendarId(Long calendarId) {
        elderlyMapper.deleteElderlyMealsByCalendarId(calendarId);
    }
}
