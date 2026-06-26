package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.vo.ServiceInfoVO;

import java.util.List;

/**
 * 服务信息服务接口
 */
public interface ServiceInfoService extends IService<ServiceInfo> {

    /**
     * 查询所有已启用的服务
     */
    List<ServiceInfo> getActiveServices();

    /**
     * 根据服务类型查询已启用的服务
     */
    List<ServiceInfo> getActiveByType(Integer type);

    /**
     * 查询服务列表（可按类型筛选）
     */
    List<ServiceInfoVO> listServiceInfoVOs(Integer type);

    /**
     * 分页查询服务列表
     */
    PageResult<ServiceInfoVO> pageServiceInfoVOs(Page<ServiceInfo> page, Integer type);
}
