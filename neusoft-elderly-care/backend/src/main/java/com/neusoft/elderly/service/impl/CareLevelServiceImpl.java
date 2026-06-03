package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.mapper.CareLevelMapper;
import com.neusoft.elderly.service.CareLevelService;
import com.neusoft.elderly.vo.CareLevelVO;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CareLevelServiceImpl extends ServiceImpl<CareLevelMapper, CareLevel> implements CareLevelService {

    @Override
    public List<CareLevelVO> listCareLevelVOs() {
        return list().stream().map(this::toCareLevelVO).collect(Collectors.toList());
    }

    @Override
    public CareLevelVO getCareLevelVO(Long id) {
        CareLevel careLevel = getById(id);
        return careLevel == null ? null : toCareLevelVO(careLevel);
    }

    private CareLevelVO toCareLevelVO(CareLevel careLevel) {
        CareLevelVO vo = new CareLevelVO();
        BeanUtils.copyProperties(careLevel, vo);
        return vo;
    }
}
