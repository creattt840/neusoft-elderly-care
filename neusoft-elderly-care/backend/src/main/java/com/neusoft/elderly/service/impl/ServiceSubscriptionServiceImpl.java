package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.mapper.ServiceSubscriptionMapper;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.ServiceInfoService;
import com.neusoft.elderly.service.ServiceSubscriptionService;
import com.neusoft.elderly.vo.ServiceSubscriptionVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 服务订阅服务实现
 */
@Service
public class ServiceSubscriptionServiceImpl extends ServiceImpl<ServiceSubscriptionMapper, ServiceSubscription> implements ServiceSubscriptionService {

    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private ServiceInfoService serviceInfoService;

    /** 根据老人ID查询服务订阅列表 */
    @Override
    public List<ServiceSubscriptionVO> listSubscriptionVOs(Long elderlyId) {
        List<ServiceSubscription> subscriptions = baseMapper.selectByElderlyId(elderlyId);
        List<ServiceSubscriptionVO> vos = subscriptions.stream()
                .map(this::toSubscriptionVO)
                .collect(Collectors.toList());
        enrichDisplayInfo(vos);
        return vos;
    }

    private void enrichDisplayInfo(List<ServiceSubscriptionVO> vos) {
        Set<Long> elderlyIds = vos.stream()
                .map(ServiceSubscriptionVO::getElderlyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Set<Long> serviceIds = vos.stream()
                .map(ServiceSubscriptionVO::getServiceId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        Map<Long, Elderly> elderlyMap = elderlyIds.isEmpty() ? Map.of()
                : elderlyService.listByIds(elderlyIds).stream()
                .collect(Collectors.toMap(Elderly::getId, elderly -> elderly));
        Map<Long, ServiceInfo> serviceMap = serviceIds.isEmpty() ? Map.of()
                : serviceInfoService.listByIds(serviceIds).stream()
                .collect(Collectors.toMap(ServiceInfo::getId, service -> service));

        for (ServiceSubscriptionVO vo : vos) {
            Elderly elderly = elderlyMap.get(vo.getElderlyId());
            if (elderly != null) {
                vo.setElderlyName(elderly.getName());
            }
            ServiceInfo service = serviceMap.get(vo.getServiceId());
            if (service != null) {
                vo.setServiceName(service.getServiceName());
            }
        }
    }

    private ServiceSubscriptionVO toSubscriptionVO(ServiceSubscription subscription) {
        ServiceSubscriptionVO vo = new ServiceSubscriptionVO();
        BeanUtils.copyProperties(subscription, vo);
        return vo;
    }
}
