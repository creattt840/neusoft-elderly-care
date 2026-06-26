package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.vo.OutingVO;

import java.util.List;

/**
 * 外出记录服务接口
 */
public interface OutingService extends IService<Outing> {

    /**
     * 查询全部外出记录
     */
    List<OutingVO> listOutingVOs();

    /**
     * 查询当前在外的外出记录
     */
    List<OutingVO> listActiveOutingVOs();

    /**
     * 分页查询外出记录
     */
    PageResult<OutingVO> pageOutingVOs(Page<Outing> page, Integer status);

    /**
     * 根据ID查询外出记录详情
     */
    OutingVO getOutingVO(Long id);

    /**
     * 查询进行中的外出记录（实体列表）
     */
    List<Outing> getActiveOutings();

    /**
     * 记录老人外出归来
     */
    void returnOuting(Long id);
}
