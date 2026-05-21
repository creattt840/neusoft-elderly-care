package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Bed;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BedMapper extends BaseMapper<Bed> {
    @Select("SELECT * FROM bed WHERE room_id = #{roomId}")
    List<Bed> selectByRoomId(Long roomId);

    @Select("SELECT * FROM bed WHERE status = 0")
    List<Bed> selectAvailableBeds();
}
