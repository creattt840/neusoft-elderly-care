package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.mapper.RoomMapper;
import com.neusoft.elderly.service.RoomService;
import com.neusoft.elderly.vo.RoomVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoomServiceImpl extends ServiceImpl<RoomMapper, Room> implements RoomService {

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
    public PageResult<RoomVO> pageRoomVOs(Page<Room> page) {
        Page<Room> result = baseMapper.selectPage(page, null);
        List<RoomVO> list = result.getRecords().stream()
                .map(this::toRoomVO)
                .collect(Collectors.toList());
        return PageResult.of(result, list);
    }

    private RoomVO toRoomVO(Room room) {
        RoomVO vo = new RoomVO();
        BeanUtils.copyProperties(room, vo);
        return vo;
    }
}
