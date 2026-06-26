package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.service.OutingService;
import com.neusoft.elderly.vo.OutingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 外出记录管理接口
 */
@RestController
@RequestMapping("/api/outing")
public class OutingController {

    @Autowired
    private OutingService outingService;

    /** 查询所有外出记录 */
    @GetMapping("/list")
    public Result<List<OutingVO>> list() {
        return Result.success(outingService.listOutingVOs());
    }

    /** 查询进行中的外出记录 */
    @GetMapping("/active")
    public Result<List<OutingVO>> active() {
        return Result.success(outingService.listActiveOutingVOs());
    }

    /** 分页查询外出记录 */
    @GetMapping("/page")
    public Result<PageResult<OutingVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                             @RequestParam(defaultValue = "10") Integer pageSize,
                                             @RequestParam(required = false) Integer status) {
        Page<Outing> page = new Page<>(pageNum, pageSize);
        return Result.success(outingService.pageOutingVOs(page, status));
    }

    /** 查询外出记录详情 */
    @GetMapping("/{id}")
    public Result<OutingVO> getById(@PathVariable Long id) {
        return Result.success(outingService.getOutingVO(id));
    }

    /** 新增外出记录 */
    @PostMapping
    public Result<Boolean> save(@RequestBody Outing outing) {
        return Result.success(outingService.save(outing));
    }

    /** 更新外出记录 */
    @PutMapping
    public Result<Boolean> update(@RequestBody Outing outing) {
        return Result.success(outingService.updateById(outing));
    }

    /** 外出归来登记 */
    @PostMapping("/return/{id}")
    public Result<Boolean> returnOuting(@PathVariable Long id) {
        outingService.returnOuting(id);
        return Result.success(true);
    }

    /** 删除外出记录 */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(outingService.removeById(id));
    }
}
