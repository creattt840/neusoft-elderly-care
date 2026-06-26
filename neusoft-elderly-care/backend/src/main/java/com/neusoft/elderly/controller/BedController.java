package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.service.BedService;
import com.neusoft.elderly.vo.BedVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 床位管理接口
 */
@RestController
@RequestMapping("/api/bed")
public class BedController {

    @Autowired
    private BedService bedService;

    /** 查询所有床位 */
    @GetMapping("/list")
    public Result<List<BedVO>> list() {
        return Result.success(bedService.listBedVOs());
    }

    /** 查询空闲床位 */
    @GetMapping("/available")
    public Result<List<BedVO>> available() {
        return Result.success(bedService.getAvailableBedVOs());
    }

    /** 根据房间ID查询床位 */
    @GetMapping("/room/{roomId}")
    public Result<List<BedVO>> getByRoomId(@PathVariable Long roomId) {
        return Result.success(bedService.getBedVOsByRoomId(roomId));
    }

    /** 分页查询床位 */
    @GetMapping("/page")
    public Result<PageResult<BedVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                          @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<Bed> page = new Page<>(pageNum, pageSize);
        return Result.success(bedService.pageBedVOs(page));
    }

    /** 新增床位 */
    @PostMapping
    public Result<Boolean> save(@RequestBody Bed bed) {
        return Result.success(bedService.save(bed));
    }

    /** 更新床位 */
    @PutMapping
    public Result<Boolean> update(@RequestBody Bed bed) {
        return Result.success(bedService.updateById(bed));
    }

    /** 删除床位 */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(bedService.removeById(id));
    }
}
