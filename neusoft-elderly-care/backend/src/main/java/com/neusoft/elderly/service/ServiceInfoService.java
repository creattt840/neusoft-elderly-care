package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.vo.ServiceInfoVO;

import java.util.List;

public interface ServiceInfoService extends IService<ServiceInfo> {

    List<ServiceInfo> getActiveServices();

    List<ServiceInfo> getActiveByType(Integer type);

    List<ServiceInfoVO> listServiceInfoVOs(Integer type);
}
