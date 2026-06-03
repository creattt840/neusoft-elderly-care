package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.vo.OutingVO;

import java.util.List;

public interface OutingService extends IService<Outing> {

    List<OutingVO> listOutingVOs();

    List<OutingVO> listActiveOutingVOs();

    PageResult<OutingVO> pageOutingVOs(Page<Outing> page);

    OutingVO getOutingVO(Long id);

    List<Outing> getActiveOutings();

    void returnOuting(Long id);
}
