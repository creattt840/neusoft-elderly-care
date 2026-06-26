package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.vo.CareItemVO;

import java.util.List;

/**
 * 护理项目服务接口
 */
public interface CareItemService extends IService<CareItem> {

    /**
     * 根据护理等级ID查询护理项目列表
     */
    List<CareItemVO> listByCareLevelId(Long careLevelId);

    /**
     * 分页查询护理项目
     */
    PageResult<CareItemVO> pageCareItemVOs(Page<CareItem> page, Long careLevelId);
}
