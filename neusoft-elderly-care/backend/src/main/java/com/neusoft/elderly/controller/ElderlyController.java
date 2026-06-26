package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.StatisticsService;
import com.neusoft.elderly.vo.BedVO;
import com.neusoft.elderly.vo.ElderlyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 老人信息管理接口
 */
@RestController
@RequestMapping("/api/elderly")
public class ElderlyController {

    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private StatisticsService statisticsService;

    /** 分页查询老人信息 */
    @GetMapping("/page")
    public Result<PageResult<ElderlyVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                              @RequestParam(defaultValue = "10") Integer pageSize,
                                              @RequestParam(required = false) String name,
                                              @RequestParam(required = false) Integer status) {
        Page<Elderly> page = new Page<>(pageNum, pageSize);
        return Result.success(elderlyService.pageWithInfo(page, name, status));
    }

    /** 老人数量统计 */
    @GetMapping("/statistics")
    public Result<java.util.Map<String, Object>> statistics() {
        return Result.success(statisticsService.getElderlyCountStatistics());
    }

    /** 编辑时可用的床位列表 */
    @GetMapping("/{id}/available-beds")
    public Result<List<BedVO>> availableBeds(@PathVariable Long id) {
        return Result.success(elderlyService.getAvailableBedsForEdit(id));
    }

    /** 查询老人详情 */
    @GetMapping("/{id}")
    public Result<ElderlyVO> getById(@PathVariable Long id) {
        return Result.success(elderlyService.getDetail(id));
    }

    /** 新增老人 */
    @PostMapping
    public Result<Boolean> save(@RequestBody Elderly elderly) {
        return Result.success(elderlyService.save(elderly));
    }

    /** 更新老人信息 */
    @PutMapping
    public Result<Boolean> update(@RequestBody Elderly elderly) {
        elderlyService.updateElderly(elderly);
        return Result.success(true);
    }

    /** 删除老人 */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        elderlyService.removeElderly(id);
        return Result.success(true);
    }

    /** 老人入住 */
    @PostMapping("/check-in")
    public Result<Boolean> checkIn(@RequestBody Elderly elderly, @RequestParam Long bedId) {
        elderlyService.checkIn(elderly, bedId);
        return Result.success(true);
    }

    /** 老人退住 */
    @PostMapping("/check-out/{id}")
    public Result<Boolean> checkOut(@PathVariable Long id) {
        elderlyService.checkOut(id);
        return Result.success(true);
    }
}
