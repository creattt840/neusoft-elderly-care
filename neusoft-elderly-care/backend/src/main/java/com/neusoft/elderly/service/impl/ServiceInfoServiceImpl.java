package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.mapper.ServiceMapper;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.ServiceInfoService;
import com.neusoft.elderly.vo.ServiceInfoVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ServiceInfoServiceImpl extends ServiceImpl<ServiceMapper, ServiceInfo> implements ServiceInfoService {

    @Autowired
    private PageCacheService pageCacheService;

    @Override
    public List<ServiceInfo> getActiveServices() {
        return baseMapper.selectActiveServices();
    }

    @Override
    public List<ServiceInfo> getActiveByType(Integer type) {
        return lambdaQuery()
                .eq(ServiceInfo::getServiceType, type)
                .eq(ServiceInfo::getStatus, 1)
                .list();
    }

    @Override
    public List<ServiceInfoVO> listServiceInfoVOs(Integer type) {
        List<ServiceInfo> services = type != null ? getActiveByType(type) : list();
        return services.stream().map(this::toServiceInfoVO).collect(Collectors.toList());
    }

    @Override
    @Cacheable(cacheNames = CacheNames.SERVICE_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size, #type)")
    public PageResult<ServiceInfoVO> pageServiceInfoVOs(Page<ServiceInfo> page, Integer type) {
        long total = baseMapper.countServicePage(type);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<ServiceInfoVO> list = baseMapper.selectServicePage(offset, page.getSize(), type);
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    @Override
    public boolean save(ServiceInfo entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearServiceRelated();
        }
        return saved;
    }

    @Override
    public boolean updateById(ServiceInfo entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearServiceRelated();
        }
        return updated;
    }

    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearServiceRelated();
        }
        return removed;
    }

    private ServiceInfoVO toServiceInfoVO(ServiceInfo serviceInfo) {
        ServiceInfoVO vo = new ServiceInfoVO();
        BeanUtils.copyProperties(serviceInfo, vo);
        return vo;
    }
}
