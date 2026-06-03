package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.vo.BedVO;
import com.neusoft.elderly.vo.ElderlyVO;

import java.util.List;

public interface ElderlyService extends IService<Elderly> {

    PageResult<ElderlyVO> pageWithInfo(Page<Elderly> page, String name, Integer status);

    ElderlyVO getDetail(Long id);

    List<BedVO> getAvailableBedsForEdit(Long elderlyId);

    void checkIn(Elderly elderly, Long bedId);

    void updateElderly(Elderly elderly);

    void checkOut(Long elderlyId);

    void removeElderly(Long id);

    Long countActiveElderly();

    Long countCheckedOutElderly();
}
