package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.vo.OutingVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface OutingMapper extends BaseMapper<Outing> {

    @Select("SELECT * FROM outing WHERE status = 0")
    List<Outing> selectActiveOutings();

    long countOutingPage(@Param("status") Integer status);

    List<OutingVO> selectOutingPage(@Param("offset") long offset,
                                    @Param("pageSize") long pageSize,
                                    @Param("status") Integer status);
}
