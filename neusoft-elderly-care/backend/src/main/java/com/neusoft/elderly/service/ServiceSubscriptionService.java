package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.vo.ServiceSubscriptionVO;

import java.util.List;

/**
 * 服务订阅服务接口
 */
public interface ServiceSubscriptionService extends IService<ServiceSubscription> {

    /**
     * 根据老人ID查询服务订阅列表
     */
    List<ServiceSubscriptionVO> listSubscriptionVOs(Long elderlyId);
}
