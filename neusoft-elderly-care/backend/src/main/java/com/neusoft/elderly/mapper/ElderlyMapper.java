package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Elderly;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ElderlyMapper extends BaseMapper<Elderly> {
    @Select("SELECT * FROM elderly WHERE status = 1")
    List<Elderly> selectActiveElderly();

    @Select("SELECT COUNT(*) FROM elderly WHERE status = 1")
    Long countActiveElderly();

    @Select("SELECT COUNT(*) FROM elderly WHERE status = 2")
    Long countCheckedOutElderly();
}
