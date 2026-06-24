package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.vo.BedVO;

import java.util.List;

public interface BedService extends IService<Bed> {

    List<BedVO> listBedVOs();

    PageResult<BedVO> pageBedVOs(Page<Bed> page);

    List<BedVO> getBedVOsByRoomId(Long roomId);

    List<BedVO> getAvailableBedVOs();

    BedVO getBedVO(Long id);

    void validateBedAssignable(Long bedId, Long elderlyId);

    long countAvailableBeds();

    long countOccupiedBeds();
}
