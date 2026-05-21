package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.service.ElderlyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/elderly")
public class ElderlyController {

    @Autowired
    private ElderlyService elderlyService;

    @GetMapping("/page")
    public Result<Page<Elderly>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                       @RequestParam(defaultValue = "10") Integer pageSize,
                                       @RequestParam(required = false) String name,
                                       @RequestParam(required = false) Integer status) {
        Page<Elderly> page = new Page<>(pageNum, pageSize);
        return Result.success(elderlyService.page(page));
    }

    @GetMapping("/{id}")
    public Result<Elderly> getById(@PathVariable Long id) {
        return Result.success(elderlyService.getById(id));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody Elderly elderly) {
        return Result.success(elderlyService.save(elderly));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody Elderly elderly) {
        return Result.success(elderlyService.updateById(elderly));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(elderlyService.removeById(id));
    }

    @PostMapping("/check-in")
    public Result<Boolean> checkIn(@RequestBody Elderly elderly, @RequestParam Long bedId) {
        elderlyService.checkIn(elderly, bedId);
        return Result.success(true);
    }

    @PostMapping("/check-out/{id}")
    public Result<Boolean> checkOut(@PathVariable Long id) {
        elderlyService.checkOut(id);
        return Result.success(true);
    }

    @GetMapping("/statistics")
    public Result<java.util.Map<String, Object>> statistics() {
        java.util.Map<String, Object> map = new java.util.HashMap<>();
        map.put("activeCount", elderlyService.countActiveElderly());
        map.put("checkedOutCount", elderlyService.countCheckedOutElderly());
        return Result.success(map);
    }
}
