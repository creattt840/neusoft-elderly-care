package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.vo.BedVO;
import com.neusoft.elderly.vo.ElderlyVO;

import java.util.List;

/**
 * 老人信息服务接口
 */
public interface ElderlyService extends IService<Elderly> {

    /**
     * 分页查询老人列表（含床位信息）
     */
    PageResult<ElderlyVO> pageWithInfo(Page<Elderly> page, String name, Integer status);

    /**
     * 根据ID获取老人详情
     */
    ElderlyVO getDetail(Long id);

    /**
     * 获取老人编辑时可选的床位列表
     */
    List<BedVO> getAvailableBedsForEdit(Long elderlyId);

    /**
     * 老人入住
     */
    void checkIn(Elderly elderly, Long bedId);

    /**
     * 更新老人信息
     */
    void updateElderly(Elderly elderly);

    /**
     * 老人退住
     */
    void checkOut(Long elderlyId);

    /**
     * 删除老人信息（含床位释放）
     */
    void removeElderly(Long id);

    /**
     * 统计在住老人数量
     */
    Long countActiveElderly();

    /**
     * 统计已退住老人数量
     */
    Long countCheckedOutElderly();
}
