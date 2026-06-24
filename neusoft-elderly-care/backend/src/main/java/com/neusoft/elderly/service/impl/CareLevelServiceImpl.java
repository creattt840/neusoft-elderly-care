package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.mapper.CareLevelMapper;
import com.neusoft.elderly.service.CareLevelService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.vo.CareLevelVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CareLevelServiceImpl extends ServiceImpl<CareLevelMapper, CareLevel> implements CareLevelService {

    @Autowired
    private PageCacheService pageCacheService;

    @Override
    @Cacheable(cacheNames = CacheNames.CARE_LEVEL_LIST, key = "'all'")
    public List<CareLevelVO> listCareLevelVOs() {
        return list().stream().map(this::toCareLevelVO).collect(Collectors.toList());
    }

    @Override
    public CareLevelVO getCareLevelVO(Long id) {
        CareLevel careLevel = getById(id);
        return careLevel == null ? null : toCareLevelVO(careLevel);
    }

    @Override
    public boolean save(CareLevel entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearCareLevelRelated();
        }
        return saved;
    }

    @Override
    public boolean updateById(CareLevel entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearCareLevelRelated();
        }
        return updated;
    }

    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearCareLevelRelated();
        }
        return removed;
    }

    private CareLevelVO toCareLevelVO(CareLevel careLevel) {
        CareLevelVO vo = new CareLevelVO();
        BeanUtils.copyProperties(careLevel, vo);
        return vo;
    }
}
