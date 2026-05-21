package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Outing;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface OutingMapper extends BaseMapper<Outing> {
    @Select("SELECT * FROM outing WHERE status = 0")
    List<Outing> selectActiveOutings();
}
