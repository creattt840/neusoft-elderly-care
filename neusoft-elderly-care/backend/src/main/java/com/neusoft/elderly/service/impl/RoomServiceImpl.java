package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.mapper.RoomMapper;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.RoomService;
import com.neusoft.elderly.vo.RoomVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoomServiceImpl extends ServiceImpl<RoomMapper, Room> implements RoomService {

    @Autowired
    private PageCacheService pageCacheService;

    @Override
    public List<RoomVO> listRoomVOs() {
        return list().stream().map(this::toRoomVO).collect(Collectors.toList());
    }

    @Override
    public RoomVO getRoomVO(Long id) {
        Room room = getById(id);
        return room == null ? null : toRoomVO(room);
    }

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

    @Override
    public boolean save(Room entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearRoomRelated();
        }
        return saved;
    }

    @Override
    public boolean updateById(Room entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearRoomRelated();
        }
        return updated;
    }

    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearRoomRelated();
        }
        return removed;
    }

    private RoomVO toRoomVO(Room room) {
        RoomVO vo = new RoomVO();
        BeanUtils.copyProperties(room, vo);
        return vo;
    }
}
