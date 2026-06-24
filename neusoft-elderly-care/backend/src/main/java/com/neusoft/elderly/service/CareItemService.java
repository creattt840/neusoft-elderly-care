package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.vo.CareItemVO;

import java.util.List;

public interface CareItemService extends IService<CareItem> {

    List<CareItemVO> listByCareLevelId(Long careLevelId);

    PageResult<CareItemVO> pageCareItemVOs(Page<CareItem> page, Long careLevelId);
}
