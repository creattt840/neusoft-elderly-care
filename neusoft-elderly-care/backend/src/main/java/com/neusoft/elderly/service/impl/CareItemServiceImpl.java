package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.mapper.CareItemMapper;
import com.neusoft.elderly.service.CareItemService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.vo.CareItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CareItemServiceImpl extends ServiceImpl<CareItemMapper, CareItem> implements CareItemService {

    @Autowired
    private PageCacheService pageCacheService;

    @Override
    public List<CareItemVO> listByCareLevelId(Long careLevelId) {
        return baseMapper.selectCareItemList(careLevelId);
    }

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

    @Override
    public boolean save(CareItem entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearCareItemRelated();
        }
        return saved;
    }

    @Override
    public boolean updateById(CareItem entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearCareItemRelated();
        }
        return updated;
    }

    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearCareItemRelated();
        }
        return removed;
    }
}
