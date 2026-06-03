package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.vo.CareItemVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CareItemMapper extends BaseMapper<CareItem> {
    @Select("SELECT * FROM care_item WHERE care_level_id = #{careLevelId}")
    List<CareItem> selectByCareLevelId(Long careLevelId);

    long countCareItemPage(@Param("careLevelId") Long careLevelId);

    List<CareItemVO> selectCareItemPage(@Param("careLevelId") Long careLevelId,
                                        @Param("offset") long offset,
                                        @Param("pageSize") long pageSize);

    List<CareItemVO> selectCareItemList(@Param("careLevelId") Long careLevelId);
}
