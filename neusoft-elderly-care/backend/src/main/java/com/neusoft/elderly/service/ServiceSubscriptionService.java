package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.vo.ServiceSubscriptionVO;

import java.util.List;

public interface ServiceSubscriptionService extends IService<ServiceSubscription> {

    List<ServiceSubscriptionVO> listSubscriptionVOs(Long elderlyId);
}
