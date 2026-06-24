package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.vo.RoomVO;

import java.util.List;

public interface RoomService extends IService<Room> {

    List<RoomVO> listRoomVOs();

    RoomVO getRoomVO(Long id);

    PageResult<RoomVO> pageRoomVOs(Page<Room> page);
}
