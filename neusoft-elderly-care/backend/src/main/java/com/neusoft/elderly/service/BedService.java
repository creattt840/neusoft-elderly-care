package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.vo.BedVO;

import java.util.List;

/**
 * 床位信息服务接口
 */
public interface BedService extends IService<Bed> {

    /**
     * 查询全部床位列表（含老人信息）
     */
    List<BedVO> listBedVOs();

    /**
     * 分页查询床位列表
     */
    PageResult<BedVO> pageBedVOs(Page<Bed> page);

    /**
     * 根据房间ID查询床位列表
     */
    List<BedVO> getBedVOsByRoomId(Long roomId);

    /**
     * 查询全部可用床位
     */
    List<BedVO> getAvailableBedVOs();

    /**
     * 根据ID查询床位详情
     */
    BedVO getBedVO(Long id);

    /**
     * 校验床位是否可分配
     */
    void validateBedAssignable(Long bedId, Long elderlyId);

    /**
     * 统计可用床位数量
     */
    long countAvailableBeds();

    /**
     * 统计已占用床位数量（排除维修中房间）
     */
    long countOccupiedBeds();
}
