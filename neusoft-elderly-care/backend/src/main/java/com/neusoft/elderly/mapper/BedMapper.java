package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.vo.BedVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BedMapper extends BaseMapper<Bed> {
    @Select("SELECT * FROM bed WHERE room_id = #{roomId}")
    List<Bed> selectByRoomId(Long roomId);

    @Select("SELECT * FROM bed WHERE status = 0")
    List<Bed> selectAvailableBeds();

    long countBedPage();

    long countOccupiedBedsExcludingMaintenance();

    List<BedVO> selectBedPage(@Param("offset") long offset, @Param("pageSize") long pageSize);
}
