package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.service.OutingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/outing")
public class OutingController {

    @Autowired
    private OutingService outingService;

    @GetMapping("/list")
    public Result<List<Outing>> list() {
        return Result.success(outingService.list());
    }

    @GetMapping("/active")
    public Result<List<Outing>> active() {
        return Result.success(outingService.getActiveOutings());
    }

    @GetMapping("/page")
    public Result<Page<Outing>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                     @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<Outing> page = new Page<>(pageNum, pageSize);
        return Result.success(outingService.page(page));
    }

    @GetMapping("/{id}")
    public Result<Outing> getById(@PathVariable Long id) {
        return Result.success(outingService.getById(id));
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
        Outing outing = outingService.getById(id);
        outing.setStatus(1);
        outing.setActualReturnTime(java.time.LocalDateTime.now());
        return Result.success(outingService.updateById(outing));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(outingService.removeById(id));
    }
}
