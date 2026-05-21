package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.service.BedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bed")
public class BedController {

    @Autowired
    private BedService bedService;

    @GetMapping("/list")
    public Result<List<Bed>> list() {
        return Result.success(bedService.list());
    }

    @GetMapping("/available")
    public Result<List<Bed>> available() {
        return Result.success(bedService.getAvailableBeds());
    }

    @GetMapping("/room/{roomId}")
    public Result<List<Bed>> getByRoomId(@PathVariable Long roomId) {
        return Result.success(bedService.getBedsByRoomId(roomId));
    }

    @GetMapping("/page")
    public Result<Page<Bed>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                  @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<Bed> page = new Page<>(pageNum, pageSize);
        return Result.success(bedService.page(page));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody Bed bed) {
        return Result.success(bedService.save(bed));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody Bed bed) {
        return Result.success(bedService.updateById(bed));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(bedService.removeById(id));
    }
}
