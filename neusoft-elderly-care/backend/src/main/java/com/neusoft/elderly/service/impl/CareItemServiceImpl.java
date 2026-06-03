package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.mapper.CareItemMapper;
import com.neusoft.elderly.service.CareItemService;
import com.neusoft.elderly.vo.CareItemVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CareItemServiceImpl extends ServiceImpl<CareItemMapper, CareItem> implements CareItemService {

    @Override
    public List<CareItemVO> listByCareLevelId(Long careLevelId) {
        return baseMapper.selectCareItemList(careLevelId);
    }

    @Override
    public PageResult<CareItemVO> pageCareItemVOs(Page<CareItem> page, Long careLevelId) {
        long total = baseMapper.countCareItemPage(careLevelId);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<CareItemVO> list = baseMapper.selectCareItemPage(careLevelId, offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }
}
