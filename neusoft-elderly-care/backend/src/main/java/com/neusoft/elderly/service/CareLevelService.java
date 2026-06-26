package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.vo.CareLevelVO;

import java.util.List;

/**
 * 护理等级服务接口
 */
public interface CareLevelService extends IService<CareLevel> {

    /**
     * 查询全部护理等级列表
     */
    List<CareLevelVO> listCareLevelVOs();

    /**
     * 根据ID查询护理等级详情
     */
    CareLevelVO getCareLevelVO(Long id);
}
