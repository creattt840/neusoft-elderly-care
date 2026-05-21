package com.neusoft.elderly.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.neusoft.elderly.entity.ServiceInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ServiceMapper extends BaseMapper<ServiceInfo> {
    @Select("SELECT * FROM service WHERE status = 1")
    List<ServiceInfo> selectActiveServices();
}
