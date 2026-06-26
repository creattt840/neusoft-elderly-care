package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.mapper.CareItemMapper;
import com.neusoft.elderly.mapper.CareLevelMapper;
import com.neusoft.elderly.mapper.ElderlyMapper;
import com.neusoft.elderly.service.CareLevelService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.RelatedRecordCleanupService;
import com.neusoft.elderly.vo.CareLevelVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 护理等级服务实现
 */
@Service
public class CareLevelServiceImpl extends ServiceImpl<CareLevelMapper, CareLevel> implements CareLevelService {

    @Autowired
    private PageCacheService pageCacheService;

    @Autowired
    private ElderlyMapper elderlyMapper;

    @Autowired
    private CareItemMapper careItemMapper;

    @Autowired
    private RelatedRecordCleanupService relatedRecordCleanupService;

    /** 查询全部护理等级列表，缓存 */
    @Override
    @Cacheable(cacheNames = CacheNames.CARE_LEVEL_LIST, key = "'all'")
    public List<CareLevelVO> listCareLevelVOs() {
        return list().stream().map(this::toCareLevelVO).collect(Collectors.toList());
    }

    /** 根据ID查询护理等级详情 */
    @Override
    public CareLevelVO getCareLevelVO(Long id) {
        CareLevel careLevel = getById(id);
        return careLevel == null ? null : toCareLevelVO(careLevel);
    }

    /** 新增护理等级，清除缓存 */
    @Override
    public boolean save(CareLevel entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearCareLevelRelated();
        }
        return saved;
    }

    /** 更新护理等级，清除缓存 */
    @Override
    public boolean updateById(CareLevel entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearCareLevelRelated();
        }
        return updated;
    }

    /** 删除护理等级（含护理项目），清除缓存 */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeById(Serializable id) {
        Long levelId = Long.valueOf(id.toString());
        long elderlyCount = elderlyMapper.selectCount(new LambdaQueryWrapper<Elderly>()
                .eq(Elderly::getCareLevelId, levelId));
        if (elderlyCount > 0) {
            throw new BusinessException("该护理级别下存在关联老人，无法删除");
        }
        List<CareItem> items = careItemMapper.selectList(new LambdaQueryWrapper<CareItem>()
                .eq(CareItem::getCareLevelId, levelId));
        for (CareItem item : items) {
            relatedRecordCleanupService.removeCareRecordsByCareItemId(item.getId());
            careItemMapper.deleteById(item.getId());
        }
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
