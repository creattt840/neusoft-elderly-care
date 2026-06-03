package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.vo.CareLevelVO;

import java.util.List;

public interface CareLevelService extends IService<CareLevel> {

    List<CareLevelVO> listCareLevelVOs();

    CareLevelVO getCareLevelVO(Long id);
}
