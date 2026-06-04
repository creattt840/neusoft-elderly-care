package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.service.OutingService;
import com.neusoft.elderly.vo.OutingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/outing")
public class OutingController {

    @Autowired
    private OutingService outingService;

    @GetMapping("/list")
    public Result<List<OutingVO>> list() {
        return Result.success(outingService.listOutingVOs());
    }

    @GetMapping("/active")
    public Result<List<OutingVO>> active() {
        return Result.success(outingService.listActiveOutingVOs());
    }

    @GetMapping("/page")
    public Result<PageResult<OutingVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                            @RequestParam(defaultValue = "10") Integer pageSize,
                                            @RequestParam(required = false) Integer status) {
        Page<Outing> page = new Page<>(pageNum, pageSize);
        return Result.success(outingService.pageOutingVOs(page, status));
    }

    @GetMapping("/{id}")
    public Result<OutingVO> getById(@PathVariable Long id) {
        return Result.success(outingService.getOutingVO(id));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody Outing outing) {
        return Result.success(outingService.save(outing));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody Outing outing) {
        return Result.success(outingService.updateById(outing));
    }

    @PostMapping("/return/{id}")
    public Result<Boolean> returnOuting(@PathVariable Long id) {
        outingService.returnOuting(id);
        return Result.success(true);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(outingService.removeById(id));
    }
}
