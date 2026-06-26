package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.vo.RoomVO;

import java.util.List;

/**
 * 房间信息服务接口
 */
public interface RoomService extends IService<Room> {

    /**
     * 查询全部房间列表
     */
    List<RoomVO> listRoomVOs();

    /**
     * 根据ID查询房间详情
     */
    RoomVO getRoomVO(Long id);

    /**
     * 分页查询房间列表
     */
    PageResult<RoomVO> pageRoomVOs(Page<Room> page);
}
