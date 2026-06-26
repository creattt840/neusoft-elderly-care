package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.mapper.CareItemMapper;
import com.neusoft.elderly.service.CareItemService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.RelatedRecordCleanupService;
import com.neusoft.elderly.vo.CareItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;

import java.util.List;

/**
 * 护理项目服务实现
 */
@Service
public class CareItemServiceImpl extends ServiceImpl<CareItemMapper, CareItem> implements CareItemService {

    @Autowired
    private PageCacheService pageCacheService;

    @Autowired
    private RelatedRecordCleanupService relatedRecordCleanupService;

    /** 根据护理等级ID查询项目 */
    @Override
    public List<CareItemVO> listByCareLevelId(Long careLevelId) {
        return baseMapper.selectCareItemList(careLevelId);
    }

    /** 分页查询护理项目，缓存 */
    @Override
    @Cacheable(cacheNames = CacheNames.CARE_ITEM_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size, #careLevelId)")
    public PageResult<CareItemVO> pageCareItemVOs(Page<CareItem> page, Long careLevelId) {
        long total = baseMapper.countCareItemPage(careLevelId);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<CareItemVO> list = baseMapper.selectCareItemPage(careLevelId, offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    /** 新增护理项目，清除缓存 */
    @Override
    public boolean save(CareItem entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearCareItemRelated();
        }
        return saved;
    }

    /** 更新护理项目，清除缓存 */
    @Override
    public boolean updateById(CareItem entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearCareItemRelated();
        }
        return updated;
    }

    /** 删除护理项目，清除缓存 */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeById(Serializable id) {
        relatedRecordCleanupService.removeCareRecordsByCareItemId(Long.valueOf(id.toString()));
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearCareItemRelated();
        }
        return removed;
    }
}
