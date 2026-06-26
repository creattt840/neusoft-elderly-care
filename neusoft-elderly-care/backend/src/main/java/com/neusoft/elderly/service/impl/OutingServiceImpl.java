package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.mapper.OutingMapper;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.OutingService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.vo.OutingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 外出记录服务实现
 */
@Service
public class OutingServiceImpl extends ServiceImpl<OutingMapper, Outing> implements OutingService {

    @Lazy
    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private PageCacheService pageCacheService;

    /** 查询全部外出记录 */
    @Override
    public List<OutingVO> listOutingVOs() {
        return buildOutingVOs(list());
    }

    /** 查询进行中的外出记录 */
    @Override
    public List<OutingVO> listActiveOutingVOs() {
        return buildOutingVOs(getActiveOutings());
    }

    /** 分页查询外出记录，缓存 */
    @Override
    @Cacheable(cacheNames = CacheNames.OUTING_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size, #status)")
    public PageResult<OutingVO> pageOutingVOs(Page<Outing> page, Integer status) {
        long total = baseMapper.countOutingPage(status);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<OutingVO> list = baseMapper.selectOutingPage(offset, page.getSize(), status);
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    /** 新增外出记录，清除缓存 */
    @Override
    public boolean save(Outing entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearOutingRelated();
        }
        return saved;
    }

    /** 更新外出记录，清除缓存 */
    @Override
    public boolean updateById(Outing entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearOutingRelated();
        }
        return updated;
    }

    /** 删除外出记录，清除缓存 */
    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearOutingRelated();
        }
        return removed;
    }

    /** 根据ID查询外出详情 */
    @Override
    public OutingVO getOutingVO(Long id) {
        Outing outing = getById(id);
        if (outing == null) {
            return null;
        }
        OutingVO vo = toOutingVO(outing);
        enrichElderlyInfo(List.of(vo));
        return vo;
    }

    /** 查询进行中的外出实体列表 */
    @Override
    public List<Outing> getActiveOutings() {
        return baseMapper.selectActiveOutings();
    }

    /** 记录外出归来 */
    @Override
    public void returnOuting(Long id) {
        Outing outing = getById(id);
        if (outing == null) {
            throw new BusinessException("外出记录不存在");
        }
        outing.setStatus(1);
        outing.setActualReturnTime(LocalDateTime.now());
        updateById(outing);
    }

    private List<OutingVO> buildOutingVOs(List<Outing> outings) {
        List<OutingVO> outingVOs = outings.stream()
                .map(this::toOutingVO)
                .collect(Collectors.toList());
        enrichElderlyInfo(outingVOs);
        return outingVOs;
    }

    private void enrichElderlyInfo(List<OutingVO> outingVOs) {
        Set<Long> elderlyIds = outingVOs.stream()
                .map(OutingVO::getElderlyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (elderlyIds.isEmpty()) {
            return;
        }
        Map<Long, Elderly> elderlyMap = elderlyService.listByIds(elderlyIds).stream()
                .collect(Collectors.toMap(Elderly::getId, elderly -> elderly));
        for (OutingVO outingVO : outingVOs) {
            if (outingVO.getElderlyId() == null) {
                continue;
            }
            Elderly elderly = elderlyMap.get(outingVO.getElderlyId());
            if (elderly != null) {
                outingVO.setElderlyName(elderly.getName());
                outingVO.setElderlyPhone(elderly.getPhone());
            }
        }
    }

    private OutingVO toOutingVO(Outing outing) {
        OutingVO vo = new OutingVO();
        vo.setId(outing.getId());
        vo.setElderlyId(outing.getElderlyId());
        vo.setOutingType(outing.getOutingType());
        vo.setStartTime(outing.getStartTime());
        vo.setExpectedReturnTime(outing.getExpectedReturnTime());
        vo.setActualReturnTime(outing.getActualReturnTime());
        vo.setAccompanier(outing.getAccompanier());
        vo.setAccompanierPhone(outing.getAccompanierPhone());
        vo.setDestination(outing.getDestination());
        vo.setReason(outing.getReason());
        vo.setStatus(outing.getStatus());
        vo.setCreateTime(outing.getCreateTime());
        return vo;
    }
}
