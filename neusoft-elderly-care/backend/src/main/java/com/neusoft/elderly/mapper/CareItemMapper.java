package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.CareItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CareItemMapper extends BaseMapper<CareItem> {
    @Select("SELECT * FROM care_item WHERE care_level_id = #{careLevelId}")
    List<CareItem> selectByCareLevelId(Long careLevelId);
}
