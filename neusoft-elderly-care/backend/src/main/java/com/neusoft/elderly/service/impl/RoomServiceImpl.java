package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.mapper.BedMapper;
import com.neusoft.elderly.mapper.RoomMapper;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.RelatedRecordCleanupService;
import com.neusoft.elderly.service.RoomService;
import com.neusoft.elderly.vo.RoomVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 房间信息服务实现
 */
@Service
public class RoomServiceImpl extends ServiceImpl<RoomMapper, Room> implements RoomService {

    @Autowired
    private PageCacheService pageCacheService;

    @Autowired
    private BedMapper bedMapper;

    @Autowired
    private RelatedRecordCleanupService relatedRecordCleanupService;

    /** 查询全部房间列表 */
    @Override
    public List<RoomVO> listRoomVOs() {
        return list().stream().map(this::toRoomVO).collect(Collectors.toList());
    }

    /** 根据ID查询房间详情 */
    @Override
    public RoomVO getRoomVO(Long id) {
        Room room = getById(id);
        return room == null ? null : toRoomVO(room);
    }

    /** 分页查询房间列表，缓存 */
    @Override
    @Cacheable(cacheNames = CacheNames.ROOM_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size)")
    public PageResult<RoomVO> pageRoomVOs(Page<Room> page) {
        long total = baseMapper.countRoomPage();
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<RoomVO> list = baseMapper.selectRoomPage(offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    /** 新增房间，清除缓存 */
    @Override
    public boolean save(Room entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearRoomRelated();
        }
        return saved;
    }

    /** 更新房间，清除缓存 */
    @Override
    public boolean updateById(Room entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearRoomRelated();
        }
        return updated;
    }

    /** 删除房间（含空床位），清除缓存 */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeById(Serializable id) {
        Long roomId = Long.valueOf(id.toString());
        List<Bed> beds = bedMapper.selectByRoomId(roomId);
        for (Bed bed : beds) {
            assertBedDeletable(bed);
        }
        for (Bed bed : beds) {
            relatedRecordCleanupService.removeCheckRecordsByBedId(bed.getId());
            bedMapper.deleteById(bed.getId());
        }
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearRoomRelated();
        }
        return removed;
    }

    private void assertBedDeletable(Bed bed) {
        if (bed.getStatus() != null && bed.getStatus() == 1) {
            throw new BusinessException("该房间存在在住床位，无法删除");
        }
        if (bed.getElderlyId() != null) {
            throw new BusinessException("该房间存在关联老人，无法删除");
        }
    }

    private RoomVO toRoomVO(Room room) {
        RoomVO vo = new RoomVO();
        BeanUtils.copyProperties(room, vo);
        return vo;
    }
}
