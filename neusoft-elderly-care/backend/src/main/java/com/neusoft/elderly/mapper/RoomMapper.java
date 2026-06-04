package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.vo.RoomVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface RoomMapper extends BaseMapper<Room> {

    long countRoomPage();

    List<RoomVO> selectRoomPage(@Param("offset") long offset, @Param("pageSize") long pageSize);
}
