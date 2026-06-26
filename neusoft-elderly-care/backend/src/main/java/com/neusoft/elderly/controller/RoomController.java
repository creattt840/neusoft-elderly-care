package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.service.RoomService;
import com.neusoft.elderly.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 房间管理接口
 */
@RestController
@RequestMapping("/api/room")
public class RoomController {

    @Autowired
    private RoomService roomService;

    /** 查询所有房间 */
    @GetMapping("/list")
    public Result<List<RoomVO>> list() {
        return Result.success(roomService.listRoomVOs());
    }

    /** 分页查询房间 */
    @GetMapping("/page")
    public Result<PageResult<RoomVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                           @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<Room> page = new Page<>(pageNum, pageSize);
        return Result.success(roomService.pageRoomVOs(page));
    }

    /** 查询房间详情 */
    @GetMapping("/{id}")
    public Result<RoomVO> getById(@PathVariable Long id) {
        return Result.success(roomService.getRoomVO(id));
    }

    /** 新增房间 */
    @PostMapping
    public Result<Boolean> save(@RequestBody Room room) {
        return Result.success(roomService.save(room));
    }

    /** 更新房间 */
    @PutMapping
    public Result<Boolean> update(@RequestBody Room room) {
        return Result.success(roomService.updateById(room));
    }

    /** 删除房间 */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(roomService.removeById(id));
    }
}
