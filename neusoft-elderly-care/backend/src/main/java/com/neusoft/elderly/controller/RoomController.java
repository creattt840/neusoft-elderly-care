package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/room")
public class RoomController {

    @Autowired
    private RoomService roomService;

    @GetMapping("/list")
    public Result<List<Room>> list() {
        return Result.success(roomService.list());
    }

    @GetMapping("/page")
    public Result<Page<Room>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                   @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<Room> page = new Page<>(pageNum, pageSize);
        return Result.success(roomService.page(page));
    }

    @GetMapping("/{id}")
    public Result<Room> getById(@PathVariable Long id) {
        return Result.success(roomService.getById(id));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody Room room) {
        return Result.success(roomService.save(room));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody Room room) {
        return Result.success(roomService.updateById(room));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(roomService.removeById(id));
    }
}
